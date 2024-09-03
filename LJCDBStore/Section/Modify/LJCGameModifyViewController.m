//
//  LJCGameModifyViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 24/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCGameModifyViewController.h"
#import "LJCGameStore.h"
#import "LJCGameModel.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LJCGameModifyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation LJCGameModifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datas = @[ @"插入一条数据", @"插入多条数据", @"删除一条数据", @"批量修改数据", @"清空表", @"修改表结构", @"删除表" ];
    
    self.navigationItem.title = @"Games Modify";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)updateViewConstraints
{
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
    //self.datas = @[ @"插入一条数据", @"插入多条数据", @"删除一条数据", @"批量修改数据", @"修改表结构", @"删除表" ];
    switch (indexPath.row) {
        case 0:
            {
                // 插入一条数据
                LJCGameModel *aGame = [[LJCGameModel alloc] init];
                [aGame ljc_setIsAutoIncrement:YES]; //主键自增
//                aGame.gameId = 1;
                aGame.gameName = @"游戏王";
                aGame.gameDescription = @"这是游戏王！！！";
                BOOL ret = [LJCGameStore insertGame:aGame];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"insertGame:%d", ret);
            }
            break;
        
        case 1:
            {
                // 插入多条数据
                LJCGameModel *gameA = [[LJCGameModel alloc] init];
                gameA.gameId = 10;
                gameA.gameName = @"海贼王";
                gameA.gameDescription = @"这是海贼王！！！";
                
                LJCGameModel *gameB = [[LJCGameModel alloc] init];
                gameB.gameId = 11;
                gameB.gameName = @"火影忍者";
                gameB.gameDescription = @"《火影忍者》是日本漫画家岸本齐史的代表作，作品于1999年开始在《周刊少年JUMP》上连载，于2014年11月10日发售的JUMP第50号完结；后日谈性质的外传漫画《火影忍者外传：第七代火影与绯色花月》则于同杂志2015年第22、23合并号开始短期连载，至同年第32号完结。";
                BOOL ret = [LJCGameStore insertGames:@[ gameA, gameB ]];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"insertGames:%d", ret);
            }
            break;
            
        case 2:
            {
                //删除一条数据
                BOOL ret = [LJCGameStore deleteGame:@"1"];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"deleteGame:%d", ret);
            }
            break;
            
        case 3:
            {
                //批量修改数据
                BOOL ret = [LJCGameStore updateYoGiOhToOnePiece];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"updateYoGiOhToOnePiece:%d", ret);
            }
            break;
            
        case 4:
            {
                //清空表
                BOOL ret = [LJCGameStore deleteAllGames];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"deleteAllGames:%d", ret);
            }
            break;
            
        case 5:
            {
                //修改表结构
                [SVProgressHUD showAwhile];
                
                // show then auto dismiss
//                [SVProgressHUD showSuccessWithStatus:@"直接添加ORM字段即可"]; //success
//                [SVProgressHUD showErrorWithStatus:@"直接添加ORM字段即可"];   //error
//                [SVProgressHUD showInfoWithStatus:@"直接添加ORM字段"];    //infomation
//                [SVProgressHUD showImage:[UIImage imageNamed:@"short_voice"] status:@"直接添加ORM字段"];
                
                // need dismiss
//                [SVProgressHUD showWithStatus:@"直接添加ORM字段"];
//                [SVProgressHUD show];
//                [SVProgressHUD dismissWithDelay:1.f];
                
//                [SVProgressHUD showProgress:0.5];
            }
            break;
            
        case 6:
            {
                //删除表
                BOOL ret = [LJCGameStore dropGameTable];
                if (ret) {
                    [SVProgressHUD showSuccessWithStatus:@"成功"];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"失败"];
                }
                NSLog(@"dropGameTable:%d", ret);
            }
            break;
        default:
            break;
    }
}

@end
