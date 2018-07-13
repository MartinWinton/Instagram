//
//  FeedViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/9/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "FeedViewController.h"
#import "Parse.h"
#import "ComposeViewController.h"
#import "PostCell.h"
#import "DetailViewController.h"
#import "HeaderCell.h"
#import "InfiniteScrollActivityView.h"
#import "GridViewController.h"
#import "LoginViewController.h"
#import "CommentViewController.h"
#import "SVProgressHUD.h"
@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIScrollViewDelegate, ComposeViewControllerDelegate,PostCellDelegate,GridViewControllerDelegate,PostCellCommentDelegate,DetailViewControllerDelegate,CommentViewControllerDelegate>
@property (nonatomic, strong) UIImage *selectedComposeImage;
@property (weak, nonatomic) IBOutlet UITableView *feedView;
@property (nonatomic,strong) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) Post *commentedPost;







@end

@implementation FeedViewController



InfiniteScrollActivityView* loadingMoreView;

- (IBAction)didClickCompose:(id)sender {
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          // Code to present camera
                                                          UIImagePickerController *imagePickerVC = [UIImagePickerController new];
                                                          imagePickerVC.delegate = self;
                                                          imagePickerVC.allowsEditing = YES;
                                                          imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          
                                                          [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                          
                                                          
                                                          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                          }
                                                          else {
                                                              NSLog(@"Camera 🚫 available so we will use photo library instead");
                                                              imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                          }
                                                      }];
    
    UIAlertAction *chooseFromLibrary = [UIAlertAction actionWithTitle:@"Choose from Library"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // Code to present photo selection ivew
                                                                  
                                                                  UIImagePickerController *imagePickerVC = [UIImagePickerController new];
                                                                  imagePickerVC.delegate = self;
                                                                  imagePickerVC.allowsEditing = YES;
                                                                  imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                  
                                                                  [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                                  
                                                                  
                                                                  
                                                              }];
    [alert addAction:takePhoto];
    [alert addAction:chooseFromLibrary];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (IBAction)didLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
        [self.navigationController.tabBarController performSegueWithIdentifier:@"logout" sender:self];
        
        // PFUser.current() will now be nil
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedView.delegate = self;
    self.feedView.dataSource = self;
    
    self.feedView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // no lines in between table
    
    
    UINavigationController *navfeed = self.tabBarController.viewControllers[1];
    GridViewController *feed = (GridViewController*)navfeed.topViewController;
    feed.delegate = self;
    // This is for the case when user clicks on profile tab instead of clicking on a profile picture
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedView insertSubview:refreshControl atIndex:0];
    // create refresh control and insert at top of tableview
    
    [SVProgressHUD showWithStatus:@"Loading Posts"];
    [self getFeed];
    // sv progress hud will be closed in get feed
    
    
    CGRect frame = CGRectMake(0, self.feedView.contentSize.height, self.feedView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.feedView addSubview:loadingMoreView];
    UIEdgeInsets insets = self.feedView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.feedView.contentInset = insets;
    // Set up Infinite Scroll loading indicator
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Get the image captured by the UIImagePickerController
    
    
    
    self.selectedComposeImage = editedImage;
    // save selected image to give to compose view during prepare for segue
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"compose" sender:nil];
        // move to compose screen
        
        
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.posts[indexPath.row] isKindOfClass:[Post class]]){
        
        Post *post  = self.posts[indexPath.row];
        
        
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postcell"];
        
        cell.delegate = self;
        cell.commentdelegate = self;
        
        cell.helper = [[LikeCommentHelper alloc] initWithPost:post];
        
        cell.post = post;
        return cell;
    }
    
    else {
        
        PFUser *user  = self.posts[indexPath.row];
        
        
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headercell"];
        
        cell.user = user;
        Post *post  = self.posts[indexPath.row+1];
        cell.locationLabel.text = post.location;
        return cell;
    }
    
    
    
    
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue destinationViewController] isKindOfClass:[LoginViewController class]]){
        // login view controller has no navigation controller
        
        NSLog(@"logging out");
        
    }
    
    else{
        
        UINavigationController *navigationController = [segue destinationViewController];
        
        
        if([ navigationController.topViewController isKindOfClass:[ComposeViewController class]]){
            
            ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
            composeController.postedImage = self.selectedComposeImage;
            composeController.delegate = self;
            NSLog(@"Compose Picture Segue");
        }
        
        
        else if([ navigationController.topViewController isKindOfClass:[DetailViewController class]]){
            
            UITableViewCell *tappedCell = sender;
            NSIndexPath *indexPath = [self.feedView indexPathForCell:tappedCell];
            Post *post = self.posts[indexPath.row];
            
            
            DetailViewController *detailController = (DetailViewController*)navigationController.topViewController;
            detailController.post = post;
            detailController.delegate = self;
            
            NSLog(@"Detail Picture Segue");
        }
        
        else if([ navigationController.topViewController isKindOfClass:[CommentViewController class]]){
            
            
            CommentViewController *commentController = (CommentViewController*)navigationController.topViewController;
            commentController.post = self.commentedPost;
            commentController.delegate = self;
            
            NSLog(@"Comment View Segue");
            
            
        }
        
        
        else if([ navigationController.topViewController isKindOfClass:[GridViewController class]]){
            
            UITableViewCell *tappedCell = sender;
            NSIndexPath *indexPath = [self.feedView indexPathForCell:tappedCell];
            PFUser *user = self.posts[indexPath.row];
            
            GridViewController *gridController = (GridViewController*)navigationController.topViewController;
            gridController.user = user;
            gridController.didTap = true;
            gridController.delegate = self;
            
            NSLog(@"Profile View Segue");
        }
        
        
        
    }
}

