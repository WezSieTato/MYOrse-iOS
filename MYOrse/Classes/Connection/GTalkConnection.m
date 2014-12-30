//
//  GTalkConnection.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "GTalkConnection.h"
#import "GTalkXMPP.h"
#import "GTalkLoginKeeper.h"

#import "XMPPJID+GTalk.h"
#import <MSLittleMagic/MSPair.h>
#import "XMPPPresence+GTalk.h"

NSString* const NOTIFICATION_MESSAGE_RECEIVED = @"notificationMessageReceived";


@interface GTalkConnection () < XMPPStreamDelegate >{
    NSMutableDictionary* _buddysArray;
}

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPRoster *roster;
@property (strong, nonatomic) XMPPRosterMemoryStorage *rosterStorage;
@property (strong, nonatomic) XMPPMessageArchiving *messageArchive;
@property (strong, nonatomic) XMPPMessageArchivingCoreDataStorage *messageArchiveStorage;
@property (strong, nonatomic) XMPPvCardCoreDataStorage *avatarStorage;
@property (strong, nonatomic) XMPPvCardTempModule *avatarTemp;
@property (strong, nonatomic) XMPPvCardAvatarModule *avatarCards;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;

@property (copy, nonatomic) NSString *tempPassword;
@property (strong, nonatomic) GTalkConnectionLoginHandler loginHandler;

@end

@implementation GTalkConnection

static GTalkConnection *SINGLETON = nil;


#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SINGLETON = [[self alloc] init];
    });
    
    return SINGLETON;
}


- (id) init
{
    if (self = [super init]) {
        _buddysArray = [NSMutableDictionary new];
    }
    return self;
}

- (void)setupStream
{
    if (!self.xmppStream)
    {
        NSLog(@"Setup");
        self.xmppStream = [XMPPStream new];
        [self.xmppStream setHostName:@"talk.google.com"];
        [self.xmppStream setHostPort:5222];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // Modules
        // Reconnect Automatically
        self.xmppReconnect = [XMPPReconnect new];
        [self.xmppReconnect activate:self.xmppStream];
        
        // Roster Setup
        self.rosterStorage = [XMPPRosterMemoryStorage new];
        self.roster = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage];
        [self.roster activate:[self xmppStream]];
        
        // Message archive
        self.messageArchiveStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.messageArchive = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.messageArchiveStorage];
        [self.messageArchive activate:self.xmppStream];
        
        // vCard
        self.avatarStorage = [XMPPvCardCoreDataStorage sharedInstance];
        self.avatarTemp = [[XMPPvCardTempModule alloc] initWithvCardStorage:self.avatarStorage];
        self.avatarCards = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:self.avatarTemp];
        [self.avatarCards activate:[self xmppStream]];
    }
}

-(BOOL)loginWithLastLoginHandler:(GTalkConnectionLoginHandler)handler{
    GTalkLoginKeeper* keeper = [GTalkLoginKeeper new];
    if(!keeper.isRemember)
        return true;
    
    return [self loginWithUsername:keeper.login andPassword:keeper.password remember:NO andHandler:handler];
}

- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password
                 remember:(BOOL)remember
               andHandler:(GTalkConnectionLoginHandler)handler
{
    NSLog(@"connect xmpp");
    
    [self setupStream];
    self.loginHandler = handler;
    
    // If already connected, return true
    if ([self isConnected]) {
        NSLog(@"Already connected!");
        [self callLoginHandler:YES];
        return YES;
    }
    
    
    // Set username and try to connect
    self.tempPassword = password;
    [self.xmppStream setMyJID:[XMPPJID jidWithString:username]];
    NSError *error;
    if (![self.xmppStream connectWithTimeout:8 error:&error])
    {
        NSLog(@"connect failed@");
        [self callLoginHandler:NO];

        return NO;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"connected!");
    
    if(remember){
        GTalkLoginKeeper* keeper = [ GTalkLoginKeeper new];
        keeper.login = username;
        keeper.password = password;
        [keeper saveToDisk];
    }
    
    return YES;
}

-(void)logout{
    [[GTalkLoginKeeper new] eraseData];
    [self goOffline];
    [self.xmppStream disconnect];
}

-(void)sendMessageTo:(NSString *)email withBody:(NSString *)body{
    XMPPMessage *message = [[XMPPMessage alloc] initWithType:XMPP_MESSAGE_TYPE_CHAT to:_buddysArray[email]];
    [message addBody:body];
    [self.xmppStream sendElement:message];
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"goOnline: %@", presence);
    [self.xmppStream sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence unavailablePresence];
    NSLog(@"goOffline: %@", presence);
    [self.xmppStream sendElement:presence];
}

-(void)addBuddy:(XMPPJID*)buddy{
    if([_buddysArray objectForKey:[buddy bare]])
        return;
    
    _buddysArray[[buddy bare]] = buddy;
}

-(void)removeBuddy:(XMPPJID*)buddy{
    [_buddysArray removeObjectForKey:[buddy bare]];
}

#pragma mark - Properties

-(BOOL)isConnected
{
    NSLog(@"isConnected: %i", ![self.xmppStream isDisconnected]);
    
    // If stream is not disconnected, it is either establishing connection or connected
    return ![self.xmppStream isDisconnected];
}

-(BOOL)isRemember{
    return [[GTalkLoginKeeper new] isRemember];
}

-(BOOL)isVisible{
    return self.xmppStream.myPresence.isVisible;
}

-(void)setVisible:(BOOL)visible{
    if(self.isVisible == visible)
        return;
    XMPPPresence *presence = visible ? [XMPPPresence presence] : [XMPPPresence invisiblePresence];
    [self.xmppStream sendElement:presence];
}

-(NSString*)username{
    return self.xmppStream.myJID.bare;
}

-(NSArray*)buddyList{
    return [[_buddysArray allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.xmppStream setEnableBackgroundingOnSocket:YES];

    NSError *error = nil;
    if (![[self xmppStream] authenticateWithPassword:self.tempPassword error:&error])
    {
        NSLog(@"ERROR: Could not authenticate! %@", error);
        
        // Clear temp password
        self.tempPassword = nil;
        
        
        [[self xmppStream] disconnect];
    }

}

- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self callLoginHandler:YES];
    [self goOnline];

}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self callLoginHandler:NO];

}

-(void)callLoginHandler:(BOOL)succes{
    if(self.loginHandler){
        self.loginHandler(succes);
    }
    
    self.loginHandler = nil;
    self.tempPassword = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    XMPPJID* user = [presence from];
    if(![user isEqualToJID:[sender myJID]]){
        
        if ([presence isAvailable]) {
            [self addBuddy:user];
            
        } else if ([presence isUnavailable]) {
            [self removeBuddy:user];
            
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([message body] && [[message type] isEqualToString:XMPP_MESSAGE_TYPE_CHAT])
    {
        MSPair* pair = [MSPair new];
        pair.first = [[message from] bare];
        pair.second = [message body];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:NOTIFICATION_MESSAGE_RECEIVED
         object:pair userInfo:nil];
        NSLog(@"Siema: %@", message.body);
    }
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [settings setObject:@YES forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    
    // Allow host name mismatches
    [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
}

-(void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [sender setEnableBackgroundingOnSocket:YES];
    
}


@end
