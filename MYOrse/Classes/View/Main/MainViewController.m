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
    short _syncedMyos;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnPick;
@property (weak, nonatomic) IBOutlet UIButton *btnMYO;
@property (weak, nonatomic) IBOutlet UILabel *lblSynchronizedNumber;

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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
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
    
    [self.navigationController showViewController:settings sender:sender];
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
    BOOL can = _pickedFriend && _syncedMyos > 0;
    _btnStart.enabled = can;
    [self.navigationController setToolbarHidden:!can animated:YES];
    if(!can && [_myorseListener isTransmitting]){
        [_myorseListener stop];
    }
}

@end
