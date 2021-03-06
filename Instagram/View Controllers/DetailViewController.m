//
//  DetailViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "DetailViewController.h"
#import "Post.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "PostCell.h"
#import "HeaderCell.h"
#import "CommentViewController.h"
#import "GridViewController.h"

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,PostCellCommentDelegate,PostCellLikeDelegate,CommentViewControllerDelegate,GridViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (assign, nonatomic) Post *commentedPost;




@end

@implementation DetailViewController

- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)viewDidLoad {
    
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    // one for header and one for post
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headercell"];

        
        cell.user = self.post.author;
        Post *post  = self.post;
        cell.locationLabel.text = post.location;
        return cell;
    }
    
    else{
        
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postcell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        cell.helper = [[LikeCommentHelper alloc] initWithPost:self.post];
        cell.post = self.post;
        cell.commentdelegate = self;
        cell.likeDelegate = self;
        
        return cell;
        
    }
    
    
    
}

- (void)didClickCommentOfPost:(Post *)post{
    
    self.commentedPost = post;
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    
    if([ navigationController.topViewController isKindOfClass:[CommentViewController class]]){
        
        CommentViewController *commentController = (CommentViewController*)navigationController.topViewController;
        commentController.post = self.commentedPost;
        commentController.delegate = self;
        // becase we are composing from timeline we are not replying to a tweet
        NSLog(@"Comment Picture Segue");
    }
    
    else if([ navigationController.topViewController isKindOfClass:[GridViewController class]]){
        
        GridViewController *gridController = (GridViewController*)navigationController.topViewController;
        gridController.user = self.post.author;
        gridController.didTap = true;
        gridController.delegate = self;
        
        NSLog(@"Profile View Segue");
    }
    
    
}

- (void)didLike{
    
    [self.delegate didLike];
}
- (void)didComment{
    
    [self.post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        // get new post and update accordingly
        [self.detailTableView reloadData];
    }];
}


- (void)didChangeProfile{
    
    [self.post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        // get new post and update accordingly
        [self.detailTableView reloadData];
        [self.delegate didLike];
    }];
    
    
}
@end
