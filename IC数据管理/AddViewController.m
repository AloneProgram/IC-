//
//  AddViewController.m
//  IC数据管理
//
//  Created by iKnet on 16/11/23.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import "AddViewController.h"

#import "DataBase.h"

@interface AddViewController ()

@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UIButton *saveBtn;;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.index == 1) {  //添加公司
        self.title = @"添加公司";
    }else if (self.index == 2) {  //添加功能
        self.title = @"添加功能";
    }else if (self.index == 3) { //添加详情
        self.title = @"添加详情";
    }
    
    [self setUpView];
}


- (void)setUpView
{
    CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    
    self.textField1 = [[UITextField alloc] initWithFrame:CGRectMake(40, 100, 350, 50)];
    self.textField1.backgroundColor = [UIColor lightGrayColor];
    NSString *str = @"";
    if (self.index == 1) {
        str = @"公司名";
    }else if (self.index == 2){
        str = @"功能名";
    }else if (self.index == 3){
        str = @"详情名:库存/联系方式...";
    }
    self.textField1.placeholder = str;
    [self.view addSubview:self.textField1];
    
    self.textField2 = [[UITextField alloc] initWithFrame:CGRectMake(40, 200, 350, 50)];
    self.textField2.backgroundColor = [UIColor lightGrayColor];
    self.textField2.placeholder = @"详情:库存量/电话号码...(详情后可添加备注)";
    [self.view addSubview:self.textField2];
    if (self.index == 3) {
        self.textField2.hidden = NO;
    }else {
        self.textField2 .hidden = YES;
    }
    
    self.saveBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(20, 300, wid - 80, 50);
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setBackgroundColor:[UIColor greenColor]];
    [self.saveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.saveBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
}

- (void)add
{
    if (self.index == 1) {  //添加公司
        if (self.textField1.text.length > 0) {
            [DataBase addCompany:self.textField1.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存时输入内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else if (self.index == 2) {  //添加功能
        if (self.textField1.text.length > 0) {
            [DataBase addGN:self.textField1.text withCompany:self.gsStr];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存时输入内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if (self.index == 3) { //添加详情
        if (self.textField1.text.length > 0 && self.textField2.text.length > 0) {
            [DataBase addXQName:self.textField1.text andXQDetail:self.textField2.text withCompany:self.gsStr andGN:self.gnStr];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存时输入内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}


@end
