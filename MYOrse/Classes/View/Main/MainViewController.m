//
//  MainViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 22/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MainViewController.h"
#import "GTalkConnection.h"
#import "MYOrseListener.h"
#import <MyoKit/MyoKit.h>

@interface MainViewController (){
    BOOL _started;
    NSString* _pickedFriend;
    MYOrseListener* _myorseListener;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnPick;
@property (weak, nonatomic) IBOutlet UIButton *btnMYO;

@end

@implementation MainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    GTalkConnection* gtalk = [GTalkConnection sharedInstance];
    _lblUser.text = gtalk.username;
    _btnStart.enabled = NO;
    _myorseListener = [MYOrseListener new];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - UI events

- (IBAction)switchedWidocznosc:(UISwitch *)sender {
    [[GTalkConnection sharedInstance] setVisible:[sender isOn]];
}
- (IBAction)startStopReceiver:(UIBarButtonItem *)sender {
    _started = !_started;
    
    sender.title = NSLocalizedString( _started ? @"STOP_MYORSE_SERVICE" : @"START_MYORSE_SERVICE", nil);
    NSString* siemaMsg = NSLocalizedString( !_started ? @"STOP_MYORSE_MESSAGE" : @"START_MYORSE_MESSAGE", nil);
    _btnPick.enabled = !_started;
    _btnMYO.enabled = !_started;
    
    if(_started){
        [_myorseListener start];
    } else {
        [_myorseListener stop];
    }
    
    [[GTalkConnection sharedInstance] sendMessageTo:_pickedFriend withBody:siemaMsg];
    
}

-(IBAction)logout:(id)sender{
    [[GTalkConnection sharedInstance] logout];
    
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:next animated:YES completion:nil];
}

- (IBAction)MYOsettings:(id)sender {
    TLMSettingsViewController *settings = [[TLMSettingsViewController alloc] init];
    
    [self.navigationController pushViewController:settings animated:YES];
}

-(void)buddyPickedWithEmail:(NSString *)email{
    _lblOtherUser.text = email ? : @"";
    _pickedFriend = email ? : @"";
    _myorseListener.username = email;
    _btnStart.enabled = email != nil;
    
    [self.navigationController setToolbarHidden:email == nil animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BuddiesTableViewController class]]){
        ((BuddiesTableViewController*)segue.destinationViewController).delegate = self;
    }
}

@end
