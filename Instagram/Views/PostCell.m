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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post{
    _post = post;

    NSURL *imageURL = [NSURL URLWithString:post.image.url];
    self.postImage.image = nil;

    
    [self.postImage setImageWithURL:imageURL];
    self.postCaption.text = post.caption;
}

@end
