//
//  LJCChatSearchController.m
//  LJCDBStore
//
//  Created by 林锦超 on 29/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatSearchViewController.h"
#import "LJCChatFTSStore.h"

@interface LJCChatSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSArray<LJCChatFTSModel *> *datas;
@end

@implementation LJCChatSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"ChatFTS";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableHeaderView = self.searchController.searchBar;
    }
    return _tableView;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.barTintColor = [UIColor lightGrayColor];
        _searchController.searchBar.placeholder = @"请输入关键字搜索";
        
//        _searchController.dimsBackgroundDuringPresentation = NO;        /// 搜索时，背景变暗色
//        _searchController.obscuresBackgroundDuringPresentation = NO;    /// 搜索时，背景变模糊
//        _searchController.hidesNavigationBarDuringPresentation = NO;    /// 点击搜索的时候,是否隐藏导航栏
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatFTSModel *chat = self.datas[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = chat.content;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UISearchResultsUpdating
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *match = searchController.searchBar.text;
    NSLog(@"updateSearchResultsForSearchController:%@", match);
    
    self.datas = [LJCChatFTSStore chatMessagesMatch:match];
    [self.tableView reloadData];
}
@end
