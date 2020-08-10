//
//  LivePreview.h
//  PARtmp
//
//  Created by DevMaster on 8/9/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LFLiveKit/LFLiveSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivePreview : UIView <LFLiveSessionDelegate>

@property (nonatomic, strong) UIButton *beautyButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *startLiveButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) LFLiveDebug *debugInfo;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic) CGFloat currentScaleFactor;

@end

NS_ASSUME_NONNULL_END
