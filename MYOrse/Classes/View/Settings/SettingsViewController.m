//
//  SettingsViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 04/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "SettingsViewController.h"
#import "StartViewController.h"

@implementation SettingsViewController


-(void)viewDidLoad{
    [super viewDidLoad];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    NSArray *permissions = @[@"public_profile", @"user_friends"];
//    [FBSession openActiveSessionWithReadPermissions:permissions
//                                       allowLoginUI:YES
//                                  completionHandler:
//     ^(FBSession *session,
//       FBSessionState state, NSError *error) {
//         //         [self sessionStateChanged:session state:state error:error];
//         
//     }];
}

- (IBAction)logout:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    [self presentViewController:next animated:YES completion:nil];
}

- (IBAction)pickFriend:(id)sender {
    
    
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      if (error) {
                                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                          [alertView show];
                                      } else if (session.isOpen) {
                                          [self pickFriend:sender];
                                      }
                                  }];
    return;
    }
    
    FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/permissions" parameters:nil HTTPMethod:@"GET"];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        //store result into facebookFriendsArray
        NSArray* facebookFriendsArray = [result objectForKey:@"data"];
        
        FBFriendPickerViewController *friendPickerController;
        friendPickerController = [[FBFriendPickerViewController alloc] init];
        friendPickerController.title = @"Pick Friend";
        friendPickerController.delegate = self;
//        friendPickerController.
        [friendPickerController loadData];
        [self presentViewController:friendPickerController animated:YES completion:nil];
    }];
    

//    [self.navigationController pushViewController:friendPickerController animated:YES];
}

-(void)facebookViewControllerDoneWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)facebookViewControllerCancelWasPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user{
    
    return YES;
}

@end
