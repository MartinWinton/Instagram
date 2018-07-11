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

@interface DetailViewController : UIViewController

@property (weak, nonatomic) Post *post;
@property (nonatomic,strong)  LikeCommentHelper *helper;


@end
