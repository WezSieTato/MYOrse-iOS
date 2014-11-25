//
//  MainViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 22/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MainViewController.h"
#import "GTalkConnection.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUser;

@end

@implementation MainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    GTalkConnection* gtalk = [GTalkConnection sharedInstance];
    _lblUser.text = gtalk.username;
    
}
- (IBAction)switchedWidocznosc:(UISwitch *)sender {
    [[GTalkConnection sharedInstance] setVisible:[sender isOn]];
}

-(IBAction)logout:(id)sender{
    [[GTalkConnection sharedInstance] logout];
    
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)buddyPickedWithEmail:(NSString *)email{
    _lblOtherUser.text = email ? : @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BuddiesTableViewController class]]){
        ((BuddiesTableViewController*)segue.destinationViewController).delegate = self;
    }
}

@end
