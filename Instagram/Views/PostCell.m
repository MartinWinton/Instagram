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



@implementation PostCell


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
    
    [self reloadData];
    
 
    
    
    
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
    
    
    
}
    
    

    -(void)reloadData{
        
        if([self.post.likeUsernames containsObject: self.post.author.username]){
            
            [self.likeButton setSelected:YES];
            
        }
        else{
            
            [self.likeButton setSelected:NO];
            
            
        }
        
        
        self.postCaption.text = self.post.caption;
        
        self.postLocation.text = self.post.location;
        
        self.numLikesLabel.text = [self.post.likeCount stringValue];
        
        if([self.post.likeCount isEqualToNumber:[NSNumber numberWithInt:1]]){
            
            self.likesLabel.text = @"Like";
            
        }
        
        else{
            self.likesLabel.text = @"Likes";

            
        }
        
        
    
}


@end
