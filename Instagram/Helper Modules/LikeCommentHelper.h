//
//  LikeCommentHelper.h
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
@interface LikeCommentHelper : NSObject
@property (weak, nonatomic) Post *post;

-(void)toggleFavorite;
- (instancetype)initWithPost:(Post *)post;
+ (BOOL)currentUserHasLikedPost: (Post *)post;
@end
