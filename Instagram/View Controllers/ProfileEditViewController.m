//
//  ProfileEditViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/12/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"


@interface ProfileEditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameBox;

@property (weak, nonatomic) IBOutlet UITextView *bioBox;

@end

@implementation ProfileEditViewController
- (IBAction)didClickCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}
- (IBAction)didClickDone:(id)sender {
    
    self.user[@"Name"] = self.nameBox.text;
        self.user[@"Biography"] = self.bioBox.text;
    
    [SVProgressHUD showWithStatus:@"Updating Profile "];
    
    [SVProgressHUD show];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            // if success, change profile locally and tell feed view to update all posts with profile
            
            [SVProgressHUD dismiss];
            [[PFUser currentUser] fetchInBackground];
            [self.delegate didChangeProfileText];
            [self dismissViewControllerAnimated:true completion:nil];

            // get updated user so that local user matches database user
            
            
        }
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bioBox.text = self.user[@"Biography"];
    self.nameBox.text = self.user[@"Name"];
    PFFile *image = self.user[@"profileImage"];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;

    NSURL *imageURL = [NSURL URLWithString:image.url];
    
    [self.profileImageView setImageWithURL:imageURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
