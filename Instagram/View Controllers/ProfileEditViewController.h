//
//  ProfileEditViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/12/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"



@protocol ProfileEditViewControllerDelegate

- (void)didChangeProfileText;
@end

@interface ProfileEditViewController : UIViewController

@property (weak, nonatomic) PFUser *user;
@property (nonatomic, weak) id<ProfileEditViewControllerDelegate> delegate;


@end
