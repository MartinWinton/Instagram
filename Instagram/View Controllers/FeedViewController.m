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
@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ComposeViewControllerDelegate,PostCellDelegate>
@property (nonatomic, strong) UIImage *selectedComposeImage;
@property (weak, nonatomic) IBOutlet UITableView *feedView;
@property (nonatomic,strong) NSMutableArray *posts;



@end

@implementation FeedViewController

NSString *CellIdentifier = @"TableViewCell";
NSString *HeaderViewIdentifier = @"TableViewHeaderView";
- (IBAction)didClickCompose:(id)sender {
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take Photo!"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
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
                                                          UIImagePickerController *imagePickerVC = [UIImagePickerController new];
                                                          imagePickerVC.delegate = self;
                                                          imagePickerVC.allowsEditing = YES;
                                                          imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                          
                                                          [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                          
                                             
                                                          
                                                      }];
    [alert addAction:takePhoto];
    [alert addAction:chooseFromLibrary];
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];

    
 
    
    
}
- (IBAction)didLogout:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

        // PFUser.current() will now be nil
    }];
    
    
}

- (void)viewDidLoad {
    self.feedView.delegate = self;
    self.feedView.dataSource = self;
    self.feedView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedView insertSubview:refreshControl atIndex:0];
    // create refresh control and insert at top of tableview
    [super viewDidLoad];
    
    [self getFeed];
    
   // [self.feedView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    //[self.feedView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:HeaderViewIdentifier];
}

    
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    
    self.selectedComposeImage = editedImage;
    
    // Do something with the images (based on your use case)
    
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
        
        cell.helper = [[LikeCommentHelper alloc] initWithPost:post];
        
        cell.post = post;
        return cell;
    }
    
    else {
        
        PFUser *user  = self.posts[indexPath.row];
        
        
        
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headercell"];
        
        cell.user = user;
        return cell;
    }
    
    
        
        

    
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 600;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 600;
}


*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    
    if([ navigationController.topViewController isKindOfClass:[ComposeViewController class]]){
        
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.postedImage = self.selectedComposeImage;
        composeController.delegate = self;
        // becase we are composing from timeline we are not replying to a tweet
        NSLog(@"Compose Picture Segue");
    }
    
    
    
    else if([ navigationController.topViewController isKindOfClass:[DetailViewController class]]){
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.feedView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        DetailViewController *composeController = (DetailViewController*)navigationController.topViewController;
        composeController.post = post;
        // becase we are composing from timeline we are not replying to a tweet
        NSLog(@"Detail Picture Segue");
    }
    
    
}

-(void) getFeed{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];

    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSMutableArray *postsAndNames = [NSMutableArray array];
            for(int i = 0; i < posts.count; i++){
                
                Post *post = posts[i];
                [postsAndNames addObject:post.author];

                [postsAndNames addObject:post];
                
                
            }
            self.posts = postsAndNames;
            [self.feedView reloadData];
        } else {
            NSLog(@" Error man%@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self getFeed];
    [refreshControl endRefreshing];

    
    
    
}

-(void)didShare{
    
    
    [self getFeed];
    
    [self.feedView reloadData];

    
    
}
- (void)didLoad{
    
    
    
    [self.feedView reloadData];
}

@end
