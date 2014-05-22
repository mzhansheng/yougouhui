//
//  ZKHShopMainController.m
//  ZheKouHu
//
//  Created by undyliu on 14-5-22.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHShopMainController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionCell.h"
#import "UITableView+DataSourceBlocks.h"
#import "TableViewWithBlock.h"
#import "ZKHShopModuleCell.h"
#import "ZKHShopInfoController.h"

static NSString *CellIdentifier = @"ShopModuleCell";

@implementation ZKHShopMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的店铺";
    self.statusLabel.text = @"";
    
    ZKHShopEntity *shop = self.shops[0];
    if (shop != nil) {
        [self shopSelected:shop];
    }
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickMore:)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    isOpened = NO;
    int count = [self.shops count];
    
    [self.tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return count;
        
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        ZKHShopEntity *shop = self.shops[indexPath.row];
        cell.lb.text = shop.name;
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        ZKHShopEntity *shop = self.shops[indexPath.row];
        [self shopSelected:shop];
        [_openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [_tb.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tb.layer setBorderWidth:2];
    
    UINib *nib = [UINib nibWithNibName:@"ZKHShopModuleCell" bundle:nil];
    [self.modulesView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
    self.modulesView.backgroundColor = [UIColor whiteColor];
}

- (void) shopSelected:(ZKHShopEntity *) shop
{
    if (shop != nil) {
        self.inputTextField.text = shop.name;
        NSString *status = shop.status;
        if ([@"1" isEqualToString:status]) {
            self.statusLabel.text = @"已审核";
        }else if ([@"0" isEqualToString:status]){
            self.statusLabel.text = @"已注册";
        }else if ([@"2" isEqualToString:status]){
            self.statusLabel.text = @"已注销";
        }
    }
}

- (void)clickMore:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                   initWithTitle:nil
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"修改密码",@"发布新活动",
                   nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIViewController *controller;
    switch (buttonIndex) {
        case 0://changge pwd
                
            break;
        case 1://publish now sale
            break;
        default:
            break;
    }
    
    if (controller != nil) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeOpenStatus:(id)sender {
    
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
            [_openButton setImage:closeImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            
            frame.size.height=1;
            [_tb setFrame:frame];
            self.modulesView.hidden = false;
        } completion:^(BOOL finished){
            
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
            [_openButton setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            frame.size.height = 35 * [self.shops count];
            [_tb setFrame:frame];
            self.modulesView.hidden = true;
        } completion:^(BOOL finished){
            
            isOpened=YES;
        }];
        
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZKHShopModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 0 && row == 0) {
        cell.mImageView.image = [UIImage imageNamed:@"shop_info.png"];
        cell.mNameLabel.text = @"基本信息";
    }else if (section == 0 && row == 1){
        cell.mImageView.image = [UIImage imageNamed:@"emp_setting.png"];
        cell.mNameLabel.text = @"职员设置";
    }else if (section == 1 && row == 0){
        cell.mImageView.image = [UIImage imageNamed:@"sale_info.png"];
        cell.mNameLabel.text = @"促销活动";
    }else if (section == 1 && row == 1){
        cell.mImageView.image = [UIImage imageNamed:@"share_interact.png"];
        cell.mNameLabel.text = @"分享互动";
    }
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 0 && row == 0) {
        ZKHShopInfoController *controller = [[ZKHShopInfoController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (section == 0 && row == 1){
        
    }else if (section == 1 && row == 0){
        
    }else if (section == 1 && row == 1){
        
    }
}
@end