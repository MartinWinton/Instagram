//
//  LoginViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import "Post.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpButton.layer.cornerRadius = 10;
    self.signUpButton.clipsToBounds = true;
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.clipsToBounds = true;
    // circular buttons
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerUser {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"One or more fields were empty"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    
    UIAlertAction *returnAction = [UIAlertAction actionWithTitle:@"Sorry!"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    [alert addAction:returnAction];
    
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                [self performSegueWithIdentifier:@"signing" sender:nil];
                
                // manually segue to logged in view
            }
        }];
    }
}
- (IBAction)didSignUp:(id)sender {
    
    [self registerUser];
    
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error Logging In"
                                                                           message:@"Change inputs and try again."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle cancel response here. Doing nothing will dismiss the view.
                                                             }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"signing" sender:nil];
            
            
            // display view controller that needs to shown after successful login
        }
    }];
}
- (IBAction)didLogin:(id)sender {
    
    [self loginUser];
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
