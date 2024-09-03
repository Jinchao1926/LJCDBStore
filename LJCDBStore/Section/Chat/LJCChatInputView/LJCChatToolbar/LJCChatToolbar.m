//
//  LJCChatToolbar.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatToolbar.h"
#import "LJCChatTextField.h"
#import "LJCChatToggleButton.h"
#import "LJCChatEmojiInputView.h"
#import "LJCChatMoreInputView.h"
#import "LJCPhotoPickerProxy.h"
#import "LJCCameraRecorderProxy.h"

#define kChatToolbarAnimationDuration   0.25f

@interface LJCChatToolbar()<UITextFieldDelegate, LJCChatEmojiInputViewDelegate, LJCChatMoreInputViewDelegate>
@property (nonatomic, strong) LJCChatToggleButton *voiceButton;
@property (nonatomic, strong) LJCChatToggleButton *emojiButton;
@property (nonatomic, strong) LJCChatToggleButton *moreButton;
@property (nonatomic, strong) LJCChatTextField *chatInputField;
@property (nonatomic, strong) UIButton *voiceRecordButton;

@property (nonatomic, strong) LJCPhotoPickerProxy *photoPicker;
@property (nonatomic, strong) LJCCameraRecorderProxy *cameraRecorder;
@end
@implementation LJCChatToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = CGFloatFromPixel(2);
        self.layer.borderColor = UIColorHex(e3e3e3).CGColor;
        
        [self addSubview:self.voiceButton];
        [self addSubview:self.emojiButton];
        [self addSubview:self.moreButton];
        [self addSubview:self.chatInputField];
        [self addSubview:self.voiceRecordButton];
        
        [LJCChatEmojiInputView sharedInputView].delegate = self;
        [LJCChatMoreInputView sharedInputView].delegate = self;
        
        [self p_layoutSubViews];
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.centerY.mas_equalTo(self.height / 2);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15);
        make.size.and.centerY.equalTo(self.voiceButton);
    }];
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left).with.offset(-15);
        make.size.and.centerY.equalTo(self.moreButton);
    }];
    [self.chatInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).with.offset(15);
        make.right.equalTo(self.emojiButton.mas_left).with.offset(-15);
        make.top.and.bottom.equalTo(self.voiceButton);
    }];
    [self.voiceRecordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.chatInputField);
    }];
}
#pragma mark - Getter
- (LJCChatToggleButton *)voiceButton
{
    if (!_voiceButton) {
        _voiceButton = [LJCChatToggleButton buttonWithChatType:LJCChatToggleButtonTypeVoice];
        [_voiceButton addTarget:self action:@selector(switchInVoiceAndKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (LJCChatToggleButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [LJCChatToggleButton buttonWithChatType:LJCChatToggleButtonTypeEmoji];
        [_emojiButton addTarget:self action:@selector(showEmojiKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (LJCChatToggleButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [LJCChatToggleButton buttonWithChatType:LJCChatToggleButtonTypeMore];
        [_moreButton addTarget:self action:@selector(showMoreKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (LJCChatTextField *)chatInputField
{
    if (!_chatInputField) {
        _chatInputField = [LJCChatTextField new];
        _chatInputField.textColor = UIColorHex(333333);
        _chatInputField.font = [UIFont systemFontOfSize:15];
        _chatInputField.returnKeyType = UIReturnKeySend;
        _chatInputField.enablesReturnKeyAutomatically = YES;
        _chatInputField.layer.borderWidth = CGFloatFromPixel(1);
        _chatInputField.layer.borderColor = UIColorHex(e3e3e3).CGColor;
        _chatInputField.layer.cornerRadius = 4;
        _chatInputField.delegate = self;
    }
    return _chatInputField;
}

- (UIButton *)voiceRecordButton
{
    if (!_voiceRecordButton) {
        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordButton.hidden = YES;
    }
    return _voiceRecordButton;
}

- (LJCPhotoPickerProxy *)photoPicker
{
    if (!_photoPicker) {
        _photoPicker = [LJCPhotoPickerProxy proxyWithType:LJCPhotoPickerProxyChat];
        
        @weakify(self)
        /// 发送图片
        _photoPicker.photoPickHandler = ^(NSArray<UIImage *> *photos) {
            @strongify(self)
            if (self.imageMessageSender) {
                [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull photo, NSUInteger idx, BOOL * _Nonnull stop) {
                    self.imageMessageSender(photo);
                }];
            }
        };
        /// 发送视频
        _photoPicker.videoPickHandler = ^(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage) {
            @strongify(self)
            if (self.videoMessageSender) {
                self.videoMessageSender(videoURL, duration, coverImage, NO);
            }
        };
    }
    return _photoPicker;
}

- (LJCCameraRecorderProxy *)cameraRecorder
{
    if (!_cameraRecorder) {
        _cameraRecorder = [LJCCameraRecorderProxy proxyWithType:LJCCameraRecorderProxyChat];
        
        @weakify(self)
        /// 发送图片
        _cameraRecorder.photoPickHandler = ^(UIImage *photo) {
            @strongify(self)
            if (self.imageMessageSender) {
                self.imageMessageSender(photo);
            }
        };
        /// 发送视频
        _cameraRecorder.videoPickHandler = ^(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage) {
            @strongify(self)
            if (self.videoMessageSender) {
                self.videoMessageSender(videoURL, duration, coverImage, YES);
            }
        };
    }
    return _cameraRecorder;
}

#pragma mark - Action
- (IBAction)switchInVoiceAndKeyboard:(id)sender
{
//    self.chatInputField.hidden = self.voiceButton.isNormalState;
//    self.voiceRecordButton.hidden = !self.voiceButton.isNormalState;
    if (self.voiceButton.isNormalState) {
        [self.chatInputField resignFirstResponder];
    }
    else {
        self.chatInputField.inputView = nil;
        [self.chatInputField reloadInputViews];
        [self.chatInputField becomeFirstResponder];
    }
    
//    [self p_modifyToolbarCompletionStates:^{
        [self.voiceButton toggleState];
//    }];
}

- (IBAction)showEmojiKeyboard:(id)sender
{
    if (self.emojiButton.isNormalState) {
        self.chatInputField.inputView = [LJCChatEmojiInputView sharedInputView];
        [LJCChatEmojiInputView sharedInputView].firstResponder = self.chatInputField;
    }
    else {
        self.chatInputField.inputView = nil;
    }
    [self.chatInputField reloadInputViews];
    [self.chatInputField becomeFirstResponder];
    
//    [self p_modifyToolbarCompletionStates:^{
        [self.voiceButton setNormalState:YES];
        [self.moreButton setNormalState:YES];
        [self.emojiButton toggleState];
//    }];
}

- (IBAction)showMoreKeyboard:(id)sender
{
    if (self.moreButton.isNormalState) {
        self.chatInputField.inputView = [LJCChatMoreInputView sharedInputView];
    }
    else {
        self.chatInputField.inputView = nil;
    }
    [self.chatInputField reloadInputViews];
    [self.chatInputField becomeFirstResponder];
    
//    [self p_modifyToolbarCompletionStates:^{
        [self.voiceButton setNormalState:YES];
        [self.emojiButton setNormalState:YES];
        [self.moreButton toggleState];
//    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.chatInputField.inputView = nil;
    self.emojiButton.normalState = YES;
    self.moreButton.normalState = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    
    if (self.textMessageSender) {
        self.textMessageSender(textField.text);
    }
    textField.text = nil;
    return YES;
}

#pragma mark - LJCChatEmojiInputViewDelegate
///< 退格
- (void)LJCChatEmojiInputViewDidTapBackspace
{
    [self.chatInputField deleteBackward];
}
///< 输入
- (void)LJCChatEmojiInputViewDidInputText:(NSString *)emojiText
{
    if (emojiText.length > 0) {
        [self.chatInputField insertText:emojiText];
    }
}
///< 发送
- (void)LJCChatEmojiInputViewDidSendEmoji
{
    [self textFieldShouldReturn:self.chatInputField];
}

#pragma mark - LJCChatMoreInputViewDelegate
- (void)LJCChatMoreInputViewDidSelected:(LJCChatMoreCellType)moreType
{
    switch (moreType) {
        case LJCChatMoreCellTypePhoto:
            [self.photoPicker showPhotoLibrary];
            break;
        
        case LJCChatMoreCellTypeCamera:
            [self.cameraRecorder showCamera];
            break;
            
        default:
            break;
    }
}

#pragma mark - Helper
- (void)p_modifyToolbarCompletionStates:(dispatch_block_t)block
{
    if (block) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kChatToolbarAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
}
@end
