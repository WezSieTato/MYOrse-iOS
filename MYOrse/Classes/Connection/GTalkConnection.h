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

/**
 * gets singleton object.
 * @return singleton
 */
+ (GTalkConnection*)sharedInstance;

- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password
               andHandler:(GTalkConnectionLoginHandler)handler;

@end
