//
//  RCSegmentControl.h
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(int index);        //点击任意 button 回调
@interface RCSegmentControl : UIView
{
    NSMutableArray *segmentButtons;
    NSMutableArray *buttonTitles;
}
@property (readonly,nonatomic) NSInteger selectedSegmentIndex;

@property (nonatomic,strong) ClickBlock buttonClick;

- (id)initWithFrame:(CGRect)frame items:(NSArray*)itemArray;

- (void)setSegmentIndex:(NSInteger)index;
@end
