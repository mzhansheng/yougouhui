//
//  ZKHProcessor+Shop.m
//  ZheKouHu
//
//  Created by undyliu on 14-5-22.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHProcessor+Shop.h"
#import "ZKHConst.h"

@implementation ZKHProcessor (Shop)

//登录商铺
#define LOGIN_URL @"/loginShopByPhone"
- (void)loginShopByPhone:(NSString *)phone pwd:(NSString *)pwd completionHandler:(LoginResponseBlock)loginBlock errorHandler:(MKNKErrorBlock)errorBlock
{
    NSDictionary *params = @{KEY_PHONE : phone, KEY_PWD : pwd};
    MKNetworkOperation *op = [self operationWithPath:LOGIN_URL params:params httpMethod:METHOD_POST];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            NSMutableDictionary *authedObj = [[NSMutableDictionary alloc] init];
            Boolean authed = [[jsonObject valueForKey:KEY_AUTHED] boolValue];
            switch (authed) {
                case 1:
                {
                    NSDictionary *userJson = [jsonObject valueForKey:KEY_USER];
                    
                    ZKHUserEntity *user = [[ZKHUserEntity alloc] init];
                    user.uuid = [userJson valueForKey:KEY_UUID];
                    user.name = [userJson valueForKey:KEY_NAME];
                    //user.pwd = [userJson valueForKey:KEY_PWD];密码和类别未返回
                    //user.type = [userJson valueForKey:KEY_TYPE];
                    user.phone = [userJson valueForKey:KEY_PHONE];
                    user.photo = [userJson valueForKey:KEY_PHOTO];
                    user.registerTime = [userJson valueForKey:KEY_REGISTER_TIME];
                    
                    NSMutableArray * shops = [[NSMutableArray alloc] init];
                    id shopList = [jsonObject valueForKey:KEY_DATA];
                    for (NSDictionary *jsonShop in shopList) {
                        ZKHShopEntity *shop = [[ZKHShopEntity alloc] init];
                        shop.uuid = [jsonShop valueForKey:KEY_UUID];
                        shop.name = [jsonShop valueForKey:KEY_NAME];
                        shop.addr = [jsonShop valueForKey:KEY_ADDR];
                        shop.desc = [jsonShop valueForKey:KEY_DESC];
                        shop.shopImg = [jsonShop valueForKey:KEY_SHOP_IMG];
                        shop.busiLicense = [jsonShop valueForKey:KEY_BUSI_LICENSE];
                        shop.registerTime = [jsonShop valueForKey:KEY_REGISTER_TIME];
                        shop.owner = [jsonShop valueForKey:KEY_OWNER];
                        shop.status = [NSString stringWithFormat:@"%@", [jsonShop valueForKey:KEY_STATUS]];
                        shop.barcode = [jsonShop valueForKey:KEY_BARCODE];
                        
                        [shops addObject:shop];
                    }
                    
                    [authedObj setObject:shops forKey:KEY_SHOP_LIST];
                    [authedObj setObject:user forKey:KEY_USER];
                    [authedObj setObject:@"true" forKey:KEY_AUTHED];
                }
                    break;
                    
                default:
                {
                    [authedObj setObject:[jsonObject valueForKey:KEY_ERROR_TYPE] forKey:KEY_ERROR_TYPE];
                    [authedObj setObject:@"false" forKey:KEY_AUTHED];
                }
                    break;
            }
            
            loginBlock(authedObj);
        }];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
}

@end