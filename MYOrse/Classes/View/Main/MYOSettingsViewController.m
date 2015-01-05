//
//  MYOSettingsViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 05/01/15.
//  Copyright (c) 2015 siema. All rights reserved.
//

#import "MYOSettingsViewController.h"

@implementation MYOSettingsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
