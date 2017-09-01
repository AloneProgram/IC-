//
//  xqTableViewController.m
//  IC数据管理
//
//  Created by iKnet on 16/11/23.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import "xqTableViewController.h"
#import "AddViewController.h"
#import "DataBase.h"

@interface xqTableViewController ()<UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *xqNameArray;
@property (nonatomic, strong) NSMutableArray *xqDetailArray;
@property (nonatomic, strong) NSDictionary *tempDic;

@property (strong, nonatomic) NSMutableArray *searchList; // 保存搜索数据
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation xqTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tempDic = [DataBase displayXQ:self.gnStr and:self.gsStr];
    
    self.xqNameArray= self.tempDic[@"xqName"];
    self.xqDetailArray = self.tempDic[@"xqDetail"];
    if (!self.xqDetailArray) {
        self.xqDetailArray = [NSMutableArray array];
    }
    if (!self.xqNameArray) {
        self.xqNameArray = [NSMutableArray array];
    }
    if (!self.totalArray) {
        self.totalArray = [NSMutableArray array];
    }
    
    for (int i = 0; i<self.xqNameArray.count; i++) {
        NSString *str1 = self.xqNameArray[i];
        NSString *str2 = self.xqDetailArray[i];
        NSString *str = [NSString stringWithFormat:@"%@:%@",str1,str2];
        [self.totalArray addObject:str];
    }
    
    self.title = @"详情";
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addDetail)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //初始化UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    //设置refreshControl的属性
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新..." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    refreshControl.tintColor = [UIColor lightGrayColor];
    //把refreshcontrol添加到自身。这样就可以实现下拉刷新了
    [self setRefreshControl:refreshControl];

}

- (UISearchController *)searchController {
    if (_searchController == nil) {
        // 传入 nil 默认在原视图展示
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        // 成为代理
        _searchController.searchResultsUpdater = self;
        // 搜索时是否出现遮罩
        _searchController.dimsBackgroundDuringPresentation = NO;
        // 搜索栏的
        _searchController.searchBar.placeholder = @"请输入搜索内容";
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _searchController;
}
- (void)refresh:(id)sender
{
    NSLog(@"正在刷新");
    self.tempDic = [DataBase displayXQ:self.gnStr and:self.gsStr];
    self.xqNameArray= self.tempDic[@"xqName"];
    self.xqDetailArray = self.tempDic[@"xqDetail"];
    if (!self.xqDetailArray) {
        self.xqDetailArray = [NSMutableArray array];
    }
    if (!self.xqNameArray) {
        self.xqNameArray = [NSMutableArray array];
    }
    if (!self.totalArray) {
        self.totalArray = [NSMutableArray array];
    }
    [self.totalArray removeAllObjects];
    for (int i = 0; i<self.xqNameArray.count; i++) {
        NSString *str1 = self.xqNameArray[i];
        NSString *str2 = self.xqDetailArray[i];
        NSString *str = [NSString stringWithFormat:@"%@:%@",str1,str2];
        [self.totalArray addObject:str];
    }
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
    
}

- (void)addDetail
{
    AddViewController *addVC = [[AddViewController alloc] init];
    addVC.index = 3;
    addVC.gnStr = self.gnStr;
    addVC.gsStr = self.gsStr;
    [self.navigationController pushViewController:addVC animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    /*
     self.searchController.active active 属性用于判断 searchBar 是否处于活动状态
     */
    if (self.searchController.active) {
        // 返回搜索后的数组
        return [self.searchList count];
    } else {
        return self.totalArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XQTableCell"];

    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XQTableCell"];
    }
    if (self.searchController.active) {
        cell.textLabel.text = self.searchList[indexPath.row];
    } else {
        cell.textLabel.text = self.totalArray[indexPath.row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
        
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
    [DataBase deleteXQTable:self.xqNameArray[indexPath.row] xqDetail:self.xqDetailArray[indexPath.row] company:self.gsStr gn:self.gnStr];
    // 从列表中删除
    [self.totalArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 获取搜索框文本
    NSString *searchString = [self.searchController.searchBar text];
    // 判断数组中是否包含 searchString
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchString];
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    // 获取搜索后的数组
    self.searchList = [NSMutableArray arrayWithArray:[self.totalArray filteredArrayUsingPredicate:preicate]];
    // 刷新表格
    [self.tableView reloadData];
}
@end
