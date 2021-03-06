//
//  GridViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/10/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "GridViewController.h"
#import "PostCollectionCell.h"
#import "Parse.h"
#import "Post.h"
#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "FeedViewController.h"
#import "ProfileEditViewController.h"


@interface GridViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ProfileUpdateDelegate,ProfileEditViewControllerDelegate,FeedUpdateDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *profileGridView;
@property (nonatomic,strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UILabel *numPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numFollowingLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;


@end

@implementation GridViewController
- (IBAction)didTapProfile:(id)sender {
    
    if([self.user.objectId isEqualToString:[PFUser currentUser].objectId]){
        // only want to be able to change profile if changing profile of own account
        
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerVC animated:YES completion:nil];
        
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.user[@"profileImage"] = [Post getPFFileFromImage:editedImage];
    // save selected image to profile
    [SVProgressHUD showWithStatus:@"Updating Profile "];
    
    [SVProgressHUD show];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            
            self.profileImageView.image = editedImage;
            [self.delegate didChangeProfile];
            // if success, change profile locally and tell feed view to update all posts with profile
            
            [SVProgressHUD dismiss];
            [[PFUser currentUser] fetchInBackground];
            // get updated user so that local user matches database user
            
            
        }
    }];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)didClickBack:(id)sender {
    
    if(self.didTap){
        
        [self dismissViewControllerAnimated:true completion:nil];
        
    }
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.editProfileButton.layer.cornerRadius = 13;
    self.editProfileButton.clipsToBounds = true;
    [self.editProfileButton.layer setBorderWidth:1];
    [self.editProfileButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    self.profileGridView.dataSource = self;
    self.profileGridView.delegate = self;
    
    UICollectionViewFlowLayout *layout =  (UICollectionViewFlowLayout*) self.profileGridView.collectionViewLayout;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.profileGridView.frame.size.width/postersPerLine-3);
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    // grid layout settings
    
    
    UINavigationController *navfeed = self.tabBarController.viewControllers[0];
    FeedViewController *feed = (FeedViewController*)navfeed.topViewController;
    feed.delegate = self;
    feed.feedDelegate = self;
    // set up feed delegate  to make sure posts are updated when updating profile
    
    [SVProgressHUD showWithStatus:@"Loading Profile"];
    
    if(self.didTap){
        self.backButton.tintColor = [UIColor blueColor];
        self.backButton.enabled = YES;
        [self refreshData];
        
        
    }
    
    else{
        
        self.backButton.tintColor = [UIColor clearColor];
        self.backButton.enabled = NO;
        // don't want to show back button when coming from tab view
        
        
        
        [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.user = [PFUser currentUser];
            [self refreshData];
            
        }];
        
        
    }
    
    
    
    
    
}


-(void)refreshData{
    if(self.user[@"numPosts"] == nil){
        
        self.user[@"numPosts"] = @"0";
        
        self.numPostsLabel.text = @"0";
        
        // initialize users with 0 posts
        
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error == nil){
                
                NSLog(@"success!");
            }
        }];
        
    }
    
    else{
        
        self.numPostsLabel.text = self.user[@"numPosts"];
        
    }

    self.usernameLabel.text = self.user[@"Name"];
    self.descriptionLabel.text = self.user[@"Biography"];
    
    self.numFollowersLabel.text =  [NSString stringWithFormat:@"%d",arc4random_uniform(500)];
    self.numFollowingLabel.text =  [NSString stringWithFormat:@"%d",arc4random_uniform(500)];
    // give random number of followers
    
    if(self.user[@"profileImage"] != nil){
        
        PFFile *image = self.user[@"profileImage"];
        NSURL *imageURL = [NSURL URLWithString:image.url];
        [self.profileImageView setImageWithURL:imageURL];
        
        
        
    }
    
    if([self.user.objectId isEqualToString:[PFUser currentUser].objectId]){
        
        self.editProfileButton.hidden = NO;
    }
    else{
        self.editProfileButton.hidden = YES;
        
    }
    
    self.navigationItem.title = self.user.username;
    
    [self getFeed];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *post  = self.posts[indexPath.row];
    
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridcell" forIndexPath:indexPath];
    cell.post = post;
    return cell;
    
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.posts.count;
    
}

-(void) getFeed{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query whereKey:@"authorUsername" equalTo:self.user.username];
    
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            self.posts = posts;
            [self.profileGridView reloadData];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@" Error man%@", error.localizedDescription);
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    
    if([ navigationController.topViewController isKindOfClass:[DetailViewController class]]){
        
        PostCollectionCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.profileGridView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        
        DetailViewController *detailController = (DetailViewController*)navigationController.topViewController;
        detailController.post = post;
        NSLog(@"Detail Picture Segue");
    }
    
    if([ navigationController.topViewController isKindOfClass:[ProfileEditViewController class]]){
        
        ProfileEditViewController *profileController = (ProfileEditViewController*)navigationController.topViewController;
        profileController.user = self.user;
        profileController.delegate = self;
        NSLog(@"Profile Edit Segue");
    }
    
    
}

- (void)didChangeProfile{
    
    // this method will be run when you update your profile through one of your posts. The order of execution is profile update -> feed view runs delegation method -> delegation method runs this method
    
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error == nil){
            
            PFFile *image = self.user[@"profileImage"];
            
            NSURL *imageURL = [NSURL URLWithString:image.url];
            
            [self.profileImageView setImageWithURL:imageURL];
            
        }
    }];
}
- (void)didChangeProfileText{
    
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error == nil){
            
            self.usernameLabel.text = self.user[@"Name"];;
            self.descriptionLabel.text = self.user[@"Biography"];
            
            [self.delegate didChangeProfile];
            
        }
    }];
    
    
}

- (void)didUpdateFeed{
    [self getFeed];
    [self refreshData];
}


@end
