//
//  Comment.h
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "PFObject.h"
#import "Parse.h"
#import "Post.h"

@interface Comment : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser * _Nonnull author;
@property (nonatomic, strong) NSString * _Nullable text;
@property (nonatomic, strong) NSString * _Nullable postID;

+ (nonnull NSString *) parseClassName;
+ (void) postComment:( NSString * _Nullable )text ToPost: (Post *)post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end
