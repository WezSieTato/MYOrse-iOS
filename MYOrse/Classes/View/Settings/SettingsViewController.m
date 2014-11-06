//
//  SettingsViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "SettingsViewController.h"
#import "StartViewController.h"

@interface SettingsViewController (){
    
}


@property (strong, nonatomic) XMPPStream* calibrateStream;
@end

@implementation SettingsViewController


-(void)viewDidLoad{
    [super viewDidLoad];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
}
- (IBAction)calibrate:(id)sender {
    NSLog(@"Calibrate clicked");
    
    _calibrateStream = [[XMPPStream alloc] initWithFacebookAppId:@"732832850124501"];
    [_calibrateStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [_calibrateStream connectWithTimeout:100 error:&error];
    
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"XMPP authentication failed");
}

//-(void)xmm

-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    if (![_calibrateStream isSecure])
    {
        NSLog(@"XMPP STARTTLS...");
        NSError *error = nil;
        BOOL result = [_calibrateStream secureConnection:&error];
        
        if (result == NO)
        {
            NSLog(@"XMPP STARTTLS failed");
        }
    }
    else
    {
        FBSession* session = [FBSession activeSession];
        [session requestNewReadPermissions:[NSArray arrayWithObject:@"xmpp_login"]
                         completionHandler:^(FBSession *session, NSError *error) {
                             
                             NSLog(@"XMPP X-FACEBOOK-PLATFORM SASL...");
                             NSError *error1 = nil;
                             BOOL result = [_calibrateStream authenticateWithFacebookAccessToken: [[session accessTokenData] accessToken]
                                                                                           error:&error1];
                             
                             if (result == NO)
                             {
                                 NSLog(@"XMPP authentication failed");
                             }
                         }];
    }
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    
    if (NO)
    {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    }
    
    if (NO)
    {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else
    {
        NSString *expectedCertName = [sender hostName];
        if (expectedCertName == nil)
        {
            expectedCertName = [[sender myJID] domain];
        }
        
        [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"siema %s", __PRETTY_FUNCTION__);
}

//-(void)x

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"XMPP disconnected");
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"NotRester");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    // we recived message
    NSLog(@"wiadomosc");
}

-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSLog(@"PresencE");
}

//-(void)xmpp

- (IBAction)logout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    [self presentViewController:next animated:YES completion:nil];
}


@end
