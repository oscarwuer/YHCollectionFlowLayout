//
//  YHCollectionViewCell.h
//  MobileMovieTheater
//
//  Created by 张长弓 on 2017/12/4.
//  Copyright © 2017年 zuoyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "UIView+FrameCategory.h"

#define CELL_HEIGHT (screen_width*0.24) //普通高度
#define CELL_CURRHEIGHT ((screen_width>screen_height?screen_height:screen_width)*1.2) //置顶高度
#define TITLE_HEIGHT 24
#define IMAGEVIEW_ORIGIN_Y 0
#define IMAGEVIEW_MOVE_DISTANCE 215

#define DRAG_INTERVAL CELL_CURRHEIGHT
#define HEADER_HEIGHT 0
#define RECT_RANGE 1000.0f

@interface YHCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *bottomLabel;

-(void)revisePositionAtFirstCell;
-(void)setIndex:(NSUInteger)index;

@end
