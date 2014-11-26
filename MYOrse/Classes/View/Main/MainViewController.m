//
//  MainViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 22/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "MainViewController.h"
#import "GTalkConnection.h"

@interface MainViewController (){
    BOOL _started;
    NSString* _pickedFriend;
}

@property (weak, nonatomic) IBOutlet UILabel *lblUser;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStart;
@property (weak, nonatomic) IBOutlet UIButton *btnPick;

@end

@implementation MainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    GTalkConnection* gtalk = [GTalkConnection sharedInstance];
    _lblUser.text = gtalk.username;
    _btnStart.enabled = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
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
    
    sender.title = _started ? @"Zatrzymaj odbiornik" : @"Uruchom odbiornik";
    NSString* siemaMsg = _started ? @"Twoj rozmowca korzysta teraz z programu MYOrse, będzie odbieral twoje wiadomości w alfabecie Morse'a, dlatego staraj się pisać krótkie i zwięzłe wiadomości, gdy twój rozmówca odczyta wiadomość dostaniesz wiadomość zwrotną!" : @"Twój rozmówca rozłączył się z MYOrse!";
    _btnPick.enabled = !_started;
    
    [[GTalkConnection sharedInstance] sendMessageTo:_pickedFriend withBody:siemaMsg];

}

-(IBAction)logout:(id)sender{
    [[GTalkConnection sharedInstance] logout];
    
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    [self presentViewController:next animated:YES completion:nil];
}

-(void)buddyPickedWithEmail:(NSString *)email{
    _lblOtherUser.text = email ? : @"";
    _pickedFriend = email ? : @"";
    _btnStart.enabled = email != nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[BuddiesTableViewController class]]){
        ((BuddiesTableViewController*)segue.destinationViewController).delegate = self;
    }
}

@end
