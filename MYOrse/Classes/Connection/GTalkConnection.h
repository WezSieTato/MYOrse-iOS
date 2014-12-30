//
//  GTalkConnection.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const NOTIFICATION_MESSAGE_RECEIVED;
typedef void (^GTalkConnectionLoginHandler)(BOOL succes);

@interface GTalkConnection : NSObject

@property (readonly, nonatomic) NSString* username;
@property (readonly, nonatomic) BOOL isConnected;
@property (readonly, nonatomic) BOOL isRemember;
@property (readonly, nonatomic) NSArray* buddyList;
@property (getter=isVisible, nonatomic) BOOL visible;

+ (GTalkConnection*)sharedInstance;

-(BOOL)loginWithLastLoginHandler:(GTalkConnectionLoginHandler)handler;
- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password
                 remember:(BOOL)remember
               andHandler:(GTalkConnectionLoginHandler)handler;
-(void)logout;
-(void)sendMessageTo:(NSString*)email withBody:(NSString*)body;
@end
