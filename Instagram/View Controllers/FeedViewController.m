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

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ComposeViewControllerDelegate>
@property (nonatomic, strong) UIImage *selectedComposeImage;
@property (weak, nonatomic) IBOutlet UITableView *feedView;
@property (nonatomic,strong) NSMutableArray *posts;


@end

@implementation FeedViewController
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
    
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];

        // PFUser.current() will now be nil
    }];
    
    
}

- (void)viewDidLoad {
    self.feedView.delegate = self;
    self.feedView.dataSource = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedView insertSubview:refreshControl atIndex:0];
    // create refresh control and insert at top of tableview
    [super viewDidLoad];
    
    [self getFeed];
    
    
    
    // Do any additional setup after loading the view.
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
    
    
    
        Post *post  = self.posts[indexPath.row];
    
    
        
        PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postcell"];
        
        cell.post = post;
        return cell;
        
        

    
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 400;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 400;


}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    
    if([ navigationController.topViewController isKindOfClass:[ComposeViewController class]]){
        
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.postedImage = self.selectedComposeImage;
        // becase we are composing from timeline we are not replying to a tweet
        NSLog(@"Compose Picture Segue");
    }
    
}

-(void) getFeed{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];

    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.posts = [NSMutableArray arrayWithArray:posts];
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


@end
