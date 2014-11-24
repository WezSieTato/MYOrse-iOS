//
//  GTalkLoginKeeper.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 24/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTalkLoginKeeper : NSObject

@property (nonatomic, readonly, getter=isRemember) BOOL remember;
@property (nonatomic) NSString* login;
@property (nonatomic) NSString* password;

-(void)saveToDisk;
-(void)eraseData;

@end
