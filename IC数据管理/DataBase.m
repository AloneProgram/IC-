//
//  DataBase.m
//
//
//  Created by zzj on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DataBase.h"
#import "FMDB.h"


//数据model
#import "CompanyModel.h"
#import "GNModel.h"
#import "XQModel.h"

@implementation DataBase

static FMDatabaseQueue *_queue;


#pragma mark - 初始化，创建表
+(void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"DataBase.sqlite"];
    
    //创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    //创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_company (id integer primary key autoincrement, companyName text);"];
    }];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_goneng (id integer primary key autoincrement, gnName text, companyName text);"];
    }];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_xiangqing (id integer primary key autoincrement,xqDetail text, xqName text, gnName text, companyName text);"];
    }];
}

#pragma mark 显示数据
//显示t_company表数据
+ (NSMutableArray *)displayCompany
{
    
    __block NSMutableArray *arr = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        arr = [NSMutableArray array];

        // 1.查询数据
        FMResultSet *rsgs = [db executeQuery:@"select * from t_company"];
        
        // 2.遍历结果集
        
        while (rsgs.next) {
            NSString *companyName = [rsgs stringForColumn:@"companyName"];
            [arr addObject:companyName];
        }
    }];
    
    return arr;
}

+ (NSMutableArray *)displayGN:(NSString *)companyName
{
    __block NSMutableArray *arr = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        arr = [NSMutableArray array];
        
        
        // 1.查询数据
         FMResultSet *rsgn = [db executeQuery:@"select * from t_goneng where companyName = ?;",companyName];
        
        // 2.遍历结果集
        while (rsgn.next) {
            NSString *gnName = [rsgn stringForColumn:@"gnName"];
            
            [arr addObject:gnName];
        }
    }];
    
    return arr;
}

+ (NSDictionary *)displayXQ:(NSString *)gnName and:(NSString *)companyName
{
    __block NSDictionary *dic = nil;
    __block NSMutableArray *arrName = nil;
    __block NSMutableArray *arrDetail = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        
        dic = [NSDictionary dictionary];
        arrName = [NSMutableArray array];
        arrDetail = [NSMutableArray array];
        
        
        // 1.查询数据
       FMResultSet *rsxq = [db executeQuery:@"select * from t_xiangqing where gnName = ? and  companyName = ?;",gnName,companyName];
        
        // 2.遍历结果集
        while (rsxq.next) {
            NSString *strName = [rsxq stringForColumn:@"xqName"];
            NSString *strDetail = [rsxq stringForColumn:@"xqDetail"];
            
            [arrName addObject:strName];
            [arrDetail addObject:strDetail];
        }
        
        dic = @{@"xqName":arrName,
                @"xqDetail":arrDetail};
    }];
    
    return dic;
}


#pragma mark 增数据
//存公司名
+ (void)addCompany:(NSString *)companyName
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 2.存储数据
        [db executeUpdate:@"insert into t_company (companyName) values(?)",companyName];
        
    }];
}

//存功能名
+ (void)addGN:(NSString *)gnName withCompany:(NSString *)companyName
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 2.存储数据
        [db executeUpdate:@"insert into t_goneng (gnName,companyName) values(?,?)",gnName,companyName];
    }];
}
//存详情
+(void)addXQName:(NSString *)xqName andXQDetail:(NSString *)xqDetail withCompany:(NSString *)companyName andGN:(NSString *)gnName
{
    [_queue inDatabase:^(FMDatabase *db) {
        // 2.存储数据
        [db executeUpdate:@"insert into t_xiangqing (xqDetail,xqName,gnName,companyName) values(?,?,?,?)", xqDetail,xqName,gnName,companyName];
    }];
}

#pragma mark - 删除单条数据
//删除t_company表单条数据,及t_goneng、t_xiangqing表中该公司数据,防止下次添加公司名重名后 ,功能表和详情表数据可以查询出来
+ (void)deleteGSTable:(NSString *)companyName
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_company where companyName = ?;",companyName];
        [db executeUpdate:@"delete from t_goneng where companyName = ?;",companyName];
        [db executeUpdate:@"delete from t_xiangqing where companyName = ?;",companyName];
    }];
}
//删除t_goneng表单条数据,及t_xiangqing表中该功能数据
+ (void)deleteGNTable:(NSString *)gnName andCompany:(NSString *)companyName
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_goneng where gnName = ? and companyName = ?;",gnName,companyName];
        [db executeUpdate:@"delete from t_xiangqing where gnName = ?;",gnName];
    }];
}
//删除t_xiangqing表单条数据
+ (void)deleteXQTable:(NSString *)xqName xqDetail:(NSString *)xqDetail company:(NSString *)companyName gn:(NSString *)gnName
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from t_xiangqing where xqName = ? and xqDetail = ? and companyName = ? and gnName = ?;",xqName,xqDetail,companyName,gnName];
    }];
}

#pragma mark -修改数据


@end
