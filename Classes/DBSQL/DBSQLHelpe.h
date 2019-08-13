//
//  DBSQLHelpe.h
//  WuxiAgriculture
//
//  Created by zhangxiaoye on 2019/2/21.
//  Copyright © 2019年 zhangxiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <fmdb/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBSQLHelpe : NSObject

@property (strong, nonatomic) FMDatabase *db;

//创建数据库
+ (DBSQLHelpe *)sharedDBSQLHelpe;
//- (NSString *)createDB;

/**
 创建数据表

 @param table 表名
 @param fieldArr 字段名
 */
- (void)createTable:(NSString *)table FieldArr:(NSArray *)fieldArr;

/**
添加数据

 @param table 表名
 @param contactDic 数据字典
 */
-(void)insertTable:(NSString *)table Contact:(NSDictionary *)contactDic;

/**
 批量添加数据
 
 @param table 表名
 @param contactDic 数据字典  -- 可为空 contactDic
 @param contactArr 批量添加数据字典的数组 ----  可为空
 */
-(void)insertTable:(NSString *)table ContactDic:(NSDictionary *__nullable)contactDic ContactArr:(NSArray *__nullable)contactArr;

/**
 查询记录
 field 和 message 可为空,  只有其中一个为空,则查询所有
 @param table 表名
 @param field 字段名 -- 可为空
 @param message 字段内容 -- 可为空
 @return 返回数组
 */
-(NSMutableArray *)queryTabele:(NSString *)table Field:(NSString * __nullable)field Value:(NSString * __nullable)message;

/**
 单条件模糊搜索记录
 @param table 表名
 @param field 字段名 -- 可为空
 @param message 字段内容 -- 不可为空
 @return 返回数组

 */
-(NSMutableArray *)fuzzyQueryTabele:(NSString *)table Field:(NSString * __nullable)field Value:(NSString * __nullable)message;


/**
  多条件模糊搜索记录

 @param table  表名
 @param fieldStr 条件内容(SQl语句条件)
 @return 返回数组
 */
- (NSMutableArray *)Multiple_ConditionsFuzzyQueryTabele:(NSString *)table FieldStr:(NSString * _Nullable)fieldStr;

/**
 删除历史记录
 
 field 和 message 可为空,  只有其中一个为空,则删除所有
 @param table 表名
 @param field 字段名 -- 可为空
 @param message 字段内容 -- 可为空
 @return 是否成功
 */
-(BOOL)DeletTabele:(NSString *)table Field:(NSString * __nullable)field Value:(NSString * __nullable)message;

/**
 更新数据

 @param table 表名
 @param field 字段名(条件成立)
 @param message 字段内容(条件成立)
 @param contactDic 需要更新的数据字典
 @return 是否成功
 */
-(BOOL)updateDataTabele:(NSString *)table Field:(NSString *)field Value:(NSString *)message Contact:(NSDictionary *)contactDic;

/**
  批量更新数据

 @param table 表名
 @param field 字段名(条件成立,单条件)
 @param contactArr 批量添加数据字典的数组 (其中要包含 field(条件成立)字段名和对应内容)
 @return 是否成功
 */
-(BOOL)updateDataTabele:(NSString *)table Field:(NSString *)field ContactArr:(NSArray *__nullable)contactArr;

/**
 是否有重复的数据

 @param field 表名
 @param message 字段名
 @param table 字段内容
 @return 是否成功
 */
- (BOOL)isHistoryField:(NSString *)field Value:(NSString *)message inTable:(NSString *)table;

/**
 插入数据表字段

 @param table 表名
 @param field 新增字段
 @return 是否存在
 */
- (BOOL)isColumnExists:(NSString *)table Field:(NSString * __nullable)field;

/**
 插入数据表字段

 @param table 表名
 @param fieldArr 新增字段数组
 @return 是否成功
 */
- (BOOL)isColumnExists:(NSString *)table FieldArr:(NSArray *)fieldArr;


/**
 数据表是否存在

 @param table 表名
 @return 是否存在
 */
- (BOOL)isTableExist:(NSString *)table;

@end

NS_ASSUME_NONNULL_END
