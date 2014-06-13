//
//  ZKHSettingsController.m
//  ZheKouHu
//
//  Created by undyliu on 14-5-19.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHSettingsController.h"
#import "ZKHEntity.h"
#import "ZKHAppDelegate.h"
#import "ZKHContext.h"
#import "ZKHProcessor+Setting.h"
#import "ZKHProcessor+User.h"
#import "ZKHLoginSettingController.h"
#import "ZKHRadarSettingController.h"
#import "ZKHConst.h"
#import "ZKHViewUtils.h"

static NSString *CellIdentifier = @"Cell";

@implementation ZKHSettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [ZKHViewUtils setTableViewExtraCellLineHidden:self.tableView];
    
    [ApplicationDelegate.zkhProcessor settings:^(NSMutableArray *settings) {
        settingItems = settings;
        [self.tableView reloadData];
    } errorHandler:^(ZKHErrorEntity *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ZKHSettingEntity *setting = settingItems[indexPath.row];
    
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:@"Courier" size:14]};

    NSMutableAttributedString *settingString = [[NSMutableAttributedString alloc]
                                                initWithString:setting.name
                                                attributes:attr];
    
    cell.textLabel.attributedText = settingString;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKHSettingEntity *setting = settingItems[indexPath.row];
    if ([SETTING_CODE_LOGOUT isEqualToString:setting.code]) {
        ZKHContext *context = [ZKHContext getInstance];
        
        [ApplicationDelegate.zkhProcessor deleteLoginEnv:context.user.phone];
        
        context.user = nil;
        context.sessionId = nil;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([SETTING_CODE_LOGIN isEqualToString:setting.code]){
        UIViewController *controller = [[ZKHLoginSettingController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([SETTING_CODE_RADAR isEqualToString:setting.code]){
        UIViewController *controller = [[ZKHRadarSettingController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
