//
//  PostCollectionCell.h
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"
#import "Post.h"

@interface PostCollectionCell : UICollectionViewCell
@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;


@end
