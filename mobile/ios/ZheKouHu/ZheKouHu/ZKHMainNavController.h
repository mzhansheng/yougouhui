//
//  ZKHMainNavController.h
//  ZheKouHu
//
//  Created by undyliu on 14-5-19.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"

@interface ZKHMainNavController : UINavigationController<UIPopoverListViewDataSource, UIPopoverListViewDelegate>
{
    UIViewController * rootController;
    NSArray* moreItems;
}

- (void) reloadData;

- (void) clickSearch: (id)sender;
- (void) clickMore: (id)sender;
- (void) clickProfile: (id)sender;

@end
