
#import "ZKHData.h"
#import "ZKHConst.h"
#import "ZKHEntity.h"

#define CHANNEL_TABLE @"e_channel"
#define CHANNEL_CREATE_SQL [NSString stringWithFormat:@" create table if not exists %@ (%@ text primary key, %@ text, %@ text, %@ text, %@ integer) ", CHANNEL_TABLE, KEY_UUID, KEY_CODE, KEY_NAME, KEY_PARENT_ID, KEY_ORD_INDEX]
#define CHANNEL_UPDATE_SQL [NSString stringWithFormat:@" insert or replace into %@ (%@, %@, %@, %@,  %@) values (?, ?, ?, ?, ?)", CHANNEL_TABLE, KEY_UUID, KEY_CODE, KEY_NAME, KEY_PARENT_ID, KEY_ORD_INDEX]
#define CHANNEL_QUERY_SQL [NSString stringWithFormat:@" select %@, %@, %@ from %@ order by %@ ", KEY_UUID, KEY_CODE, KEY_NAME, CHANNEL_TABLE, KEY_ORD_INDEX]

@implementation ZKHChannelData

- (id)init
{
    if (self = [super init]) {
        [self createTable:CHANNEL_CREATE_SQL];
    }
    return self;
}

- (void)save:(NSArray *)data
{
    if (data == nil || [data count] == 0) {
        return;
    }
    for (ZKHChannelEntity *channel in data) {
        [self executeUpdate:CHANNEL_UPDATE_SQL params:@[channel.uuid, channel.code, channel.name, channel.parentId, channel.ordIndex]];
    }
}

- (NSMutableArray *)getChannels
{
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    
    NSLog(@"sql : %@", CHANNEL_QUERY_SQL);
    sqlite3 *database = nil;
    @try {
        database = [self openDatabase];
        sqlite3_stmt *stmt;
        
        @try {
            stmt = [self prepareStatement:CHANNEL_QUERY_SQL params:nil database:database];
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                ZKHChannelEntity *channel = [[ZKHChannelEntity alloc] init];
                
                int i = 0;
                channel.uuid = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt, i++)];
                channel.code = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt, i++)];
                channel.name = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(stmt, i++)];
                
                [channels addObject:channel];
            }
        }
        @catch (NSException *exception) {
            @throw exception;
        }
        @finally {
            sqlite3_finalize(stmt);
        }
    }
    @catch (NSException *exception) {
        @throw exception;
    }
    @finally {
        [self closeDatabase:database];
    }
    
    return channels;
}

@end