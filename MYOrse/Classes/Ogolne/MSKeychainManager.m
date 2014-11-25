//
//  MSKeychainManager.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MSKeychainManager.h"
#import <Security/Security.h>

@implementation MSKeychainManager

-(void) saveUsername:(NSString*)user withPassword:(NSString*)pass forServer:(NSString*)server {
    
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

-(void) removeAllCredentialsForServer:(NSString*)server {
    
    // Create dictionary of search parameters
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword),  kSecClass, server, kSecAttrServer, kCFBooleanTrue, kSecReturnAttributes, kCFBooleanTrue, kSecReturnData, nil];
    
    // Remove any old values from the keychain
//    OSStatus err =
    SecItemDelete((__bridge CFDictionaryRef) dict);
}

-(MSPair*)getCredentialsForServer:(NSString*)server {
    
    // Create dictionary of search parameters
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassInternetPassword),  kSecClass, server, kSecAttrServer, kCFBooleanTrue, kSecReturnAttributes, kCFBooleanTrue, kSecReturnData, nil];
    
    // Look up server in the keychain
    NSDictionary* found = nil;
    CFDictionaryRef foundCF;
//    OSStatus err =
    SecItemCopyMatching((__bridge CFDictionaryRef) dict, (CFTypeRef*)&foundCF);
    
    found = (__bridge NSDictionary*)(foundCF);
    if (!found) return nil;
    
    // Found
    NSString* user = (NSString*) [found objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString* pass = [[NSString alloc] initWithData:[found objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
    return [MSPair pairWithFirst:user andSecond:pass];
}

@end
