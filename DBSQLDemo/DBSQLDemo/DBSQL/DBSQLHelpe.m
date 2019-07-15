//
//  DBSQLHelpe.m
//  WuxiAgriculture
//
//  Created by zhangxiaoye on 2019/2/21.
//  Copyright © 2019年 zhangxiaoye. All rights reserved.
//

#import "DBSQLHelpe.h"

@interface DBSQLHelpe()

@property (strong, nonatomic) FMDatabaseQueue *queue;
@end

static DBSQLHelpe *instance = nil;

@implementation DBSQLHelpe

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        self.queue = [FMDatabaseQueue databaseQueueWithPath:[self createDB]];
        
    }
    
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return instance;
}

+ (DBSQLHelpe *)sharedDBSQLHelpe{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DBSQLHelpe alloc]init];
//        [instance createDB];
    });
    
    return instance;
}

- (NSString *)createDB{
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

    NSArray *arr = [bundleID componentsSeparatedByString:@"."];

    NSString *DBName = [NSString stringWithFormat:@"%@.db",arr.lastObject];

//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject];
//    NSString *filePath = [doc stringByAppendingPathComponent:DBName];
//
    NSString *path = @"/Users/zhangxiaoye/Desktop/";

    NSString *filePath = [path stringByAppendingString:DBName];
    
    NSLog(@"%@",filePath);
    //创建数据库
    self.db = [FMDatabase databaseWithPath:filePath];
    
    return filePath;
}

- (void)createTable:(NSString *)table FieldArr:(NSArray *)fieldArr{
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       
        
        NSString *fieldStr = [fieldArr componentsJoinedByString:@" text NOT NULL,"];
        
        NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (TabelId integer PRIMARY KEY AUTOINCREMENT, %@ text NOT NULL);",table,fieldStr];
        
        BOOL result = [db executeUpdate:sqlStr];
        
        if (result) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
        [db closeOpenResultSets];
    }];
    
}

//批量插入操作
- (void)insertTable:(NSString *)table ContactDic:(NSDictionary *)contactDic ContactArr:(NSArray *)contactArr{
    
    if (contactDic != nil) {
        
        [self insertTable:table Contact:contactDic];
        
    }else{
        
        [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
            
            for (NSDictionary *dic in contactArr) {
                
                NSArray *sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                    return[obj1 compare:obj2 options:NSNumericSearch];//正序
                }];
                
                NSString *fieldNameStr = [sortedArray componentsJoinedByString:@","];
                
                NSMutableArray *orderValueArray = [[NSMutableArray alloc]init];
                
                NSString *orderStr = @"";
                //根据key的顺序提取相应value
                for (NSString *key in sortedArray) {
                    
                    [orderValueArray addObject:[dic objectForKey:key]];
                    
                    orderStr = [orderStr stringByAppendingString:@"?,"];
                    
                }
                orderStr = [orderStr substringToIndex:[orderStr length] - 1];
                
                NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",table,fieldNameStr,orderStr];
                
                BOOL result = [db executeUpdate:sqlStr withArgumentsInArray:orderValueArray];
                
                if (result) {
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
            }
            
        }];
    }
}

//插入操作
-(void)insertTable:(NSString *)table Contact:(NSDictionary *)contactDic
{

    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSArray *sortedArray = [[contactDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
            return[obj1 compare:obj2 options:NSNumericSearch];//正序
        }];
        
        NSString *fieldNameStr = [sortedArray componentsJoinedByString:@","];
        
        NSMutableArray *orderValueArray = [[NSMutableArray alloc]init];
        
        NSString *orderStr = @"";
        //根据key的顺序提取相应value
        for (NSString *key in sortedArray) {
            
            [orderValueArray addObject:[contactDic objectForKey:key]];
            
            orderStr = [orderStr stringByAppendingString:@"?,"];
            
        }
        orderStr = [orderStr substringToIndex:[orderStr length] - 1];
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",table,fieldNameStr,orderStr];
        
        BOOL result = [db executeUpdate:sqlStr withArgumentsInArray:orderValueArray];

        if (result) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
        
        [db closeOpenResultSets];
    }];

}

- (BOOL)isHistoryField:(NSString *)field Value:(NSString *)message inTable:(NSString *)table{
    
    static BOOL boo = false;

    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
        
        FMResultSet *rs = [db executeQuery:sqlstr];
        
        while ([rs next]) {
            NSString *str1 = [rs stringForColumn:field];
            
            if ([str1 isEqualToString:message]) {
                boo = YES;
                break;
            }else{
                
                boo = NO;
            }
        }
        
        if ([rs columnCount] == 0) {
            boo = NO;
        }
        
        [db closeOpenResultSets];

    }];

    return boo;
}
//  批量更新数据

- (BOOL)updateDataTabele:(NSString *)table Field:(NSString *)field ContactArr:(NSArray *)contactArr{
    
    static BOOL boo = false;

    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        for (NSDictionary *dic in contactArr) {
            
            NSArray *sortedArray = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                return[obj1 compare:obj2 options:NSNumericSearch];//正序
            }];
            
            NSString *fieldNameStr = [sortedArray componentsJoinedByString:@" = ?, "];
            
            fieldNameStr = [fieldNameStr stringByAppendingString:@" = ?"];
            
            NSMutableArray *orderValueArray = [[NSMutableArray alloc]init];
            
            for (NSString *key in sortedArray) {
                
                [orderValueArray addObject:[dic objectForKey:key]];
                
            }
            if ([[dic allKeys] containsObject:field]) {
                
                [orderValueArray addObject:dic[field]];

            }

            NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?",table,fieldNameStr,field];

            BOOL result = [db executeUpdate:sqlStr withArgumentsInArray:orderValueArray];

            if (result) {
                
                boo = true;
                
                NSLog(@"更新成功");

            }else{
                
                boo = false;
                
                NSLog(@"更新失败");
            }
            
            
        }
        
    }];

    
    return boo;
}

