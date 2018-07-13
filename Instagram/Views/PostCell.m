//
//  PostCell.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "PostCell.h"
#import "Parse.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"



@implementation PostCell

- (IBAction)didClickComment:(id)sender {
    
    [self.commentdelegate didClickCommentOfPost:self.post];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.needReload = false;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)didClickLike:(id)sender {
    
    [self.helper toggleFavorite];
    [self reloadData];
}

- (void)setPost:(Post *)post{
    _post = post;
    
    NSURL *imageURL = [NSURL URLWithString:post.image.url];
    self.postImage.image = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    
    
    
    [self.postImage setImageWithURLRequest:request placeholderImage:nil
                                   success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                       
                                       // imageResponse will be nil if the image is cached
                                       if (imageResponse) {
                                           
                                           self.postImage.image = image;
                                           if(self.needReload){
                                               [self.delegate didLoad];
                                               self.needReload = false;
                                           }
                                           
                                           
                                       }
                                       else {
                                           
                                           NSLog(@"Image was cached so just update the image");
                                           self.postImage.image = image;
                                           if(self.needReload){
                                               [self.delegate didLoad];
                                               self.needReload = false;
                                           }
                                           
                                           
                                           
                                       }
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                       // do something for the failure condition
                                   }];
    
    
    [self reloadData];
    
}




-(void)reloadData{
    
    if([LikeCommentHelper currentUserHasLikedPost:self.post]){
        
        
        
        [self.likeButton setSelected:YES];
        
    }
    else{
        
        [self.likeButton setSelected:NO];
        
        
    }
    
    self.postTime.text = self.post.createdAt.timeAgoSinceNow;
    
    self.postCaption.text = self.post.caption;
    
    
    self.numLikesLabel.text = [self.post.likeCount stringValue];
    
    if([self.post.likeCount isEqualToNumber:[NSNumber numberWithInt:1]]){
        
        self.likesLabel.text = @"Like";
        
    }
    
    else{
        self.likesLabel.text = @"Likes";
        
        
    }
    
    
    if(self.post.likeUsernames.count >= 2){
        
        self.numLikesLabel.text =  @"";
        self.likesLabel.text =  @"Liked by..";

        
        PFUser *firstUser = self.post.likeUsernames[0];
        PFUser *secondUser = self.post.likeUsernames[1];
        
        
        
        if(self.post.likeUsernames.count == 2){
        
        
        [firstUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            [secondUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                
                self.likesLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"Liked by ", firstUser.username, @" and ", secondUser.username];
            }];
        }];
            
        }
        
        else{
            
            [firstUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                [secondUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    
                    self.likesLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%lu%@", @"Liked by ", firstUser.username, @", ", secondUser.username, @" and ", (unsigned long)self.post.likeUsernames.count-2, @" others"];
                }];
            }];
            
            
        }

 
        
        
        
    }
    
    if(self.post.comments.count > 0){
        
        self.viewCommentsButton.hidden = NO;
        
        if(self.post.comments.count == 1){
            
            [self.viewCommentsButton setTitle:@"View 1 Comment" forState:UIControlStateNormal];
            [self.viewCommentsButton setTitle:@"View 1 Comment" forState:UIControlStateSelected];
            
        }
        
        else{
            [self.viewCommentsButton setTitle:[NSString stringWithFormat:@"%@%@%@",@"View all ", [self.post.commentCount stringValue], @" comments"] forState:UIControlStateNormal];
            [self.viewCommentsButton setTitle:[NSString stringWithFormat:@"%@%@%@",@"View all ", [self.post.commentCount stringValue], @" comments"] forState:UIControlStateSelected];
            
            
            
        }
        
        
        
    }
    
    else{
        
        self.viewCommentsButton.hidden = YES;
        
    }
    
    
    
 
    
    
}


@end
