//
//  BuddiesTableViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 25/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "BuddiesTableViewController.h"
#import "GTalkConnection.h"

@interface BuddiesTableViewController (){
    NSArray* _buddies;
}

@end

@implementation BuddiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buddies = [[GTalkConnection sharedInstance] buddyList];
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_buddies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuddyCell" forIndexPath:indexPath];
    cell.textLabel.text = ((NSString*)_buddies[[indexPath row]]);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate buddyPickedWithEmail:_buddies[[indexPath row]]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
