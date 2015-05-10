//
//  HomeViewController.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-29.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "HomeViewController.h"

#import "MyViewController.h"
#import "MusicStoreViewController.h"
#import "FindViewController.h"




#import "RCSegmentControl.h"




@interface HomeViewController ()

@end

@implementation HomeViewController{
    UIScrollView *scrollview;
}
#pragma mark- LifeCycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItems];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
}



#pragma mark - SubViews
- (void)setNavigationItems{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 35, 35);
    [searchBtn setWithImage:@"search_edit_top_img"];
    [searchBtn setEdgeInsets:-10];
    [searchBtn addTarget:self action:@selector(homeShowSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    

    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 60, 44);
    [moreBtn setWithNormalImage:@"maintabbar_button_more_normal" hightLightImage:@"maintabbar_button_more_highlight"];
    [moreBtn addTarget:self action:@selector(homeShowSearchView) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setEdgeInsets:15];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    RCSegmentControl *segment = [[RCSegmentControl alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-120, 40)   items:@[@"我的",@"音乐馆",@"发现"]];
//   __block RCSegmentControl *seg =  segment;
    segment.buttonClick = ^(int index){
        
        NSLog(@"第几个导航页% d",index);
    };
        
   
//    [segment addTarget:self action:@selector(selectViewController:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    
    
}

- (void)homeShowSearchView{
    NSLog(@"%s",__func__);
}
- (void)selectViewController:(UISegmentedControl*)seg{
    NSLog(@"%s",__func__);
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
