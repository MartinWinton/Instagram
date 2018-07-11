//
//  HeaderCell.m
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "HeaderCell.h"
#import "UIImageView+AFNetworking.h"


@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.profilePicView.layer.cornerRadius = self.profilePicView.frame.size.width / 2;
    self.profilePicView.clipsToBounds = YES;


    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(PFUser *)user{
    
    _user = user;
    
    self.usernameLabel.text = user.username;
    
    PFFile *image = self.user[@"profileImage"];
    
    
    NSURL *imageURL = [NSURL URLWithString:image.url];
    
    [self.profilePicView setImageWithURL:imageURL];

    
    
    
   
    
    
}

@end
