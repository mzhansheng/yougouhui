//
//  ZKHProcessor+Share.m
//  ZheKouHu
//
//  Created by undyliu on 14-6-3.
//  Copyright (c) 2014年 undyliu. All rights reserved.
//

#import "ZKHProcessor+Share.h"
#import "ZKHConst.h"
#import "NSString+Utils.h"
#import "ZKHData.h"
#import "ZKHProcessor+Sync.h"
#import "ZKHAppDelegate.h"
#import "NSDate+Utils.h"
#import "ZKHContext.h"

@implementation ZKHProcessor (Share)

//发布分享
#define PUBLISH_SHARE_URL @"/saveShare"
- (void)publishShare:(ZKHShareEntity *)share completionHandler:(BooleanResultResponseBlock)publishShareBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.method = METHOD_POST;
    request.urlString = PUBLISH_SHARE_URL;
    request.params = @{KEY_CONTENT: share.content, KEY_PUBLISHER:share.publisher.uuid, KEY_SHOP_ID: (share.shop !=nil ? share.shop.uuid : @""), KEY_ACCESS_TYPE: share.accessType};
    request.files = share.imageFiles;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if (![NSString isNull:uuid]) {
            share.uuid = uuid;
           
            share.publishTime = [jsonObject[KEY_PUBLISH_TIME] stringValue];
            share.publishDate = jsonObject[KEY_PUBLISH_DATE];
            
            NSMutableArray *files = [[NSMutableArray alloc] init];
            id jsonImages = jsonObject[KEY_IMAGES];
            for (id jsonImage in jsonImages) {
                ZKHFileEntity *file = [[ZKHFileEntity alloc] init];
                file.uuid = jsonImage[KEY_UUID];
                file.aliasName = jsonImage[KEY_IMG];
                [files addObject:file];
            }
            share.imageFiles = files;
            
            //商铺信息
            id jsonShop = jsonObject[KEY_SHOP];
            if (jsonShop) {
                NSString *shopId = jsonShop[KEY_UUID];
                if (![NSString isNull:shopId]) {
                    share.shop = [[ZKHShopEntity alloc] initWithJsonObject:jsonShop];
                }
            }else{
                share.shop = nil;
            }
            
            [[[ZKHShareData alloc] init] save:@[share]];
            
            publishShareBlock(true);
        }else{
            publishShareBlock(false);
        }
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

- (ZKHSyncEntity *) shareSyncEntity
{
    ZKHUserEntity *user = [ZKHContext getInstance].user;
    ZKHSyncEntity *sync = [ApplicationDelegate.zkhProcessor getSyncEntity: SHARE_TABLE itemId:user.uuid];
    if (sync == nil) {
        sync = [[ZKHSyncEntity alloc] init];
        NSString *currentTime = [NSDate currentTimeString];
        sync.updateTime = user.registerTime;
        sync.uuid = [currentTime copy];
        sync.tableName = SALE_TABLE;
        sync.itemId = user.uuid;
    }
    return sync;
}

