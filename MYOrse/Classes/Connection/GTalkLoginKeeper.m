//
//  GTalkLoginKeeper.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 24/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "GTalkLoginKeeper.h"
#import <Security/Security.h>

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
    NSString* server = self.kGTalkSerwer;
    // Create dictionary of search parameters
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword),  kSecClass, server, kSecAttrServer, kCFBooleanTrue, kSecReturnAttributes, nil];
    
    // Remove any old values from the keychain
    OSStatus err = SecItemDelete((__bridge CFDictionaryRef) dict);
    
    // Create dictionary of parameters to add
    NSData* passwordData = [pass dataUsingEncoding:NSUTF8StringEncoding];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword), kSecClass, server, kSecAttrServer, passwordData, kSecValueData, user, kSecAttrAccount, nil];
    
    // Try to save to keychain
    err = SecItemAdd((__bridge CFDictionaryRef) dict, NULL);
    
}

-(void) removeAllCredentials {
    NSString* server = self.kGTalkSerwer;

    // Create dictionary of search parameters
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword),  kSecClass, server, kSecAttrServer, kCFBooleanTrue, kSecReturnAttributes, kCFBooleanTrue, kSecReturnData, nil];
    
    // Remove any old values from the keychain
//    OSStatus err =
    SecItemDelete((__bridge CFDictionaryRef) dict);
    
}

-(void) getCredentials{
    NSString* server = self.kGTalkSerwer;

    // Create dictionary of search parameters
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword),  kSecClass, server, kSecAttrServer, kCFBooleanTrue, kSecReturnAttributes, kCFBooleanTrue, kSecReturnData, nil];
    
    // Look up server in the keychain
    NSDictionary* found = nil;
    CFDictionaryRef foundCF;
//    OSStatus err =
    SecItemCopyMatching((__bridge CFDictionaryRef) dict, (CFTypeRef*)&foundCF);
    
    found = (__bridge NSDictionary*)(foundCF);
    if (!found) return;
    
    // Found
    NSString* user = (NSString*) [found objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString* pass = [[NSString alloc] initWithData:[found objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
    
    _login = user;
    _password = pass;
}



@end
