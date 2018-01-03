//
//  YHCollectionFlowLayout.m
//  MobileMovieTheater
//
//  Created by 张长弓 on 2017/12/4.
//  Copyright © 2017年 zuoyou. All rights reserved.
//

#import "YHCollectionFlowLayout.h"
#import "YHCollectionViewCell.h"
#import "UIView+FrameCategory.h"

@interface YHCollectionFlowLayout ()

@property(nonatomic, assign) NSUInteger count;

@end

@implementation YHCollectionFlowLayout

-(instancetype)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(screen_width, CELL_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
        self.currentCount = 1;
    }
    return self;
}

#pragma mark - Outside Methods

-(void)setContentSize:(NSUInteger)count {
    self.count = count;
}

#pragma mark -

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    return attr;
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(screen_width, HEADER_HEIGHT+DRAG_INTERVAL*self.count+([UIScreen mainScreen].bounds.size.height-DRAG_INTERVAL));
}

-(void)prepareLayout {
    [super prepareLayout];
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    float screen_y = self.collectionView.contentOffset.y;
    float current_floor = floorf((screen_y-HEADER_HEIGHT)/DRAG_INTERVAL)+1;
    float current_mod = fmodf((screen_y-HEADER_HEIGHT), DRAG_INTERVAL);
    float percent = current_mod/DRAG_INTERVAL;
    
    //计算当前应该显示在屏幕上的CELL在默认状态下应该处于的RECT范围，范围左右范围进行扩展，避免出现BUG
    //之前的方法采用所有ITEM进行布局计算，当ITEM太多后，会严重影响性能体验，所有采用这种方法
    CGRect correctRect;
    if(current_floor == 0 || current_floor == 1){ //因为导航栏和当前CELL的高度特殊，所有做特殊处理
        correctRect = CGRectMake(0, 0, screen_width, RECT_RANGE);
    }else{
        correctRect = CGRectMake(0, HEADER_HEIGHT+HEADER_HEIGHT+CELL_HEIGHT*(current_floor-2), screen_width, RECT_RANGE);
    }
    NSArray * original = [super layoutAttributesForElementsInRect:correctRect];
    NSArray* array = [[NSArray alloc] initWithArray:original copyItems:YES];
    
    CGFloat riseOfCurrentItem = CELL_CURRHEIGHT-DRAG_INTERVAL; //当前ITEM Y坐标提高的量
    CGFloat incrementalHeightOfCurrentItem = CELL_CURRHEIGHT-CELL_HEIGHT; //当前ITEM增加的高度
    CGFloat offsetOfNextItem = incrementalHeightOfCurrentItem - riseOfCurrentItem; //当前ITEM以下的ITEM需要向下移动的位移
    
    if(screen_y >= HEADER_HEIGHT){
        for(UICollectionViewLayoutAttributes *attributes in array){
            NSInteger row = attributes.indexPath.row;
            if(row < current_floor){
                attributes.zIndex = 7;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, screen_width, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor){
                attributes.zIndex = 8;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, screen_width, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if(row == current_floor+1){
                attributes.zIndex = 9;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem-riseOfCurrentItem*percent, screen_width, CELL_HEIGHT+(CELL_CURRHEIGHT-CELL_HEIGHT)*percent);
                [self setEffectViewAlpha:percent forIndexPath:attributes.indexPath];
            }else{
                if (row == current_floor+2) {
                    attributes.zIndex = 6;
                } else if (row == current_floor+3) {
                    attributes.zIndex = 5;
                } else if (row == current_floor+4) {
                    attributes.zIndex = 4;
                } else if (row == current_floor+5) {
                    attributes.zIndex = 3;
                } else if (row == current_floor+6) {
                    attributes.zIndex = 2;
                } else if (row == current_floor+7) {
                    attributes.zIndex = 1;
                } else {
                    attributes.zIndex = 0;
                }
                
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem+offsetOfNextItem*percent, screen_width, CELL_HEIGHT);
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/screen_height*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
            
        }
        
    }else{
        
        for(UICollectionViewLayoutAttributes *attributes in array){
            
            if(attributes.indexPath.row > 1){
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/screen_height*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
            
        }
    }
    
    return array;
}

/**
 *  设置CELL里imageView的位置偏移动画
 */
-(void)setImageViewOfItem:(CGFloat)distance withIndexPath:(NSIndexPath *)indexpath
{
    YHCollectionViewCell *cell = (YHCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
    cell.imageView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y+distance, screen_width, cell.imageView.frame.size.height);
}

-(void)setEffectViewAlpha:(CGFloat)percent forIndexPath:(NSIndexPath *)indexPath
{
    YHCollectionViewCell *cell = (YHCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.maskView.alpha = MAX((1-percent)*0.6, 0);
    
    cell.titleLabel.layer.transform = CATransform3DMakeScale(0.8+0.2*percent, 0.8+0.2*percent, 1);
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = MAX(25, 88*percent);
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-offset);
    }];
    
    cell.descLabel.alpha = percent;
    cell.bottomLabel.alpha = percent;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint destination;
    CGFloat positionY;
    CGFloat screen_y = self.collectionView.contentOffset.y;
    CGFloat cc;
    CGFloat count;
    
    if (screen_y < 0) {
        return proposedContentOffset;
    }
    if(velocity.y == 0){ //此情况可能由于拖拽不放手，停下时再放手的可能，所以加速度为0
        count = roundf(((proposedContentOffset.y-HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        self.currentCount = count;
        if(count == 0){
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }else{
        if(velocity.y>1){
            cc = 1;
        }else if(velocity.y < -1){
            cc = -1;
        }else{
            cc = velocity.y;
        }
        if (velocity.y > 0) {
            count = ceilf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }else{
            count = floorf(((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL))+1;
        }
        if(count == 0){
            positionY = 0;
            self.currentCount = 1;
        }else{
            if (velocity.y > 0) {
                count = self.currentCount + 1;
                self.currentCount++;
            } else {
                count = self.currentCount - 1;
                self.currentCount --;
            }
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }
    
    
    if(positionY < 0){
        positionY = 0;
    }
    if(positionY > self.collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height){
        positionY = self.collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height;
        self.currentCount --;
        count = self.currentCount;
    }
    self.collectionView.decelerationRate = 0.1f;
    destination = CGPointMake(0, positionY);
    return destination;
}


@end
