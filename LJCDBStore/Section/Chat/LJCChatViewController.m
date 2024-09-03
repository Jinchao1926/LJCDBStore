//
//  LJCChatViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 22/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatViewController.h"
#import "LJCChatToolbar.h"
#import "LJCChatLayout.h"
#import "LJCChatPerformer.h"
#import "LJCChatRequestManager.h"

//#define Lock() dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER)
//#define Unlock() dispatch_semaphore_signal(self.lock)

@interface LJCChatViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, LJCChatCellDelegate, YYTextKeyboardObserver, LJCChatRequestManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LJCChatToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray<LJCChatLayout *> *layouts;
@property (nonatomic, strong) LJCChatRequestManager *requestManager;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

@implementation LJCChatViewController

- (void)dealloc
{
    NSLog(@"dealloc LJCChatViewController.");
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lock = dispatch_semaphore_create(1);
    _layouts = [NSMutableArray array];
    _requestManager = [LJCChatRequestManager new];
    _requestManager.delegate = self;
    _requestManager.chatUserData = @{ LJCChatRequestManagerFromUserId : LJCChatFromUserId,
                                      LJCChatRequestManagerFromUserName : @"大师兄",
                                      LJCChatRequestManagerToUserId : LJCChatToUserId,
                                      LJCChatRequestManagerToUserName : @"小师弟",
                                      };
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    
    self.navigationItem.title = @"小师弟";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearChatMessages:)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];

    [self p_layoutSubViews];
    
    [self.requestManager fetchChatMessages];
}

- (void)p_layoutSubViews
{
    CGFloat toolbarHeight = 50.f;
    self.toolBar.frame = CGRectMake(0, self.view.height - kUnsafeBottomHeight - toolbarHeight, self.view.width, toolbarHeight);
    self.tableView.frame = CGRectMake(0, kNavStatusBarHeight, self.toolBar.width, CGRectGetMinY(self.toolBar.frame) - kNavStatusBarHeight);
    
    /*
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.left.right.and.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
        }
        else {
            make.left.right.and.bottom.equalTo(self.view);
        }
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolBar.mas_top);
        if (@available(iOS 11.0, *)) {
            make.top.left.and.right.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.left.and.right.equalTo(self.view);
        }
    }];
    */
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorHex(f0f0f0);
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [LJCChatPerformer registerChatCellsForTableView:self.tableView];
        
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.requestManager fetchChatMessages];
        }];
    }
    return _tableView;
}

- (LJCChatToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [LJCChatToolbar new];
        
        @weakify(self)
        _toolBar.textMessageSender = ^(NSString *message) {
            @strongify(self);
            LJCChatModel *chat = [self.requestManager sendChatTextMessage:message];
            [self p_addOneChatMessage:chat];
        };
        _toolBar.imageMessageSender = ^(UIImage *image) {
            @strongify(self)
            LJCChatModel *chat = [self.requestManager sendChatImageMessage:image];
            [self p_addOneChatMessage:chat];
        };
        _toolBar.videoMessageSender = ^(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage, BOOL emptyOriginal) {
            @strongify(self)
            LJCChatModel *chat = [self.requestManager sendChatVideoMessage:videoURL duration:duration withCoverImage:coverImage emptyOriginal:emptyOriginal];
            [self p_addOneChatMessage:chat];
        };
    }
    return _toolBar;
}

#pragma mark -
- (void)p_addOneChatMessage:(LJCChatModel *)message
{
    LJCChatLayout *layout = [[LJCChatLayout alloc] initWithChat:message];
    [self.layouts addObject:layout];
    
    NSInteger insertRow = MAX(self.layouts.count - 1, 0);
    [self.tableView insertRow:insertRow inSection:0 withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView scrollToBottomIfNeeded];
}

- (void)p_replaceOneChatMessage:(LJCChatModel *)message
{
    [self.layouts enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LJCChatLayout * _Nonnull layout, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([layout.chat isEqual:message]) {
//            NSLog(@"layout.chat isEqual:%@", layout.chat);
            
            [layout layout];
//            [UIView performWithoutAnimation:^{
                [self.tableView reloadRow:idx inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//            }];
            
            *stop = YES;
        }
    }];
}

#pragma mark - LJCChatRequestManagerDelegate
- (void)chatMessagesDidFetchCompletion:(NSArray<LJCChatModel *> *)messages isLoadMore:(BOOL)more
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (LJCChatModel *aModel in messages) {
            LJCChatLayout *layout = [[LJCChatLayout alloc] initWithChat:aModel];
            [self.layouts insertObject:layout atIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat preContentHeight = self.tableView.contentSize.height;
            CGFloat preContentOffsetY = self.tableView.contentOffset.y;
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            
            if (!more) {
                [self.tableView scrollToBottomAnimatedIfNeeded:NO];
            }
            else {
                CGPoint offset = self.tableView.contentOffset;
                offset.y = self.tableView.contentSize.height - preContentHeight + preContentOffsetY;
                [self.tableView setContentOffset:offset];
            }
        });
    });
}

- (void)chatMessageDidSendSuccess:(LJCChatModel *)message
{
    [self p_replaceOneChatMessage:message];
}

- (void)chatMessageDidSendFailed:(LJCChatModel *)message
{
    [self p_replaceOneChatMessage:message];
}

#pragma mark - YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition
{
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    BOOL isKeyboardHide = CGRectGetMinY(toFrame) >= self.view.height;
    CGFloat bottom = isKeyboardHide ? CGRectGetMinY(toFrame) - kUnsafeBottomHeight : CGRectGetMinY(toFrame);
   
    [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.toolBar.bottom = bottom;
        self.tableView.height = CGRectGetMinY(self.toolBar.frame) - self.tableView.top;
        
        if (!isKeyboardHide) {
            [self.tableView scrollToBottomAnimatedIfNeeded:NO];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatLayout *layout = self.layouts[indexPath.row];
    UITableViewCell *cell = [LJCChatPerformer dequeueChatCellForTableView:self.tableView withSourceType:layout.chat.chatType];
    
    if ([cell isKindOfClass:[LJCChatCell class]]) {
        LJCChatCell *chatCell = (LJCChatCell *)cell;
        chatCell.delegate = self;
        [chatCell configWithLayout:layout];
    }
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - LJCChatCellDelegate
- (void)cell:(LJCChatCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange
{
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) {
        return;
    }
    
    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    NSDictionary *info = highlight.userInfo;
    NSLog(@"info:%@", info);
}

#pragma mark - Action
- (IBAction)clearChatMessages:(id)sender
{
    [SVProgressHUD show];
    if ([self.requestManager clearAllChatMessages]) {
        [YYCache emptyCaches];
        [SVProgressHUD showSuccessWithStatus:@"成功"];
        
        [self.layouts removeAllObjects];
        [self.tableView reloadData];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }
}

@end
