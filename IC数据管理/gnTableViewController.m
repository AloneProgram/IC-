//
//  gnTableViewController.m
//  IC数据管理
//
//  Created by iKnet on 16/11/23.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import "gnTableViewController.h"
#import "xqTableViewController.h"
#import "AddViewController.h"
#import "DataBase.h"

@interface gnTableViewController ()<UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *bgnArray;

@property(strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation gnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bgnArray = [DataBase displayGN:self.textStr];
    
    self.tableView.tableFooterView = [UIView new];
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addGengneng)];
    
    self.navigationItem.rightBarButtonItem = rightButton;

    self.title = @"功能分类";
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [UIView new];
    
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
    self.bgnArray = [DataBase displayGN:self.textStr];
    if (!self.bgnArray) {
        self.bgnArray = [NSMutableArray array];
    }
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

- (void)addGengneng
{
    AddViewController *addVC = [[AddViewController alloc] init];
    addVC.index = 2;
    addVC.gsStr = self.textStr;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     self.searchController.active active 属性用于判断 searchBar 是否处于活动状态
     */
    if (self.searchController.active) {
        // 返回搜索后的数组
        return [self.searchArray count];
    } else {
        return self.bgnArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GNTableCell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GNTableCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GNTableCell"];
    }
    if (self.searchController.active) {
        // 返回搜索后的数组
        cell.textLabel.text = self.searchArray[indexPath.row];
    } else {
        cell.textLabel.text = self.bgnArray[indexPath.row];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSDictionary *dic = [self.xqDic objectForKey:self.bgnArray[indexPath.row]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    xqTableViewController *xqTableVC = [[xqTableViewController alloc] init];
    xqTableVC.gnStr = cell.textLabel.text;
    xqTableVC.gsStr = self.textStr;

    [self.navigationController pushViewController:xqTableVC animated:YES];
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
    [DataBase deleteGNTable:self.bgnArray[indexPath.row] andCompany:self.textStr];
    // 从列表中删除
    [self.bgnArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // 获取搜索框文本
    NSString *searchString = [self.searchController.searchBar text];
    // 判断数组中是否包含 searchString
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchString];
    if (self.searchArray != nil) {
        [self.searchArray removeAllObjects];
    }
    // 获取搜索后的数组
    self.searchArray = [NSMutableArray arrayWithArray:[self.bgnArray filteredArrayUsingPredicate:preicate]];
    // 刷新表格
    [self.tableView reloadData];
}

@end
