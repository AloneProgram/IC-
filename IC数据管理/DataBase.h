//
//  DataBase.h
//
//
//  Created by zzj on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject

/**
 *  添加数据到数据库
 */
+ (void)addCompany:(NSString *)companyName;
+ (void)addGN:(NSString *)gnName withCompany:(NSString *)companyName;
+ (void)addXQName:(NSString *)xqName andXQDetail:(NSString *)xqDetail withCompany:(NSString *)companyName andGN:(NSString *)gnName;


/**
 *  调用数据库数据
 *
 *  @return 返回一个字典  字典内包装的是数据model
 */
+ (NSMutableArray *)displayCompany;
+ (NSMutableArray *)displayGN:(NSString *)companyName;
+ (NSDictionary *)displayXQ:(NSString *)gnName and:(NSString *)companyName;


/**
 *  删除单条数据
 */
+ (void)deleteGSTable:(NSString *)companyName;
+ (void)deleteGNTable:(NSString *)gnName andCompany:(NSString *)companyName;
+ (void)deleteXQTable:(NSString *)xqName xqDetail:(NSString *)xqDetail company:(NSString *)companyName gn:(NSString *)gnName;


@end
