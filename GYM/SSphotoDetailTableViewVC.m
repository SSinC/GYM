//
//  SSphotoDetailTableViewVC.m
//  GYM
//
//  Created by Sara on 15/5/29.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSphotoDetailTableViewVC.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation SSCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    [NSException raise:NSStringFromClass([self class]) format:@"init(coder:) has not been implemented."];
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    UIImageView* imageView = self.imageView;
    //    imageView.frame = CGRectZero;
    //    if (imageView.image != nil) {
    //        CGFloat imageHeight = imageView.image.size.height * screenWidth/imageView.image.size.width;
    //        imageView.frame = CGRectMake(0, 0, screenWidth, imageHeight);
    //    }
    //    
}

@end
@interface SSphotoDetailTableViewVC ()
{
    NSIndexPath *_currentIndexpah;

}
@property(nonatomic)    CGPoint pullOffset;

@end

NSString* commentcellIdentify = @"commentcellIdentify";

@implementation SSphotoDetailTableViewVC

- (instancetype)initWithStyle:(UITableViewStyle)style currentIndexPath:(NSIndexPath*)indexpath
{
    if (self = [super initWithStyle:style]) {
        
        _currentIndexpah = indexpath;
        _pullOffset = CGPointZero;
        _tappedAction = ^{};
        __weak __typeof(self) weakSelf = self;
        _pullAction = ^(CGPoint offset){
            _pullOffset = offset;
            [self.navigationController popViewControllerAnimated:YES];
        };

        
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//wk
//    UIImage *image = [UIImage imageNamed:self.imageName];
    UIImage *image = [[SDWebImageManager sharedManager] cachedImageForURLString:self.imageName];
    CGFloat height = 0.0;
    height = floorf(self.tableView.width * image.size.height / image.size.width );
    CGFloat yoffset = self.navigationController.myNavigationbar.hidden ? 0.0 : navigationHeight;
    
    UIView*headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  self.tableView.width, height + yoffset)];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, yoffset, self.tableView.width, height)];
    imageview.image = image;
    
    [headerView addSubview:imageview];
    [self.tableView setTableHeaderView:headerView];
    
    [self.tableView registerClass:[SSCommentTableViewCell class] forCellReuseIdentifier:commentcellIdentify];
   
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentcellIdentify forIndexPath:indexPath];
    cell.textLabel.text = @"try pull to pop view controller 😃";
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight  = navigationHeight;
    return cellHeight;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 65 ){
          _pullAction(scrollView.contentOffset);
    }
}

- (NSIndexPath*)currentIndexpath
{
    return _currentIndexpah;
    
}

- (CGPoint)pageViewCellScrollViewContentOffset
{
    return self.pullOffset;
}

- (UITableView*)transitionTableView
{
    return self.tableView;
}

@end
