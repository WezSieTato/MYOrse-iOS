//
//  GTalkConnection.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GTalkConnectionLoginHandler)(BOOL succes);

@interface GTalkConnection : NSObject

@property (readonly, nonatomic) NSString* username;
@property (readonly, nonatomic) BOOL isConnected;
@property (readonly, nonatomic) BOOL isRemember;

/**
 * gets singleton object.
 * @return singleton
 */
+ (GTalkConnection*)sharedInstance;

-(BOOL)loginWithLastLoginHandler:(GTalkConnectionLoginHandler)handler;
- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password
                 remember:(BOOL)remember
               andHandler:(GTalkConnectionLoginHandler)handler;
-(void)logout;

@end
