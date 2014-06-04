//
//  ZKHProcessor+Sale.m
//  ZheKouHu
//
//  Created by undyliu on 14-5-21.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHProcessor+Sale.h"
#import "ZKHConst.h"
#import "ZKHData.h"
#import "NSString+Utils.h"

@implementation ZKHProcessor (Sale)

- (ZKHSaleEntity *) saleFormJsonObject:(id)json
{
    ZKHSaleEntity *sale = [[ZKHSaleEntity alloc] init];
    
    sale.uuid = [json valueForKey:KEY_UUID];
    sale.title = [json valueForKey:KEY_TITLE];
    sale.content = [json valueForKey:KEY_CONTENT];
    sale.img = [json valueForKey:KEY_IMG];
    sale.startDate = [json valueForKey:KEY_START_DATE];
    sale.endDate = [json valueForKey:KEY_END_DATE];
    sale.visitCount = [json valueForKey:KEY_VISIT_COUNT];
    sale.discussCount = [json valueForKey:KEY_DIS_COUNT];
    
    ZKHShopEntity *shop = [[ZKHShopEntity alloc] init];
    shop.uuid = [json valueForKey:KEY_SHOP_ID];
    shop.name = [json valueForKey:KEY_SHOP_NAME];
    shop.location = [[ZKHLocationEntity alloc] initWithString:[json valueForKey:KEY_LOCATION]];
    sale.shop = shop;
    
    ZKHUserEntity *publisher = [[ZKHUserEntity alloc] init];
    publisher.uuid = [json valueForKey:KEY_PUBLISHER];
    sale.publisher = publisher;
    
    sale.tradeId = [json valueForKey:KEY_TRADE_ID];
    sale.publishTime = [json valueForKey:KEY_PUBLISH_TIME];
    sale.publishDate = [json valueForKey:KEY_PUBLISH_DATE];
    sale.channelId = [json valueForKey:KEY_CHANNEL_ID];
    sale.status = [json valueForKey:KEY_STATUS];
    
    return sale;
}

#define GET_SALES_BY_CHANNEL_URL @"/getSalesByChannel"
- (void)salesForChannel:(NSString *)channelId updateTime:(ZKHSyncEntity *) syncEntity completionHandler:(SalesResponseBlock)salesBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    ZKHSaleData *saleData = [[ZKHSaleData alloc] init];
    NSMutableArray *sales = [saleData salesForChannel:channelId];
    if ([sales count] > 0) {
        salesBlock(sales);
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", GET_SALES_BY_CHANNEL_URL, [channelId mk_urlEncodedString], [syncEntity.updateTime mk_urlEncodedString]];
    
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = path;
    request.method = METHOD_GET;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:10];
        if (jsonObject != nil) {
            NSString *updateTime = [jsonObject valueForKey:KEY_UPDATE_TIME];
            
            id saleJsons = [jsonObject valueForKey:KEY_DATA];
            for (id json in saleJsons) {
                ZKHSaleEntity *sale = [self saleFormJsonObject:json];
                [sales addObject:sale];
            }
            
            [saleData save:sales];
            
            syncEntity.updateTime = updateTime;
            [[[ZKHSyncData alloc] init] save:@[syncEntity]];
        }
        
        
        salesBlock(sales);
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

