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
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *numLikes;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end

@implementation DetailViewController
- (IBAction)didTapFavorite:(id)sender {
    
    [self.helper toggleFavorite];
    [self reloadData];
}
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *imageURL = [NSURL URLWithString:self.post.image.url];
    self.detailImage.image = nil;
    
    [self.detailImage setImageWithURL:imageURL];
  
    
    [self reloadData];
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData{
    
    
    
    if([LikeCommentHelper containsUser:self.post]){

        [self.favoriteButton setSelected:YES];
        
    }
    else{
        
        [self.favoriteButton setSelected:NO];
        
        
    }
     
     
    
      self.detailTime.text = self.post.createdAt.timeAgoSinceNow;
    self.detailCaption.text = self.post.caption;
    
    self.detailLocation.text = self.post.location;
    
    self.numLikes.text = [self.post.likeCount stringValue];
    
    if([self.post.likeCount isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        self.likesLabel.text = @"Like";
        
    }
    
    else{
        self.likesLabel.text = @"Likes";
        
        
    }
    
    
    
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
