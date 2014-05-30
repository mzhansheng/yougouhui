//
//  ZKHNetworkEngine.h
//  ZheKouHu
//
//  Created by undyliu on 14-5-19.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHRestClient.h"

@interface ZKHProcessor : NSObject

{
   @private
    ZKHRestClient *restClient;
}

typedef void (^ZKHImageResponseBlock)(UIImage *fetchedImage);
- (void)imageAtURL:(NSURL *)url completionHandler:(ZKHImageResponseBlock) imageFetchedBlock errorHandler:(RestResponseErrorBlock) errorBlock;

//获取功能模块
typedef void (^ModulesResponseBlock)(NSMutableArray* modules);
- (void) modulesForType: (NSString *) type completionHandler:(ModulesResponseBlock) modulesBlock errorHandler:(RestResponseErrorBlock) errorBlock;

//获取栏目
typedef void (^ChannelsResponseBlock)(NSMutableArray* channels);
- (void) channels: (NSString *)parentId completionHandler:(ChannelsResponseBlock) channelsBlock
     errorHandler:(RestResponseErrorBlock) errorBlock;

//获取主营业务
typedef void (^TradesResponseBlock)(NSMutableArray* trades);
- (void) trades:(Boolean)reload completionHandler:(TradesResponseBlock) tradesBlock
     errorHandler:(RestResponseErrorBlock) errorBlock;

typedef void (^BooleanResultResponseBlock)(Boolean result);

@end
