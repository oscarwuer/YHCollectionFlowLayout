//
//  ViewController.m
//  YHCollectionFlowLayout
//
//  Created by 张长弓 on 2018/1/3.
//  Copyright © 2018年 张长弓. All rights reserved.
//

#import "ViewController.h"
#import "YHCollectionViewCell.h"
#import "YHCollectionFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourcesArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) YHCollectionFlowLayout *layout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    [self configDatasource];
}

#pragma mark Pravite methods

- (void)configDatasource {
    self.dataSourcesArray = [NSMutableArray arrayWithCapacity:10];
    
    for (NSUInteger i = 0; i < 10; i++) {
        [self.dataSourcesArray addObject:@"占位用"];
    }
    
    [self.layout setContentSize:self.dataSourcesArray.count];
    [self.collectionView reloadData];
}

#pragma mark - Delegates

#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个section中得items个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourcesArray.count +1 ;
}

// cell
- (YHCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([YHCollectionViewCell class]);
    YHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.tag = indexPath.row;
    [cell setIndex:(indexPath.row)];
    
    if(indexPath.row == 0){
        cell.imageView.image = nil;
    }else{
        if(indexPath.row == 1){
            [cell revisePositionAtFirstCell];
        }
        cell.titleLabel.text = @"好看的海报";
        cell.descLabel.text = @"爱情 | 亲情";
        cell.bottomLabel.text = @"好看的外表千篇一律";
        cell.imageView.image = [UIImage imageNamed:@"luoli"];
    }
    return cell;
}

// 每个item的frame.size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return CGSizeMake(MIN(screen_height, screen_width), HEADER_HEIGHT);
    }else if(indexPath.row == 1){
        return CGSizeMake(MIN(screen_height, screen_width), CELL_CURRHEIGHT);
    }else{
        return CGSizeMake(MIN(screen_height, screen_width), CELL_HEIGHT);
    }
}

// 点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat offset = ceil(DRAG_INTERVAL * (indexPath.row-1));
    if (ceil(collectionView.contentOffset.y) != offset) {
        // 滑动动最顶部
        self.layout.currentCount = indexPath.row;
        [collectionView setContentOffset:CGPointMake(0, offset) animated:YES];
    } else {
        // 点击事件
        NSLog(@"点击了第N%@个",@(indexPath.row));
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.layout.currentCount = 1;
}

#pragma mark - Init Views

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // layout
        YHCollectionFlowLayout *layout = [[YHCollectionFlowLayout alloc] init];
        self.layout = layout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height) collectionViewLayout:layout];
        NSString *string = NSStringFromClass([YHCollectionViewCell class]);
        [_collectionView registerClass:[YHCollectionViewCell class] forCellWithReuseIdentifier:string];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = UIColorFromRGB(0x161518);
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}


@end
