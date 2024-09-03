//
//  LJCKeyboardViewController.m
//  LJCDBStore
//
//  Created by 林锦超 on 07/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCKeyboardViewController.h"

@interface LJCKeyboardViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *complicatedView;
@property (nonatomic, strong) UITextField *subTextField;
@end

@implementation LJCKeyboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Keyboard";
    self.view.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.complicatedView];
    [self p_addMasonry];
}

- (void)loadView
{
//    self.view = [UIScrollView new]; // IQKeyboardManager 键盘弹起时，NavBar不会向上弹起，需要设置contentSize
    
    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    self.view = scrollView;
}

- (void)p_addMasonry
{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-50);
        make.width.and.height.mas_equalTo(250);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(self.textView);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.textView.mas_top).offset(-10);
    }];
    
    [self.complicatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.left.and.right.equalTo(self.textView);
        make.height.mas_equalTo(100);
    }];
    
    [self.subTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self.complicatedView).offset(30);
        make.right.and.bottom.equalTo(self.complicatedView).offset(-30);
    }];
}

#pragma mark - Getter
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:30.f];
    }
    return _textView;
}

- (UIView *)complicatedView
{
    if (!_complicatedView) {
        _complicatedView = [[UIView alloc] init];
        _complicatedView.backgroundColor = [UIColor brownColor];
        
        self.subTextField = [UITextField new];
        self.subTextField.textColor = [UIColor blackColor];
        self.subTextField.backgroundColor = [UIColor whiteColor];
        [_complicatedView addSubview:self.subTextField];
    }
    return _complicatedView;
}

@end
