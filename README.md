# DBSQL
## FMDB数据库二次封装操作
# 使用DBSQL


# 第一步：使用CocoaPods导入DBSQL

CocoaPods 导入

  在文件 Podfile 中加入以下内容：

    pod 'DBSQL'
  然后在终端中运行以下命令：

    pod install
  或者这个命令：
```
  禁止升级 CocoaPods 的 spec 仓库，否则会卡在 Analyzing dependencies，非常慢
    pod install --verbose --no-repo-update
  或者
    pod update --verbose --no-repo-update
```
  完成后，CocoaPods 会在您的工程根目录下生成一个 .xcworkspace 文件。您需要通过此文件打开您的工程，而不是之前的 .xcodeproj。

# 第二步：创建本地数据库和表(本地数据库名称和bundleID挂钩)

### 其中 数据库内部自行创建,只需创建数据库表

```

// 创建表,传入表名,和字段名
    [[DBSQLHelpe sharedDBSQLHelpe] createTable:@"t_user" FieldArr:@[@"user_id,name,sex,age,tel"]];

    // 插入数据
    [[DBSQLHelpe sharedDBSQLHelpe] insertTable:@"t_user" Contact:@{@"user_id":@"1",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"}];

    // 批量插入数据
    [[DBSQLHelpe sharedDBSQLHelpe] insertTable:@"t_user" ContactDic:nil ContactArr:@[@{@"user_id":@"2",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
                    @{@"user_id":@"3",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
                    @{@"user_id":@"4",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"},
                    @{@"user_id":@"5",@"name":@"zhangsan",@"sex":@"0",@"age":@"23",@"tel":@"12343212343"}]];
    
    
    // 查询记录

    NSArray *arr = [[DBSQLHelpe sharedDBSQLHelpe] queryTabele:@"t_user" Field:@"name" Value:@"zhangsan"];

    NSLog(@"%@",arr);
    
//     单条件模糊搜索
    
    NSArray *arr1 = [[DBSQLHelpe sharedDBSQLHelpe] fuzzyQueryTabele:@"t_user" Field:@"name" Value:@"zhangsan"];
    NSLog(@"%@",arr1);

    // 多条件模糊搜索
    NSArray *arr2 = [[DBSQLHelpe sharedDBSQLHelpe] Multiple_ConditionsFuzzyQueryTabele:@"t_user" FieldStr:@"user_id = '3' and name like '%zhangsan%'"];
    NSLog(@"%@",arr2);


    //  删除历史记录
    [[DBSQLHelpe sharedDBSQLHelpe] DeletTabele:@"t_user" Field:@"user_id" Value:@"2"];
    
//       是否有重复的数据
    
    BOOL  isExist= [[DBSQLHelpe sharedDBSQLHelpe] isHistoryField:@"user_id" Value:@"3" inTable:@"t_user"];

    NSLog(@"%d",isExist);

    
//       更新数据
    [[DBSQLHelpe sharedDBSQLHelpe] updateDataTabele:@"t_user" Field:@"user_id" Value:@"5" Contact:@{@"name":@"wangmanzi"}];
    
//     批量更新数据
    BOOL Result = [[DBSQLHelpe sharedDBSQLHelpe] updateDataTabele:@"t_user" Field:@"user_id" ContactArr:@[@{@"name":@"wdd",@"user_id":@"1"},
                                                                                                         @{@"name":@"eed",@"user_id":@"3"},
                                                                                                         @{@"name":@"vfrg",@"user_id":@"4"}
                                                                                                        ]];
    NSLog(@"%d",Result);

    
    // 添加数据库字段
    [[DBSQLHelpe sharedDBSQLHelpe] isColumnExists:@"t_user" Field:@"text"];
    
    // 批量添加数据库字段
    [[DBSQLHelpe sharedDBSQLHelpe] isColumnExists:@"t_user" FieldArr:@[@"textq",@"textq3",@"textq2"]];
        
```
