//
//  PostCollectionCell.m
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "PostCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCollectionCell

- (void)setPost:(Post *)post{
    
    _post = post;
    
    NSURL *imageURL = [NSURL URLWithString:self.post.image.url];
    [self.postImageView setImageWithURL:imageURL];
    
    
    
}

@end
