//
//  CompanyModel.h
//  IC数据管理
//
//  Created by iKnet on 16/11/29.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GNModel.h"

@interface CompanyModel : NSObject

@property (nonatomic, strong) NSString *gsName;
@property (nonatomic, strong) GNModel *gnModel;

@end
