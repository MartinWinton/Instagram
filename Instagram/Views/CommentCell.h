//
//  CommentCell.h
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commentPictureLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;
@property (weak, nonatomic) Comment *comment;


@end
