//
//  ZKHChangeTextController.h
//  ZheKouHu
//
//  Created by undyliu on 14-5-23.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKHChangeTextController : UIViewController
{
    NSString *orginalValue;
}

- (NSString *) getOriginalTextFieldValue;

- (IBAction)save:(id)sender;
- (void) doSave:(NSString *) newValue;

@end
