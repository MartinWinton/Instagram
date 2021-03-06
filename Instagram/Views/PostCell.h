//
//  PostCell.h
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse.h"
#import "LikeCommentHelper.h"


@protocol PostCellDelegate

- (void)didLoad;

@end

@protocol PostCellCommentDelegate

- (void)didClickCommentOfPost:(Post *)post;
@end

@protocol PostCellLikeDelegate

- (void)didLike;
@end

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) Post *post;
@property (nonatomic, weak) id<PostCellDelegate> delegate;
@property (nonatomic, weak) id<PostCellCommentDelegate> commentdelegate;
@property (nonatomic, weak) id<PostCellLikeDelegate> likeDelegate;

@property BOOL needReload;
@property (nonatomic,strong)  LikeCommentHelper *helper;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLikesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *viewCommentsButton;




@end
