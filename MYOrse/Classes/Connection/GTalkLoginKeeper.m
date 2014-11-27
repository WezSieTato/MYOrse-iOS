//
//  GTalkLoginKeeper.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 24/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "GTalkLoginKeeper.h"
#import <Security/Security.h>
#import "MSKeychainManager.h"

NSString* const kGTalkLoginKey = @"kGTalkLoginKey";
NSString* const kGTalkRememberKey = @"kGTalkRememberKey";

@interface GTalkLoginKeeper ()
@property (nonatomic, readonly) NSString* kGTalkSerwer;
@property (nonatomic, readonly) NSString* kGTalkRememberKey;


@end

@implementation GTalkLoginKeeper

#pragma mark - Constants

-(NSString*)kGTalkSerwer{
    return @"GoogleTalk";
}

-(NSString*)kGTalkRememberKey{
    return @"kGTalkRememberKey";
}

#pragma mark - Instance Method

-(instancetype)init{
    self = [super init];
    if(self){
        if(self.isRemember){
            [self getCredentials];
        }
        
    }
    
    return self;
}

-(void)saveToDisk{
    [self saveUsername:self.login withPassword:self.password];
    [self setRemember:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)eraseData{
    [self setRemember:NO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeAllCredentials];
}

#pragma mark - Properties

-(void)setRemember:(BOOL)remember{
    [[NSUserDefaults standardUserDefaults] setBool:remember forKey:self.kGTalkRememberKey];
}

-(BOOL)isRemember{
    return [[NSUserDefaults standardUserDefaults] boolForKey:self.kGTalkRememberKey];
}

#pragma mark - Keychain Access

-(void) saveUsername:(NSString*)user withPassword:(NSString*)pass{

    [[MSKeychainManager new] saveUsername:user withPassword:pass forServer:self.kGTalkSerwer];
    
}

-(void) removeAllCredentials {
    [[MSKeychainManager new] removeAllCredentialsForServer:self.kGTalkSerwer];
    
}

-(void) getCredentials{
    MSPair *pair = [[MSKeychainManager new] getCredentialsForServer:self.kGTalkSerwer];
    _login = pair.first;
    _password = pair.second;
}



@end
