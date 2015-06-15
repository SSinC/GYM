//
//  FrontScrollView.m
//  GYM
//
//  Created by Sara on 15/5/22.
//  Copyright (c) 2015年 Sara. All rights reserved.
//

#import "FrontScrollView.h"

#define ITEM_SIZE 200.0

@interface SSTagLayout()

@property (nonatomic, weak) id <SSTagLayoutDelegate> delegate;
@property (nonatomic)NSMutableArray *allItemAttributes;
@property (nonatomic)NSMutableArray *rowWidths;
@end
@implementation SSTagLayout

- (NSMutableArray *)allItemAttributes {
    if (!_allItemAttributes) {
    _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (instancetype)init
{
    if (self = [super init]) {
        _sections = 1;
        _columSpacing = 10.;
        _rowSpacing = 10.;
        _rowCount = 2;
        _sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
    }
    return self;
}

- (NSMutableArray *)rowWidths {
    if (!_rowWidths) {
        _rowWidths = [NSMutableArray array];
    }
    return _rowWidths;
}

- (id <SSTagLayoutDelegate> )delegate {
    return (id <SSTagLayoutDelegate> )self.collectionView.delegate;
}

- (void)prepareLayout
{
    [self.allItemAttributes removeAllObjects];
    [self.rowWidths removeAllObjects];
    
    for (NSInteger i = 0; i < self.sections; i++) {
        NSMutableArray *sectionRowWidths = [NSMutableArray arrayWithCapacity:self.rowCount];
      
        for (NSInteger j = 0; j < self.rowCount; j++) {
             [sectionRowWidths addObject:@(0)];
        }
        
        [self.rowWidths addObject:sectionRowWidths];
    }
    
    CGFloat sectionContentHeight = self.collectionView.bounds.size.height - self.sections * (self.sectionInset.top + self.sectionInset.bottom);
    
    CGFloat itemHeight = (sectionContentHeight - self.sections * (_rowSpacing * (_rowCount - 1)))/ _rowCount;
    
    
    for (NSInteger section = 0;section < self.sections;section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        UICollectionViewLayoutAttributes *attributes;
        
        for (NSInteger idx = 0; idx < itemCount; idx++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            NSInteger rowForAdd = [self nextRowForsection:section];
            CGFloat xOffset = [self.rowWidths[section][rowForAdd] floatValue];
            CGFloat yOffset = _sectionInset.top + rowForAdd * (itemHeight + _rowSpacing) ;

            CGFloat itemWidth = 0;
            CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
            if (itemSize.width > 0 && itemSize.height > 0)
            {
                itemWidth = floor(itemSize.width * itemHeight / itemSize.height  );

            }
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];

            [self.allItemAttributes addObject:attributes];
            self.rowWidths[section][rowForAdd] = @(CGRectGetMaxX(attributes.frame) + _columSpacing);
            
        }

    }
    

}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSInteger i;
    NSInteger begin = 0, end = self.allItemAttributes.count;//self.unionRects.count;
    NSMutableArray *attrs = [NSMutableArray array];
    
      for (i = begin; i < end; i++) {
        UICollectionViewLayoutAttributes *attr = self.allItemAttributes[i];
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
    }
    
    return [NSArray arrayWithArray:attrs];

}

- (CGSize)collectionViewContentSize 
{
     CGSize contentSize = self.collectionView.bounds.size;
    
    return contentSize;
}


- (NSInteger)nextRowForsection:(NSInteger)section
{
    __block NSInteger index = 0;
    __block CGFloat shortestWidth = MAXFLOAT;
    [self.rowWidths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat width = [obj floatValue];
        if (width < shortestWidth) {
            shortestWidth = width;
            index = idx;
        }
    }];
    
    return index;
}

@end



@interface SSTagCollectionview()
{
    UIFont *_cellFont;
}
@end
NSString *const tagCollectionCell = @"tagCollectionCell";


@implementation SSTagCollectionview
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        [self initSelf];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initSelf];
}

- (void)initSelf
{
    self.dataSource = self;
    self.delegate = self;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:tagCollectionCell];
    self.collectionViewLayout = [[SSTagLayout alloc] init];
    _cellFont = [UIFont systemFontOfSize:15.0];
}

#pragma mark -- collection datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagCollectionCell forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.frame];
    label.font = _cellFont;
    label.text = _dataList[indexPath.row];
    label.textColor = [UIColor whiteColor];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat r = (CGFloat) (arc4random() % 256 / 256.0);
    CGFloat g = (CGFloat) (arc4random() % 256 / 256.0);
    CGFloat b = (CGFloat) (arc4random() % 256 / 256.0);
    
    label.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * text = _dataList[indexPath.row];
    return [text sizeWithAttributes:@{NSFontAttributeName:_cellFont}];
}

@end

@interface FrontMainView()

@end

@implementation FrontMainView

- (void)awakeFromNib
{
    _tagCollectionView.dataList = [[NSMutableArray alloc] initWithObjects:@"看",@"美丽可爱",@"哈哈",@"测试测试测试测试测试",@"健忘的人",@"hi", nil];

}


@end


@implementation FrontScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"FrontViewS" owner:nil options:nil] ;
        UIView*view = views[0];
        view.frame = self.bounds;
        [self addSubview:view];
        
        self.contentSize = CGSizeMake(375, 1500);
    }
    
    return self;
}



@end
