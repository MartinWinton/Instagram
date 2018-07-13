//
//  GridViewController.h
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"


@protocol GridViewControllerDelegate

- (void)didChangeProfile;
@end



@interface GridViewController : UIViewController
@property (weak, nonatomic) PFUser *user;
@property BOOL didTap;
@property (nonatomic, weak) id<GridViewControllerDelegate> delegate;




@end
