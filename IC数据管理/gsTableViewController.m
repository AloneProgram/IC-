//
//  gsTableViewController.m
//  IC数据管理
//
//  Created by iKnet on 16/11/23.
//  Copyright © 2016年 zzj. All rights reserved.
//

#import "gsTableViewController.h"
#import "gnTableViewController.h"
#import "AddViewController.h"

#import "DataBase.h"

@interface gsTableViewController ()<UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *companyArray;
//@property (nonatomic, strong) NSArray *array;
@property(strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchArray;

@end

@implementation gsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyArray = [DataBase displayCompany];
    if (!self.companyArray) {
        self.companyArray = [NSMutableArray array];
    }
    
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

    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  target:self action:@selector(addCompany)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
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
    self.companyArray = [DataBase displayCompany];
    if (!self.companyArray) {
        self.companyArray = [NSMutableArray array];
    }
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)addCompany
{
    AddViewController *addVC = [[AddViewController alloc] init];
    addVC.index = 1;
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
        return self.searchArray.count;
    } else {
         return self.companyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSTableCell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GSTableCell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GSTableCell"];
    }
    
    if (self.searchController.active) {
        // 返回搜索后的数组
        cell.textLabel.text = self.searchArray[indexPath.row];
    } else {
        cell.textLabel.text = self.companyArray[indexPath.row];
    }
  //  cell.textLabel.text = self.companyArray[indexPath.row];
    
    
    return cell;
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
    self.searchArray = [NSMutableArray arrayWithArray:[self.companyArray filteredArrayUsingPredicate:preicate]];
    // 刷新表格
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *tempArray = [self.dic objectForKey:self.companyArray[indexPath.row]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    gnTableViewController *gnTableVC = [[gnTableViewController alloc] init];
    //[self.storyboard instantiateViewControllerWithIdentifier:@"GNTableVC"];
   // gnTableVC.xqDic = tempArray;
    gnTableVC.textStr = cell.textLabel.text;

    
    [self.navigationController pushViewController:gnTableVC animated:YES];
    
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
    [DataBase deleteGSTable:self.companyArray[indexPath.row]];
    // 从列表中删除
    [self.companyArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
