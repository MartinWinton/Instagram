//
//  CommentCell.m
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+AFNetworking.h"


@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setComment:(Comment *)comment{
    
    _comment = comment;
    
    self.commentUsernameLabel.text = self.comment.author.username;
    self.commentTextLabel.text = self.comment.text;
    
    self.commentPictureLabel.layer.cornerRadius = self.commentPictureLabel.frame.size.width / 2;
    self.commentPictureLabel.clipsToBounds = YES;
    
    PFFile *image = self.comment.author[@"profileImage"];

    
    
    NSURL *imageURL = [NSURL URLWithString:image.url];
    
    [self.commentPictureLabel setImageWithURL:imageURL];
    
    
    
    
    
    
}


@end
