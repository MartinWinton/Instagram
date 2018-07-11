//
//  FeedViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileUpdateDelegate

- (void)didChangeProfile;

@end

@interface FeedViewController : UIViewController
@property (nonatomic, weak) id<ProfileUpdateDelegate> delegate;




@end
