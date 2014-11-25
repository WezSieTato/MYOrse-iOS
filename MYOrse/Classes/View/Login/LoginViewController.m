//
//  LoginViewController.m
//  MYOrse
//
//  Created by Marcin Stepnowski on 19/11/14.
//  Copyright (c) 2014 siema. All rights reserved.
//

#import "LoginViewController.h"
#import "GTalkConnection.h"
#import "Constants.h"

@interface LoginViewController () < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UISwitch *swtRemember;

@property (readonly) GTalkConnectionLoginHandler loginHandler;

@end

@implementation LoginViewController

- (BOOL)isValidInputs
{
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![username length]) {
        return  NO;
    }
    if (![password length]) {
        return NO;
    }
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", REGEX_EMAIL_VERIFICATION] evaluateWithObject:username]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Login

-(void)gtalkWillLogin{
    [self.view endEditing:true];
    [_loginButton setHidden:YES];
    [_loadingIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
}

-(void)loginWithUsername:(NSString*)login andPassword:(NSString *)password remember:(BOOL)remember{
    [self gtalkWillLogin];
    [[GTalkConnection sharedInstance] loginWithUsername:login
                                            andPassword:password
                                               remember:remember
                                             andHandler:self.loginHandler];
}

-(void)loginFailed{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"POPUP_ERROR_TITLE", nil)
                                message:NSLocalizedString(@"ERROR_CONNECTION_AUTH", nil)
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"POPUP_CONFIRM_BUTTON_TITLE", nil)
                      otherButtonTitles:nil] show];
    [self.view setUserInteractionEnabled:YES];
}

-(void)loginSucces{
    UIViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Navigation"];
    [self presentViewController:next animated:YES completion:nil];
}

-(GTalkConnectionLoginHandler)loginHandler{
    return ^(BOOL succes) {
        [_loginButton setHidden:NO];
        [_loadingIndicator stopAnimating];
        
        if(succes){
            [self loginSucces];
        } else {
            [self loginFailed];
        }
    };
}

#pragma mark - View States

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[GTalkConnection sharedInstance] isRemember]) {
        [self gtalkWillLogin];
        [[GTalkConnection sharedInstance] loginWithLastLoginHandler:self.loginHandler];
    }
        
}

#pragma mark - Event Handlers

- (IBAction)loginButtonTapped:(UIButton *)sender
{
    [self loginWithUsername:_usernameTextField.text
                andPassword:_passwordTextField.text
                   remember:_swtRemember.isOn];
    
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:true];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField && [self isValidInputs]) {
        [self loginButtonTapped:self.loginButton];
    }
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _loginButton.enabled = [self isValidInputs];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
