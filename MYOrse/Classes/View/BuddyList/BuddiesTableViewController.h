//
//  BuddiesTableViewController.h
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuddyPickerDelegate <NSObject>

-(void)buddyPickedWithEmail:(NSString*)email;

@end

@interface BuddiesTableViewController : UITableViewController

@property (weak, nonatomic) id <BuddyPickerDelegate> delegate;

@end
