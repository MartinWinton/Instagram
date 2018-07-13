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

@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource,PostCellCommentDelegate,PostCellLikeDelegate,CommentViewControllerDelegate>
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

 
  
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
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
    
}

- (void)didLike{
    
    [self.delegate didLike];
}
- (void)didComment{
    
    [self.post fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        [self.detailTableView reloadData];
    }];
}

@end
