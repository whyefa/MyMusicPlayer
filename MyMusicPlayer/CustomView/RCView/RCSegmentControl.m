//
//  RCSegmentControl.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "RCSegmentControl.h"

#define SEGMENT_UNSELECTED 0

#define SEGMENT_SELECTED 1

@implementation RCSegmentControl

- (id) initWithFrame:(CGRect)frame items:(NSArray*)itemArray

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        int segmentCount = [itemArray count];
        
        segmentButtons = [[NSMutableArray alloc] init];
        
        buttonTitles = [[NSMutableArray alloc] init];
        
        float segmentWidth = frame.size.width/segmentCount;
        
        for (int i=0; i<segmentCount; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(segmentWidth*i, 0,
                                      
                                      segmentWidth, frame.size.height);

//            button.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            button.tag = i;
            
            [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitle:[itemArray objectAtIndex:i] forState:UIControlStateNormal];
            
            [segmentButtons addObject:button];
            
            [self addSubview:button];
            
        }
        
        [self setSegmentIndex:0];
        
    }
    
    return self;
    
}


-(void)setSegmentIndex:(NSInteger)index

{
    
    _selectedSegmentIndex = index;
    
    [self segmentAction:[segmentButtons objectAtIndex:index]];
    
}


-(void)segmentAction:(id)sender

{
    
    UIButton *button = (UIButton*)sender;
    
    int tag =  button.tag;
    
    for(int i=0; i<[segmentButtons count]; i++){
        
        int nameOffset = SEGMENT_UNSELECTED;
        UIButton *segButton = [segmentButtons objectAtIndex:i];

        if (tag == i) {
            nameOffset = SEGMENT_SELECTED;
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            if (self.buttonClick) {
                self.buttonClick(i);
            }
            
        }else{
            [segButton setTitleColor:[UIColor colorWithWhite:0.94 alpha:0.68] forState:UIControlStateNormal];
            [segButton setTitleColor:[UIColor colorWithWhite:0.94 alpha:0.68] forState:UIControlStateHighlighted];
        }
        
        

        
    }
    
}
@end
