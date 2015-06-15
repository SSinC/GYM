//
//  SSHorizontalPageViewCell.m
//  GYM
//
//  Created by Sara on 15/5/12.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "SSHorizontalPageViewCell.h"

NSString* cellIdentify = @"cellIdentify";

@implementation SSTableViewCell

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
    UIImageView* imageView = self.imageView;
    imageView.frame = CGRectZero;
    if (imageView.image != nil) {
        CGFloat imageHeight = imageView.image.size.height * screenWidth/imageView.image.size.width;
        imageView.frame = CGRectMake(0, 0, screenWidth, imageHeight);
    }
    
}

@end


@interface SSHorizontalPageViewCell()
{
  
    UITableView *_tableview;
}

@end
@implementation SSHorizontalPageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _tableview = [[UITableView alloc] initWithFrame:screenBounds style:UITableViewStylePlain];
        [self.contentView addSubview:_tableview];
        [_tableview registerClass:[SSTableViewCell class] forCellReuseIdentifier:cellIdentify];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        
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
    [_tableview reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.imageView.image = nil;
    cell.textLabel.text = nil;
    if (indexPath.row == 0){
        UIImage* image = [UIImage imageNamed:_imageName];
        cell.imageView.image = image;
   
    }else{
        cell.textLabel.text = @"try pull to pop view controller 😃";
    }
    [cell setNeedsLayout];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight  = navigationHeight;
    if (indexPath.row == 0){

        UIImage* image = [UIImage imageNamed: _imageName];
        CGFloat imageHeight = image.size.height*screenWidth/image.size.width;
        cellHeight = imageHeight;
    }
    return cellHeight;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tappedAction();
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 65 ){
        _pullAction(scrollView.contentOffset);
    }
}


@end
