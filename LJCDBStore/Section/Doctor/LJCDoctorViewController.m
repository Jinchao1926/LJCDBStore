//
//  LJCDoctorViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 27/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorViewController.h"
#import "LJCDoctorModel.h"
#import "LJCDoctorRequestManager.h"
#import "LJCDoctorCell.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LJCDoctorViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<LJCDoctorModel *> *datas;
@property (nonatomic, strong) LJCDoctorRequestManager *requestManager;
//@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, NSNumber *> *heightAtIndexPath;
@end

@implementation LJCDoctorViewController

- (void)dealloc
{
    NSLog(@"dealloc LJCDoctorViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _datas = [NSMutableArray array];
    _requestManager = [[LJCDoctorRequestManager alloc] init];
//    _heightAtIndexPath = [NSMutableDictionary dictionary];
    
    self.navigationItem.title = @"Doctor";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor brownColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[LJCDoctorCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf p_fetchFirstPageDoctors];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter/*MJRefreshBackNormalFooter*/ footerWithRefreshingBlock:^{
        [weakSelf p_fetchNextPageDoctors];
    }];
    
    [self p_addMasonry];
    
    [self p_fetchFirstPageDoctors];
}

- (void)p_addMasonry
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}
// this is Apple's recommended place for adding/updating constraints
- (void)updateViewConstraints
{
    /*
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
     */

    [super updateViewConstraints];
}

#pragma mark - Network
- (void)p_fetchFirstPageDoctors
{
    // Network
    [self.requestManager fetchFirstPageDoctorsWithCompletion:^(NSArray<LJCDoctorModel *> *datas) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.datas removeAllObjects];
            [self.datas addObjectsFromArray:datas];
            [self.tableView reloadData];
        });
    }];
}

- (void)p_fetchNextPageDoctors
{
    // Network
    [self.requestManager fetchNextPageDoctorsWithCompletion:^(NSArray<LJCDoctorModel *> *datas) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.datas addObjectsFromArray:datas];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJCDoctorModel *model = self.datas[indexPath.row];
    LJCDoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
//    cell.fd_enforceFrameLayout = YES;
//    cell.textLabel.text = model.name;
    [cell configWithModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate
/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"estimatedHeightForRowAtIndexPath");
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if (height) {
        return height.floatValue;
    }
    else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.datas.count) {
        LJCDoctorModel *model = self.datas[indexPath.row];
        return model.cachedCellHeight;
    }
    return 44.f;

    /* FDTemplate
    return [tableView fd_heightForCellWithIdentifier:kCellIdentifier cacheByIndexPath:indexPath configuration:^(LJCDoctorCell *cell) {
        // configurations
        cell.model = self.datas[indexPath.row];
    }];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
