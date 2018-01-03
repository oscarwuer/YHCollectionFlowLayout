//
//  YHCollectionFlowLayout.h
//  MobileMovieTheater
//
//  Created by 张长弓 on 2017/12/4.
//  Copyright © 2017年 zuoyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHCollectionFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat currentCount;

-(void)setContentSize:(NSUInteger)count;

@end
