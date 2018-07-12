//
//  CommentViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse.h"

@protocol CommentViewControllerDelegate

- (void)didComment;
@end

@interface CommentViewController : UIViewController
@property (weak, nonatomic) Post *post;
@property (nonatomic, weak) id<CommentViewControllerDelegate> delegate;



@end
