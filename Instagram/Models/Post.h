//
//  Post.h
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString * _Nonnull postID;
@property (nonatomic, strong) NSString * _Nonnull userID;
@property (nonatomic, strong) PFUser * _Nonnull author;
@property (nonatomic, strong) NSString * _Nonnull authorUsername;


@property (nonatomic, strong) NSString * _Nullable caption;
@property (nonatomic, strong) NSString * _Nullable location;

@property (nonatomic, strong) PFFile * _Nonnull image;
@property (nonatomic, strong) NSNumber * _Nonnull likeCount;
@property (nonatomic, strong) NSArray * _Nonnull likeUsernames;
@property (nonatomic, strong) NSArray * _Nonnull comments;


@property (nonatomic, strong) NSNumber * _Nonnull commentCount;


+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption WithLocation:(NSString * _Nullable)location withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (UIImage *_Nonnull)resizeImage:(UIImage *_Nonnull)image withSize:(CGSize)size;
+ (PFFile *_Nonnull)getPFFileFromImage: (UIImage * _Nullable)image;

+ (void) addPost;


@end
