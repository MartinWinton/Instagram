//
//  ComposeViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "Parse.h"
#import "SVProgressHUD.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (weak, nonatomic) IBOutlet UIImageView *composeImage;
@property (weak, nonatomic) IBOutlet UITextField *composeLocation;

@end

@implementation ComposeViewController
- (IBAction)didClickCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)didClickShare:(id)sender {
    
    [SVProgressHUD show];
    [SVProgressHUD setBorderColor: [UIColor blueColor]];
    [SVProgressHUD showWithStatus:@"Posting to the gram.."];
    [Post postUserImage:self.postedImage withCaption:self.captionField.text WithLocation:self.composeLocation.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            NSLog(@"Successfully posted picture with the follwoing caption: %@", self.captionField.text);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate didShare];
            [SVProgressHUD dismiss];
            
        }
        
        else{
            NSLog(@"Error posting post: %@", error.localizedDescription);
        }
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeImage.image = self.postedImage;
    
    // Do any additional setup after loading the view.
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
