//
//  ViewController.m
//  DBSQLDemo
//
//  Created by zhangxiaoye on 2019/7/13.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import "ViewController.h"
#import "DBSQL/DBSQLHelpe.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// 创建表,传入表名,和字段名
//    [[DBSQLHelpe sharedDBSQLHelpe] createTable:@"t_user" FieldArr:@[@"user_id,name,sex,age,tel"]];
//
//    // 插入数据
//    [[DBSQLHelpe sharedDBSQLHelpe] insertTable:@"t_user" Contact:@{@"user_id":@"1",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"}];
//
//    // 批量插入数据
//    [[DBSQLHelpe sharedDBSQLHelpe] insertTable:@"t_user" ContactDic:nil ContactArr:@[@{@"user_id":@"2",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
//                    @{@"user_id":@"3",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
//                    @{@"user_id":@"4",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
//                    @{@"user_id":@"5",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"}]];
    
    
//    // 查询记录
//
//    NSArray *arr = [[DBSQLHelpe sharedDBSQLHelpe] queryTabele:@"t_user" Field:@"name" Value:@"zhangsan"];
//
//    NSLog(@"%@",arr);
    
    // 单条件模糊搜索
    
//    NSArray *arr1 = [[DBSQLHelpe sharedDBSQLHelpe] fuzzyQueryTabele:@"t_user" Field:@"name" Value:@"zhangsan"];
//    NSLog(@"%@",arr1);
//
//    // 多条件模糊搜索
//    NSArray *arr2 = [[DBSQLHelpe sharedDBSQLHelpe] Multiple_ConditionsFuzzyQueryTabele:@"t_user" FieldStr:@"user_id = '3' and name like '%zhangsan%'"];
//    NSLog(@"%@",arr2);
//
//
//    //  删除历史记录
//    [[DBSQLHelpe sharedDBSQLHelpe] DeletTabele:@"t_user" Field:@"user_id" Value:@"2"];
    
    //   是否有重复的数据
    
//    BOOL  isExist= [[DBSQLHelpe sharedDBSQLHelpe] isHistoryField:@"user_id" Value:@"3" inTable:@"t_user"];
//
//    NSLog(@"%d",isExist);
//
    
    //   更新数据
//    [[DBSQLHelpe sharedDBSQLHelpe] updateDataTabele:@"t_user" Field:@"user_id" Value:@"5" Contact:@{@"name":@"wangmanzi"}];
    
    // 批量更新数据
//    BOOL Result = [[DBSQLHelpe sharedDBSQLHelpe] updateDataTabele:@"t_user" Field:@"user_id" ContactArr:@[@{@"name":@"wdd",@"user_id":@"1"},
//                                                                                                         @{@"name":@"eed",@"user_id":@"3"},
//                                                                                                         @{@"name":@"vfrg",@"user_id":@"4"}
//                                                                                                        ]];
//    NSLog(@"%d",Result);

    
    [[DBSQLHelpe sharedDBSQLHelpe] isColumnExists:@"t_user" Field:@"text"];
    
    
    [[DBSQLHelpe sharedDBSQLHelpe] isColumnExists:@"t_user" FieldArr:@[@"textq",@"textq3",@"textq2"]];
}

@end
