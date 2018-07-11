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

@interface CommentViewController : UIViewController
@property (weak, nonatomic) Post *post;


@end
