//
//  ZKHSaleImageListController.h
//  ZheKouHu
//
//  Created by undyliu on 14-6-6.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKHSaleImageListController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *imageFiles;

@property (strong, nonatomic) IBOutlet UICollectionView *mainView;

@end
