//
//  EIRadioButton.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRadioButtonDelegate;

@interface QRadioButton : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;
    //id<QRadioButtonDelegate>       _delegate;
}

@property(nonatomic, assign)id<QRadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, strong) id userObject;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol QRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId;

@end
