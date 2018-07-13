//
//  Comment.m
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "Comment.h"
#import "Post.h"

@implementation Comment

@dynamic author;
@dynamic text;
@dynamic postID;


+ (void) postComment:( NSString * _Nonnull )text ToPost: (Post * _Nonnull)post withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Comment *newComment = [Comment new];
    newComment.text = text;
    newComment.author = [PFUser currentUser];
    newComment.postID = post.objectId;
    NSMutableArray *tempComments = [NSMutableArray arrayWithArray:post.comments];
    [tempComments addObject:newComment];
    post.comments = [NSArray arrayWithArray:tempComments];
    post.commentCount = [NSNumber numberWithInteger:post.comments.count];
    
    [post saveInBackgroundWithBlock: completion];
}

+ (nonnull NSString *) parseClassName {
    return @"Comment";
}

@end
