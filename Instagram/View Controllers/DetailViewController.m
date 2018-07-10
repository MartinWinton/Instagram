//
//  DetailViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "DetailViewController.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailCaption;
@property (weak, nonatomic) IBOutlet UILabel *detailLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailTime;

@end

@implementation DetailViewController
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *imageURL = [NSURL URLWithString:self.post.image.url];
    self.detailImage.image = nil;
    
    
    
    [self.detailImage setImageWithURL:imageURL];
    self.detailCaption.text = self.post.caption;
    
    self.detailLocation.text = self.post.location;
    self.detailTime.text = self.post.createdAt.timeAgoSinceNow;
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
