//
//  LikeCommentHelper.m
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "LikeCommentHelper.h"
#import "Parse.h"

@implementation LikeCommentHelper

- (instancetype)initWithPost:(Post *)post {
    
    self = [super init];
    if (self) {
        
        self.post = post;
        
    }
    
    return self;
}

-(void)toggleFavorite{
    
    
    if([LikeCommentHelper currentUserHasLikedPost:self.post]){
        
        
        [self unfavoritePostWithAsUsername:self.post.authorUsername];
        
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Successfully unfavorited post");

            }
            
            else{
                NSLog(@"Error unfavoriting post: %@", error.localizedDescription);

                
                
            }
        }];
        
      
    }
    
    else{
        
        [self favoritePostWithAsUsername:self.post.authorUsername];
        
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Successfully favorited post");
                
                
            }
            
            else{
                NSLog(@"Error favoriting post: %@", error.localizedDescription);
                
                
                
            }
        }];
        
    }
}

-(void) unfavoritePostWithAsUsername:(NSString *)username{
    
    NSMutableArray *tempNames = [NSMutableArray arrayWithArray:self.post.likeUsernames];
    
    NSMutableArray *discardedItems = [NSMutableArray array];
    
    for (PFUser *user in tempNames) {
        if ([user.objectId isEqualToString:[PFUser currentUser].objectId]){
            [discardedItems addObject:user];
            
        }
    }
    
    [tempNames removeObjectsInArray:discardedItems];
    
    self.post.likeUsernames = tempNames;
    
    
    self.post.likeCount = [NSNumber numberWithFloat:([self.post.likeCount floatValue] - 1)];

}

-(void) favoritePostWithAsUsername:(NSString *)username{
    
    NSMutableArray *tempNames = [NSMutableArray arrayWithArray:self.post.likeUsernames];
    
    [tempNames addObject:[PFUser currentUser]];
    self.post.likeUsernames = tempNames;
    
    
    self.post.likeCount = [NSNumber numberWithFloat:([self.post.likeCount floatValue]  + 1)];
    


}

+ (BOOL)currentUserHasLikedPost: (Post *)post{
    
    for(int i = 0; i < post.likeUsernames.count; i ++){
        
        PFUser *user = post.likeUsernames[i];
        
        PFUser *current = [PFUser currentUser];
        
        if([user.objectId isEqualToString:current.objectId]){
            return YES;
        }
        
    }
    
    return NO;
    
}


@end