-(void) getFeed{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"objectId"];
    
    query.limit = 10;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSMutableArray *postsAndNames = [NSMutableArray array];
            for(int i = 0; i < posts.count; i++){
                
                Post *post = posts[i];
                [postsAndNames addObject:post.author];
                // header cell goes before post
                
                [postsAndNames addObject:post];
                
                
            }
            self.posts = postsAndNames;
            [self.feedView reloadData];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@" Error man%@", error.localizedDescription);
        }
    }];
}
- (void)getMoreData {
    
    
    Post *lastPost   = [self.posts objectAtIndex:self.posts.count-1];
    // get most oldest post currently shown
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"createdAt" lessThan:lastPost.createdAt];
    [query includeKey:@"author"];
    
    query.limit = 5;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts) {
            
            self.isMoreDataLoading = NO;
            // to prevent calling function more than once
            NSMutableArray *newPaths = [NSMutableArray array];
            // create array of new index paths to be created
            for(Post *p in posts){
                [self.posts addObject:p.author];
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:self.posts.count-1 inSection:0];
                [newPaths addObject:newPath];
                
                
                [self.posts addObject:p];
                newPath = [NSIndexPath indexPathForRow:self.posts.count-1 inSection:0];
                [newPaths addObject:newPath];
                
                
                
            }
            
            [self.feedView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationNone];
            // add noew posts at bottom of table
            
            [loadingMoreView stopAnimating];
   
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.feedView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.feedView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.feedView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.feedView.contentSize.height, self.feedView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            
            [self getMoreData];
            
        }
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self getFeed];
    [refreshControl endRefreshing];
}

-(void)didShare{
    
    [self getFeed];
    
    [self.feedDelegate didUpdateFeed];
    // tells profile tab to update feed too
    
    
}
- (void)didLoad{
    
    [self.feedView reloadData];
    // when cell gets image, reload the table
}

- (void)didChangeProfile{
    
    [self getFeed];
    // update profile pics o nfeed
    
    [self.delegate didChangeProfile];
    // update profile pic on profile tab if user updated pic by clicking on a post
    
    
}

- (void)didClickCommentOfPost:(Post *)post {
    
    self.commentedPost = post;
    // get post from cell to pass to comment view segue
}

- (void)didLike{
    
    [self getFeed];
    // update feed when user likes on detail view
    
}

- (void)didComment{
    
    [self getFeed];
    
    // updates number of comments on feed
    
}


@end
