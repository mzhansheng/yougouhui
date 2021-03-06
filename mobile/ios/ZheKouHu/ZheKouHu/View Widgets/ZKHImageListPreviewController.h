//
//  ZKHSaleImageListController.h
//  ZheKouHu
//
//  Created by undyliu on 14-6-9.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKHImageListPreviewController : UIViewController <UIPageViewControllerDataSource>
{
    NSMutableArray *files;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *imageFiles;
@property (assign, nonatomic) int currentIndex;
@end
