//
//  ZKHProcessor+Sale.h
//  ZheKouHu
//
//  Created by undyliu on 14-5-21.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHProcessor.h"
#import "ZKHEntity.h"

@interface ZKHProcessor (Sale)

typedef void (^SalesResponseBlock)(NSMutableArray* sales);
- (void) salesForChannel: (NSString *) channelId updateTime:(ZKHSyncEntity *) syncEntity completionHandler:(SalesResponseBlock) salesBlock errorHandler:(MKNKErrorBlock) errorBlock;

- (void) discussesForSale: (NSString *) saleId updateTime:(ZKHSyncEntity *) syncEntity completionHandler:(SalesResponseBlock) saleDiscussesBlock errorHandler:(MKNKErrorBlock) errorBlock;

typedef void (^SaleResponseBlock)(ZKHSaleEntity* sale);
- (void) sale: (NSString *) uuid userId:(NSString *)userId completionHandler:(SaleResponseBlock) saleBlock errorHandler:(MKNKErrorBlock) errorBlock;

- (void) publishSale: (ZKHSaleEntity *) sale completionHandler:(BooleanResultResponseBlock) publishSaleBlock errorHandler:(MKNKErrorBlock) errorBlock;
@end