//  更新数据
- (BOOL)updateDataTabele:(NSString *)table Field:(NSString *)field Value:(nonnull NSString *)message Contact:(nonnull NSDictionary *)contactDic{
    
    static BOOL boo = false;

    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       
        NSArray *sortedArray = [[contactDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
            return[obj1 compare:obj2 options:NSNumericSearch];//正序
        }];
        
        NSString *fieldNameStr = [sortedArray componentsJoinedByString:@" = ?, "];
        
        fieldNameStr = [fieldNameStr stringByAppendingString:@" = ?"];
        
        NSMutableArray *orderValueArray = [[NSMutableArray alloc]init];
        
        for (NSString *key in sortedArray) {
            
            [orderValueArray addObject:[contactDic objectForKey:key]];
            
        }
        [orderValueArray addObject:message];
        
        NSString *sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?",table,fieldNameStr,field];

        BOOL result = [db executeUpdate:sqlStr withArgumentsInArray:orderValueArray];
        
        if (result) {
            boo = true;
            NSLog(@"更新成功");
            
        }else{
            
            boo = false;
            NSLog(@"更新失败");
        }
        
        [db closeOpenResultSets];
    }];
    
    
    return boo;
}

- (NSMutableArray *)queryTabele:(NSString *)table Field:(NSString *)field Value:(NSString *)message{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];

    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       
        FMResultSet *rs;
        
        if (field != nil && message != nil) {
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",table,field];
            
            rs = [db executeQuery:sqlStr,message];
            
        }else{
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
            
            rs = [db executeQuery:sqlStr];
            
        }
        
        while ([rs next]){
            
            [array addObject:[rs resultDictionary]];
            
        }
        [db closeOpenResultSets];
    }];
    
    return array;
}

- (NSMutableArray *)fuzzyQueryTabele:(NSString *)table Field:(NSString *)field Value:(NSString *)message{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       
        FMResultSet *rs;
        
        if (field != nil && message != nil) {
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ like '%%%@%%'",table,field,message];
            
            rs = [db executeQuery:sqlStr];
            
        }else{
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
            
            rs = [db executeQuery:sqlStr];
            
        }
    
        
        while ([rs next]){
            
            [array addObject:[rs resultDictionary]];
            
        }
    
        [db closeOpenResultSets];

    }];
    
    return array;
}

- (NSMutableArray *)Multiple_ConditionsFuzzyQueryTabele:(NSString *)table FieldStr:(NSString * _Nullable)fieldStr{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];

    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *rs;
        
        if (fieldStr != nil) {
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",table,fieldStr];
            
            rs = [db executeQuery:sqlStr];
            
        }else{
            
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",table];
            
            rs = [db executeQuery:sqlStr];
            
        }
        
        
        while ([rs next]){
            
            [array addObject:[rs resultDictionary]];
            
        }
        
        [db closeOpenResultSets];
        
    }];
    
    return array;
    
}

- (BOOL)DeletTabele:(NSString *)table Field:(NSString *)field Value:(NSString *)message{
    
    BOOL boo = false;

    if ([self.db open]) {
        
        BOOL result;
        
        if (field != nil && message != nil) {
            
            NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",table,field];

            result = [self.db executeUpdate:sqlStr,message];

        }else{
            
            NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",table];
            result = [self.db executeUpdate:sqlStr];

        }
        
        if (result) {
            
            NSLog(@"删除成功");
            boo = YES;
            
        }else{
            
            NSLog(@"删除成功");
            boo = false;
        }
        
        [self.db close];
        
    }else{
        NSLog(@"数据库打开失败");
    }
    
    return boo;
}

- (BOOL)isColumnExists:(NSString *)table Field:(NSString *)field{
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
       
        if (![db columnExists:field inTableWithName:table]){

            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",table,field];
            
            BOOL worked = [db executeUpdate:alertStr];
            
            if(worked){
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
            
            return;
     
        }else{
        
            return;
        }

    }];
    
    return YES;
}

- (BOOL)isColumnExists:(NSString *)table FieldArr:(NSArray *)fieldArr{
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        for (NSString *field in fieldArr) {
            
            if (![db columnExists:field inTableWithName:table]){
                
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ TEXT",table,field];
                
                BOOL worked = [db executeUpdate:alertStr];
                
                if(worked){
                    NSLog(@"插入成功");
                }else{
                    NSLog(@"插入失败");
                }
                
                continue;
                
            }else{
                
                continue;
            }
        }
        
    }];
    
    return YES;
}

- (BOOL)isTableExist:(NSString *)table{
    
    BOOL boo = false;

    if ([self.db open]) {
       NSString *existsSql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'",table ];
       FMResultSet *rs = [self.db executeQuery:existsSql];
       if ([rs next]) {
           NSInteger count = [rs intForColumn:@"countNum"];
           if (count == 1) {
               NSLog(@"存在");
               boo = YES;
           }else{
               boo = NO;
           }
       }
       
       [self.db close];

    }else{
       
       NSLog(@"数据库打开失败");
        
    }
    
    return boo;
}

- (void)dealloc {
    
    NSLog(@"%@:----释放了",NSStringFromSelector(_cmd));
}

@end