#define GET_DISCUSSES_BY_SALE_URL @"/getSaleDiscusses"
- (void)discussesForSale:(NSString *)saleId updateTime:(ZKHSyncEntity *)syncEntity completionHandler:(SalesResponseBlock)saleDiscussesBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    ZKHSaleDiscussData *disData = [[ZKHSaleDiscussData alloc] init];
    NSMutableArray *discusses = [disData discussesForSale:saleId];
    if ([discusses count] > 0) {
        saleDiscussesBlock(discusses);
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@", GET_DISCUSSES_BY_SALE_URL, [saleId mk_urlEncodedString], [syncEntity.updateTime mk_urlEncodedString]];
    
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = path;
    request.method = METHOD_GET;
    
    [restClient execute:request completionHandler:^(NSHTTPURLResponse *response, id jsonObject) {
        NSMutableArray *discusses = [[NSMutableArray alloc] init];
        if (jsonObject != nil) {
            NSString *updateTime = [jsonObject valueForKey:KEY_UPDATE_TIME];
            
            id disJsons = [jsonObject valueForKey:KEY_DATA];
            for (id jsonDis in disJsons) {
                ZKHSaleDiscussEntity *dis = [[ZKHSaleDiscussEntity alloc] init];
                dis.uuid = [jsonDis valueForKey:KEY_UUID];
                dis.content = [jsonDis valueForKey:KEY_CONTENT];
                dis.saleId = [jsonDis valueForKey:KEY_SALE_ID];
                dis.publishTime = [jsonDis valueForKey:KEY_PUBLISH_TIME];
                
                NSMutableDictionary *userJson = [jsonDis mutableCopy];
                [userJson setObject:userJson[KEY_PUBLISHER] forKey:KEY_UUID];
                [userJson setObject:userJson[KEY_USER_NAME] forKey:KEY_NAME];
                dis.publisher = [[ZKHUserEntity alloc]initWithJsonObject:userJson noPwd:true];
                
                [discusses addObject:dis];
            }
            
            [disData save:discusses];
            
            syncEntity.updateTime = updateTime;
            //[[[ZKHSyncData alloc] init] save:@[syncEntity]];
            
        }
        saleDiscussesBlock(discusses);
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

#define  GET_SALE_URL(__UUID__, __USER_ID__) [NSString stringWithFormat:@"/getSaleData/%@/%@", __UUID__, __USER_ID__]
- (void)sale:(NSString *)uuid userId:(NSString *)userId completionHandler:(SaleResponseBlock)saleBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    ZKHSaleData *saleData = [[ZKHSaleData alloc] init];
    ZKHSaleEntity *sale = [saleData sale:uuid];
    if (sale) {
        saleBlock(sale);
        return;
    }
    
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = GET_SALE_URL(uuid, userId);
    request.method = METHOD_GET;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        if (jsonObject) {
            ZKHSaleEntity *sale = [self saleFormJsonObject:jsonObject];
            [saleData save:@[sale]];
            saleBlock(sale);
        }else{
            saleBlock(nil);
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
    
}

//发布活动
#define ADD_SALE_URL @"/addSale"
- (void)publishSale:(ZKHSaleEntity *)sale completionHandler:(BooleanResultResponseBlock)publishSaleBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = ADD_SALE_URL;
    request.method = METHOD_POST;
    request.params = @{KEY_TITLE: sale.title, KEY_CONTENT: sale.content, KEY_SHOP_ID: sale.shop.uuid, KEY_TRADE_ID:sale.tradeId, KEY_START_DATE: sale.startDate, KEY_END_DATE: sale.endDate, KEY_PUBLISHER: sale.publisher.uuid};
    request.files = sale.images;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if ([NSString isNull:uuid]) {
            publishSaleBlock(false);
        }else{
            sale.uuid = uuid;
            sale.publishTime = jsonObject[KEY_PUBLISH_TIME];
            sale.publishDate = jsonObject[KEY_PUBLISH_DATE];
            sale.status = jsonObject[KEY_STATUS];
            sale.img = jsonObject[KEY_IMG];
            sale.visitCount = @"0";
            sale.discussCount = @"0";
            sale.channelId = jsonObject[KEY_CHANNEL_ID];
            if (sale.channelId == nil) {
                sale.channelId = @"";
            }
            
            NSMutableArray *files = [[NSMutableArray alloc] init];
            id jsonImages = jsonObject[KEY_IMAGES];
            for (id jsonImage in jsonImages) {
                ZKHFileEntity *file = [[ZKHFileEntity alloc] init];
                file.uuid = jsonImage[KEY_UUID];
                file.aliasName = jsonImage[KEY_IMG];
                file.ordIndex = jsonImage[KEY_ORD_INDEX];
                
                [files addObject:file];
            }
            
            sale.images = files;
            
            [[[ZKHSaleData alloc] init] save:@[sale]];
            
            publishSaleBlock(true);
        }
    } errorHandler:^(NSError *error) {
        errorBlock(error);
    }];
}

@end
