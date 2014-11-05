//
//  ViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 26/10/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "StartViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray* permissions =  @[@"public_profile", @"user_friends", @"email"];
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:permissions];
    loginView.center = self.view.center;
    loginView.delegate = self;
    [self.view addSubview:loginView];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    NSLog(@"Zalogowano");
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    [self presentViewController:next animated:YES completion:nil];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
