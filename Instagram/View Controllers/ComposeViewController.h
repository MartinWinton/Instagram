//
//  ComposeViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse.h"

@protocol ComposeViewControllerDelegate

- (void)didShare;
@end


@interface ComposeViewController : UIViewController



@property (nonatomic, strong) UIImage *  postedImage;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;






@end
