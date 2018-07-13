//
//  CommentViewController.m
//  Instagram
//
//  Created by Martin Winton on 7/11/18.
//  Copyright © 2018 Martin Winton. All rights reserved.
//

#import "CommentViewController.h"
#import "Comment.h"
#import "CommentCell.h"
#import "SVProgressHUD.h"

@interface CommentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic,strong) NSArray *comments;


@end

@implementation CommentViewController
- (IBAction)didClickBack:(id)sender {
    
     [self dismissViewControllerAnimated:true completion:nil];
    
}
- (IBAction)didClickPost:(id)sender {
    
    if([self.commentTextField.text length] > 0){
    
    [SVProgressHUD showWithStatus:@"Posting Comment"];
    
    [Comment postComment:self.commentTextField.text ToPost:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Success!");
            [self getFeed];
            self.commentTextField.text = @"";
            [self.delegate didComment];
        }
                  }];
    }
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    [self.commentTextField becomeFirstResponder];
    [SVProgressHUD showWithStatus:@"Loading Comments"];
    [self getFeed];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
    
}

-(void) getFeed{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query orderByAscending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"postID" equalTo:self.post.objectId];
    query.limit = 20;
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (comments != nil) {
            
            self.comments = comments;
            [self.commentTableView reloadData];
            [SVProgressHUD dismiss];
      
            }
        
        else {
            NSLog(@" Error man%@", error.localizedDescription);
        }
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.comments[indexPath.row] isKindOfClass:[Comment class]]){
        
        Comment *comment  = self.comments[indexPath.row];
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
        
        cell.comment = comment;
        return cell;
    }
    else{
        return nil;
    }
    
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
