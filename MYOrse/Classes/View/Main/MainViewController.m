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
    NSString* _pickedFriend;
    MYOrseListener* _myorseListener;
    short _syncedMyos;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnPick;
@property (weak, nonatomic) IBOutlet UIButton *btnMYO;
@property (weak, nonatomic) IBOutlet UILabel *lblSynchronizedNumber;
@property (strong, nonatomic) UIPopoverController* popover;

@end

@implementation MainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    GTalkConnection* gtalk = [GTalkConnection sharedInstance];
    _lblUser.text = gtalk.username;
    _btnStart.enabled = NO;
    _myorseListener = [MYOrseListener new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSyncArm:)
                                                 name:TLMMyoDidReceiveArmSyncEventNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUnsyncArm:)
                                                 name:TLMMyoDidReceiveArmUnsyncEventNotification
                                               object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - MYO events

- (void)didSyncArm:(NSNotification *)notification {
    ++_syncedMyos;
    [self updateSyncedNumberLabel];
}

- (void)didUnsyncArm:(NSNotification *)notification {
    --_syncedMyos;
    [self updateSyncedNumberLabel];
}

-(void)updateSyncedNumberLabel{
    
    _lblSynchronizedNumber.text = [NSString stringWithFormat:@"%i", _syncedMyos];
    [self enableReceiverIfCan];
}

#pragma mark - UI events

- (IBAction)switchedWidocznosc:(UISwitch *)sender {
    [[GTalkConnection sharedInstance] setVisible:[sender isOn]];
}
- (IBAction)startStopReceiver:(UIBarButtonItem *)sender {
    BOOL started = !_myorseListener.isEnabled;
    
    sender.title = NSLocalizedString( started ? @"STOP_MYORSE_SERVICE" : @"START_MYORSE_SERVICE", nil);
    _btnPick.enabled = !started;
    _btnMYO.enabled = !started;
    
    if(started){
        [_myorseListener start];
    } else {
        [_myorseListener stop];
    }
    
    [self enableReceiverIfCan];
    
}

-(IBAction)logout:(id)sender{
    [[GTalkConnection sharedInstance] logout];
    
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)buddyPickedWithEmail:(NSString *)email{
    _lblOtherUser.text = email ? : @"";
    _pickedFriend = email;
    _myorseListener.username = email;
    [self enableReceiverIfCan];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BuddiesTableViewController class]]){
        ((BuddiesTableViewController*)segue.destinationViewController).delegate = self;
    }
}

-(void)enableReceiverIfCan{
    BOOL can = _myorseListener.isEnabled || ( _pickedFriend && _syncedMyos > 0);
    _btnStart.enabled = can;
    [self.navigationController setToolbarHidden:!can animated:YES];
//    if(!can && [_myorseListener isTransmitting]){
//        [_myorseListener stop];
//    }
}

@end
