//
//  MyViewController.m
//  MyMusicPlayer
//
//  Created by 游侠 on 15-3-30.
//  Copyright (c) 2015年 rc. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MyViewController
@synthesize tableView = _tableView;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"我的");
    self.view.backgroundColor = [UIColor purpleColor];
}
#pragma mark- TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if(indexPath.section == 1){
        
    }else if(indexPath.section == 2){
        
    }else if(indexPath.section == 3){
        
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"errorCell"];
    cell.textLabel.text = @"errorCell";
    return cell;
}

#pragma mark- TABLEVIEW  DELEGATE
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger sec = indexPath.section;
    if (sec == 0) {
        return 60;
    }else if(sec == 1){
        return 230.0f;
    }else if(sec == 2){
       return  60.0f;
    }else{
        return 200.0f;
    }
    return 60.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    static NSString *footViewIndentifier = @"foot View";
    UIView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footViewIndentifier];
    if (!footView) {
        footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        footView.backgroundColor = BACKGROUND_COLOR;
    }
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
@end
