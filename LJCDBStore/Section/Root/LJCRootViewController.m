//
//  YJRootViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCRootViewController.h"
#import "LJCGameViewController.h"
#import "LJCGameModifyViewController.h"
#import "LJCDoctorViewController.h"
#import "LJCDoctorYYViewController.h"
#import "LJCKeyboardViewController.h"
#import "LJCChatViewController.h"
#import "LJCChatSearchViewController.h"
#import "NSFileManager+LJCDBStore.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LJCRootViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *datas;
@end

@implementation LJCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datas = @[ @"游戏列表(WCDB)",
                    @"游戏增删改(WCDB)",
//                    @"医生列表(YTKNetWork)",
//                    @"医生列表(YTKNetWork + YYKit)",
                    @"Keyboard(IQKeyboardManager)",
                    @"Chat",
                    @"ChatFTS"];
    
    self.navigationItem.title = @"Store";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.tableView];
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateViewConstraints
{
//    NSLog(@"updateViewConstraints");
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
    
    [super updateViewConstraints];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        LJCGameViewController *gameVC = [[LJCGameViewController alloc] init];
        [self.navigationController pushViewController:gameVC animated:YES];
    }
    else if (indexPath.row == 1) {
        LJCGameModifyViewController *gameModifyVC = [[LJCGameModifyViewController alloc] init];
        [self.navigationController pushViewController:gameModifyVC animated:YES];
    }
//    else if (indexPath.row == 2) {
//        LJCDoctorViewController *doctorVC = [[LJCDoctorViewController alloc] init];
//        [self.navigationController pushViewController:doctorVC animated:YES];
//    }
//    else if (indexPath.row == 3) {
//        LJCDoctorYYViewController *doctorVC = [[LJCDoctorYYViewController alloc] init];
//        [self.navigationController pushViewController:doctorVC animated:YES];
//    }
    else if (indexPath.row == 2) {
        LJCKeyboardViewController *keyboardVC = [[LJCKeyboardViewController alloc] init];
        [self.navigationController pushViewController:keyboardVC animated:YES];
    }
    else if (indexPath.row == 3) {
        LJCChatViewController *chatVC = [[LJCChatViewController alloc] init];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else {
        LJCChatSearchViewController *chatSearchVC = [[LJCChatSearchViewController alloc] init];
        [self.navigationController pushViewController:chatSearchVC animated:YES];
    }
}

@end
