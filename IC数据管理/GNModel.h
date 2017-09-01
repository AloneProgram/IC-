//
//  GNModel.h
//  IC数据管理
//
//  Created by iKnet on 16/11/29.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XQModel.h"

@interface GNModel : NSObject

@property (nonatomic, strong) NSString *gnName;
@property (nonatomic, strong) XQModel *xqModel;

@end