#define  GET_FRIEND_SHARES_URL(__USER_ID__, __UPDATE_TIME__) [NSString stringWithFormat:@"/getFriendShares/%@/%@", __USER_ID__, __UPDATE_TIME__]
- (void)friendShares:(NSString *)userId offset:(int)offset completionHandler:(SharesResponseBlock)sharesBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHShareData *shareData = [[ZKHShareData alloc] init];
    if (userId) {
        NSMutableArray *shares = [shareData friendShares:userId offset:offset];
        if ([shares count] > 0) {
            sharesBlock(shares);
            return;
        }
    }
    
    ZKHSyncEntity *shareSync = [self shareSyncEntity];
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = GET_FRIEND_SHARES_URL([ZKHContext getInstance].user.uuid, shareSync.updateTime);
    request.method = METHOD_GET;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSMutableArray *shares = [[NSMutableArray alloc] init];
        if (jsonObject != nil) {
            NSString *updateTime = [jsonObject valueForKey:KEY_UPDATE_TIME];
            
            id jsonShares = [jsonObject valueForKey:KEY_DATA];
            for (id jsonShare in jsonShares) {
                //删除
                NSNumber *isDel = jsonShare[KEY_IS_DELETED];
                if ([isDel intValue] == 1) {
                    [shareData deleteShare:[jsonShare valueForKey:KEY_UUID]];
                    continue;
                }
                
                ZKHShareEntity *share = [[ZKHShareEntity alloc] init];
                share.uuid = jsonShare[KEY_UUID];
                share.content = jsonShare[KEY_CONTENT];
                
                //发布者
                id jsonUser = jsonShare[KEY_USER];
                if (jsonUser) {
                    share.publisher = [[ZKHUserEntity alloc] initWithJsonObject:jsonUser noPwd:true];
                }
                
                share.publishTime = jsonShare[KEY_PUBLISH_TIME];
                share.publishDate = jsonShare[KEY_PUBLISH_DATE];
        
                //商铺信息
                id jsonShop = jsonShare[KEY_SHOP];
                if (jsonShop) {
                    NSString *shopId = jsonShop[KEY_UUID];
                    if (![NSString isNull:shopId]) {
                        share.shop = [[ZKHShopEntity alloc] initWithJsonObject:jsonShop];
                    }
                }
        
                share.accessType = jsonShare[KEY_ACCESS_TYPE];
        
                //分享图片信息
                NSMutableArray *images = [[NSMutableArray alloc] init];
                id jsonImages = jsonShare[KEY_IMAGES];
                for (id jsonImage in jsonImages) {
                    ZKHFileEntity *image = [[ZKHFileEntity alloc] init];
                    image.uuid = jsonImage[KEY_UUID];
                    image.aliasName = jsonImage[KEY_IMG];
                    image.ordIndex = jsonImage[KEY_ORD_INDEX];
                    
                    [images addObject: image];
                }
                share.imageFiles = images;
                
                //处理评论
                NSMutableArray *comments = [[NSMutableArray alloc] init];
                id jsonComments = jsonShare[KEY_COMMENTS];
                for (id jsonComment in jsonComments) {
                    //删除评论
                    NSNumber *isDel = jsonComment[KEY_IS_DELETED];
                    if ([isDel intValue] == 1) {
                        [[[ZKHShareCommentData alloc] init] deleteComment:jsonComment[KEY_UUID]];
                        continue;
                    }
                    
                    ZKHShareCommentEntity *comment = [[ZKHShareCommentEntity alloc] init];
                    comment.uuid = jsonComment[KEY_UUID];
                    comment.shareId = jsonComment[KEY_SHARE_ID];
                    comment.content = jsonComment[KEY_CONTENT];
                    comment.publishTime = jsonComment[KEY_PUBLISH_TIME];
                    
                    NSMutableDictionary *jsonUser = [jsonComment mutableCopy];
                    [jsonUser setObject:jsonUser[KEY_PUBLISHER] forKey:KEY_UUID];
                    comment.pulisher = [[ZKHUserEntity alloc] initWithJsonObject:jsonUser noPwd:true];
                    
                    [comments addObject:comment];
                }
                share.comments = comments;
                
                //处理商铺的反馈
                id shopReply = jsonShare[KEY_SHOP_REPLY];
                if (shopReply) {
                    NSString *replyId = shopReply[KEY_UUID];
                    if (![NSString isNull:replyId]) {
                        share.shopReply = [[ZKHShareShopReplyEntity alloc] initWithJsonObject:shopReply];
                    }
                }
                
                [shares addObject:share];
            }
            
            shareSync.updateTime = updateTime;
            
            [[[ZKHShareData alloc] init] save:shares];
            //[[[ZKHSyncData alloc] init] save:@[shareSync]];
        }
        sharesBlock(shares);
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

