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
    
    
    if([self.post.likeUsernames containsObject: self.post.author.username]){
        
        
        [self unfavorite:self.post.author.username];
        
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
        
        [self favorite:self.post.author.username];
        
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

-(void) unfavorite:(NSString *)username{
    
    [self.post.likeUsernames removeObject:username];
    self.post.likeCount = [NSNumber numberWithFloat:([self.post.likeCount floatValue] - 1)];

}

-(void) favorite:(NSString *)username{
    
    [self.post.likeUsernames addObject:username];
    self.post.likeCount = [NSNumber numberWithFloat:([self.post.likeCount floatValue]  + 1)];
    


    
}



@end
