//
//  HeaderCell.h
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end
