//
//  LJCDoctorYYViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 20/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorYYViewController.h"
#import "LJCDoctorModel.h"
#import "LJCDoctorRequestManager.h"
#import "LJCDoctorYYLayout.h"
#import "LJCDoctorYYCell.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LJCDoctorYYViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<LJCDoctorYYLayout *> *layouts;
@property (nonatomic, strong) LJCDoctorRequestManager *requestManager;
@end

@implementation LJCDoctorYYViewController

- (void)dealloc
{
    NSLog(@"dealloc LJCDoctorViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _layouts = [NSMutableArray array];
    _requestManager = [[LJCDoctorRequestManager alloc] init];
    
    self.navigationItem.title = @"DoctorYY";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor brownColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[LJCDoctorYYCell class] forCellReuseIdentifier:kCellIdentifier];
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

#pragma mark - Network
- (void)p_fetchFirstPageDoctors
{
    // Network
    [self.requestManager fetchFirstPageDoctorsWithCompletion:^(NSArray<LJCDoctorModel *> *datas) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
            [self.layouts removeAllObjects];
            for (LJCDoctorModel *aModel in datas) {
                LJCDoctorYYLayout *layout = [[LJCDoctorYYLayout alloc] initWithDoctor:aModel];
                [self.layouts addObject:layout];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                [self.tableView reloadData];
            });
        });
    }];
}

- (void)p_fetchNextPageDoctors
{
    // Network
    [self.requestManager fetchNextPageDoctorsWithCompletion:^(NSArray<LJCDoctorModel *> *datas) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for (LJCDoctorModel *aModel in datas) {
                LJCDoctorYYLayout *layout = [[LJCDoctorYYLayout alloc] initWithDoctor:aModel];
                [self.layouts addObject:layout];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                
                [self.tableView reloadData];
            });
        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJCDoctorYYLayout *layout = self.layouts[indexPath.row];
    LJCDoctorYYCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    [cell configWithLayout:layout];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.layouts.count) {
        return self.layouts[indexPath.row].height;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
