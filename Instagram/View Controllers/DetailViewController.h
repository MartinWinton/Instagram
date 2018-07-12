//
//  DetailViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse.h"
#import "LikeCommentHelper.h"
#import "FeedViewController.h"

@protocol DetailViewControllerDelegate

- (void)didLike;
@end


@interface DetailViewController : UIViewController


@property (weak, nonatomic) Post *post;
@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;



@end
