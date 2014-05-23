//
//  ZKHEntity.m
//  ZheKouHu
//
//  Created by undyliu on 14-5-19.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHEntity.h"
#import "NSString+Utils.h"
#import "ZKHConst.h"

@implementation ZKHEntity

@end

@implementation ZKHFileEntity

- (NSString *) getAliasName
{
    //TODO:
    return _aliasName;
}

@end

@implementation ZKHModuleEntity

@end

@implementation ZKHChannelEntity

@end

@implementation ZKHUserEntity

@end

@implementation ZKHUserFriendsEntity

@end

@implementation ZKHSettingEntity

@end

@implementation ZKHSyncEntity

@end

@implementation ZKHSaleEntity

@end

@implementation ZKHTradeEntity

@end

@implementation ZKHLocationEntity

- (id)initWithString:(NSString *)value
{
    if (self = [super init]) {
        NSDictionary *json = [value toJSONObject];
        self.radius = [json valueForKey:KEY_RADIUS];
        self.latitude = [json valueForKey:KEY_LATITUDE];
        self.longitude = [json valueForKey:KEY_LONGITUDE];
        self.addr = [json valueForKey:KEY_ADDR];
    }
    return self;
}

- (NSDictionary *)toJSONObject
{
    return @{KEY_RADIUS: self.radius,
             KEY_LATITUDE : self.latitude,
             KEY_LONGITUDE : self.longitude,
             KEY_ADDR : self.addr};
}

@end

@implementation ZKHShopTradeEntity

@end

@implementation ZKHShopEntity

@end