#define ADD_COMMENT_URL @"saveComment"
- (void)addComment:(ZKHShareCommentEntity *)comment completionHandler:(BooleanResultResponseBlock)addCommentBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = ADD_COMMENT_URL;
    request.method = METHOD_POST;
    request.params = @{KEY_SHARE_ID: comment.shareId, KEY_CONTENT:comment.content, KEY_PUBLISHER:comment.pulisher.uuid};
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if ([NSString isNull:uuid]) {
            addCommentBlock(false);
        }else{
            comment.uuid = uuid;
            comment.publishTime = jsonObject[KEY_PUBLISH_TIME];
            
            [[[ZKHShareCommentData alloc] init] save:@[comment]];
            
            addCommentBlock(true);
        }
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

#define DEL_COMMENT(__UUID__) [NSString stringWithFormat:@"/deleteComment/%@", __UUID__]
- (void)deleteComment:(ZKHShareCommentEntity *)comment completionHandler:(BooleanResultResponseBlock)deleteCommentBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = DEL_COMMENT(comment.uuid);
    request.method = METHOD_DELETE;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if ([NSString isNull:uuid]) {
            deleteCommentBlock(false);
        }else{
            [[[ZKHShareCommentData alloc] init] deleteComment:comment.uuid];
            deleteCommentBlock(true);
        }
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

#define DEL_SHARE(__UUID__) [NSString stringWithFormat:@"/deleteShare/%@", __UUID__]
- (void)deleteShare:(ZKHShareEntity *)share completionHandler:(BooleanResultResponseBlock)deleteShareBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = DEL_SHARE(share.uuid);
    request.method = METHOD_DELETE;
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if ([NSString isNull:uuid]) {
            deleteShareBlock(false);
        }else{
            [[[ZKHShareData alloc] init] deleteShare:share.uuid];
            deleteShareBlock(true);
        }
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

- (void)sharesGroupByPublishDate:(NSString *)searchWord userId:(NSString *)userId offset:(int)offset completionHandler:(SharesResponseBlock)shareBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHShareData *shareData = [[ZKHShareData alloc] init];
    NSMutableArray *shareCountList = [shareData sharesGroupByPublishDate:searchWord userId:userId offset:offset];
    shareBlock(shareCountList);
}

- (void)sharesByShop:(NSString *)searchWord shopId:(NSString *)shopId offset:(int)offset completionHandler:(SharesResponseBlock)shareBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHShareData *shareData = [[ZKHShareData alloc] init];
    NSMutableArray *shares = [shareData sharesByShop:searchWord shopId:shopId offset:offset];
    shareBlock(shares);
}

#define SAVE_SHARE_SHOP_REPLY_URL @"/saveShareReply"
- (void)saveShareShopReply:(ZKHShareShopReplyEntity *)shopReply completionHandler:(BooleanResultResponseBlock)saveShopReplyBlock errorHandler:(RestResponseErrorBlock)errorBlock
{
    ZKHRestRequest *request = [[ZKHRestRequest alloc] init];
    request.urlString = SAVE_SHARE_SHOP_REPLY_URL;
    request.method = METHOD_POST;
    request.params = @{KEY_SHARE_ID: shopReply.shareId, KEY_SHOP_ID: shopReply.shopId, KEY_CONTENT: shopReply.content, KEY_REPLIER: shopReply.replier, KEY_GRADE:[NSString stringWithFormat:@"%d", shopReply.grade]};
    
    [restClient executeWithJsonResponse:request completionHandler:^(id jsonObject) {
        NSString *uuid = jsonObject[KEY_UUID];
        if ([NSString isNull:uuid]) {
            saveShopReplyBlock(false);
        }else{
            shopReply.uuid = uuid;
            shopReply.replyTime = jsonObject[KEY_REPLY_TIME];
            shopReply.status = jsonObject[KEY_STATUS];
            
            [[[ZKHShareReplyData alloc] init] save:@[shopReply]];
            
            saveShopReplyBlock(true);
        }
    } errorHandler:^(ZKHErrorEntity *error) {
        errorBlock(error);
    }];
}

@end
