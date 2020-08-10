//
//  LivePreview.m
//  PARtmp
//
//  Created by DevMaster on 8/9/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import "LivePreview.h"


@implementation LivePreview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        [self requestAccessForVideo];
        [self requestAccessForAudio];
        [self addZoomControl];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.stateLabel];
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.cameraButton];
//        [self.containerView addSubview:self.beautyButton];
        [self.containerView addSubview:self.startLiveButton];
        self.currentScaleFactor = 1.0f;
    }
    return self;
}

#pragma mark -- Public Method
- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            //dispatch_async(dispatch_get_main_queue(), ^{
            [_self.session setRunning:YES];
            //});
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (void)addZoomControl
{
    UIPinchGestureRecognizer * pinGeture =  [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchZoom:)];
    [self addGestureRecognizer:pinGeture];
}

#pragma mark -- Recognizer
- (void)handlePinchZoom:(UIPinchGestureRecognizer *)pinchRecognizer
{
    
    CGFloat maxZoomFactor = 3.0;
    const CGFloat pinchVelocityDividerFactor = 2.0f;
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged || pinchRecognizer.state ==UIGestureRecognizerStateBegan)
    {
        
            CGFloat desiredZoomFactor = self.currentScaleFactor +
              atan2f(pinchRecognizer.velocity, pinchVelocityDividerFactor);

            self.currentScaleFactor   =   MAX(1.0, MIN(desiredZoomFactor,
                                             maxZoomFactor));
//        if (self.session.state == LFLiveStart) {
            [self.session setZoomScale:self.currentScaleFactor];
//        }
    }
 }


#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"liveStateDidChange: %ld", state);
    switch (state) {
        case LFLiveReady:
            _stateLabel.text = @"Not Connected";
            break;
        case LFLivePending:
            _stateLabel.text = @"Connecting...";
            break;
        case LFLiveStart:
            _stateLabel.text = @"Connected";
            break;
        case LFLiveError:
            _stateLabel.text = @"Connection Error";
            break;
        case LFLiveStop:
            _stateLabel.text = @"Not Connected";
            break;
        default:
            break;
    }
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    NSLog(@"debugInfo: %lf", debugInfo.dataFlow);
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark -- Getter Setter
- (LFLiveSession*)session{
    if(!_session){
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        
        
        
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        
//        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2 landscape:NO]];
        
       _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        
        
        /**    自己定制单声道  */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 1;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_64Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K 分辨率设置为540*960 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(540, 960);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 24;
         videoConfiguration.videoMaxKeyframeInterval = 48;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向横屏  */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(1280, 720);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = YES;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        _session.delegate = self;
        _session.preView = self;
        [_session setCaptureDevicePosition:AVCaptureDevicePositionBack];
        
    }
    return _session;
}

- (UIView*)containerView{
    if(!_containerView){
        _containerView = [UIView new];
        _containerView.frame = self.bounds;
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _containerView;
}

- (UILabel*)stateLabel{
    if(!_stateLabel){
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 40)];
        _stateLabel.text = @"Not Connected";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14.f];
    }
    return _stateLabel;
}

- (UIButton*)closeButton{
    if(!_closeButton){
        CGRect btnRect = CGRectMake(20, 20, 44, 44);
        btnRect.origin.x = self.frame.size.width - 10 - 44;
        btnRect.origin.y = 20;
        _closeButton = [[UIButton alloc] initWithFrame:btnRect];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        _closeButton.frame = btnRect;
        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
//        [_closeButton addTarget:self action:@selector(clickScaleButton) forControlEvents:UIControlEventTouchUpInside];
        
//        _closeButton = [UIButton alloc];
//        _closeButton.size = CGSizeMake(44, 44);
//        _closeButton.left = self.width - 10 - _closeButton.width;
//        _closeButton.top = 20;
//        [_closeButton setImage:[UIImage imageNamed:@"close_preview"] forState:UIControlStateNormal];
//        _closeButton.exclusiveTouch = YES;
//        [_closeButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//
//        }];
    }
    return _closeButton;
}

- (UIButton*)cameraButton{
    if(!_cameraButton){
        CGRect btnRect = CGRectMake(20, 20, 44, 44);
        btnRect.origin.x = _closeButton.frame.origin.x - 10 - 44;
        btnRect.origin.y = 20;
        _cameraButton = [[UIButton alloc] initWithFrame:btnRect];
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setBackgroundColor:[UIColor clearColor]];
        _cameraButton.frame = btnRect;
        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        
//        _cameraButton = [UIButton new];
//        _cameraButton.size = CGSizeMake(44, 44);
//        _cameraButton.origin = CGPointMake(_closeButton.left - 10 - _cameraButton.width, 20);
//        [_cameraButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
//        _cameraButton.exclusiveTouch = YES;
//        __weak typeof(self) _self = self;
//        [_cameraButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//            AVCaptureDevicePosition devicePositon = _self.session.captureDevicePosition;
//            _self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
//
//        }];
    }
    return _cameraButton;
}

//- (UIButton*)beautyButton{
//    if(!_beautyButton){
////        _beautyButton = [UIButton new];
////        _beautyButton.size = CGSizeMake(44, 44);
////        _beautyButton.origin = CGPointMake(_cameraButton.left - 10 - _beautyButton.width,20);
////        [_beautyButtonsetImage:[UIImage imageNamed:@"camra_beauty"] forState:UIControlStateSelected];
////        [_beautyButton  setImage:[UIImage imageNamed:@"camra_beauty_close"] forState:UIControlStateNormal];
////        _beautyButton.exclusiveTouch = YES;
////        __weak typeof(self) _self = self;
////        [_beautyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
////            _self.session.beautyFace = !_self.session.beautyFace;
////            _self.beautyButton.selected = !_self.session.beautyFace;
////        }];
//    }
//    return _beautyButton;
//}

- (UIButton*)startLiveButton{
    if(!_startLiveButton){
//        _startLiveButton = [UIButton new];
//        _startLiveButton.size = CGSizeMake(self.width - 60, 44);
//        _startLiveButton.left = 30;
//        _startLiveButton.bottom = self.height - 50;
//        _startLiveButton.layer.cornerRadius = _startLiveButton.height/2;
        
        CGRect btnRect = CGRectMake(20, 20, 44, 44);
        btnRect.origin.x = 30;
        btnRect.origin.y = self.frame.size.height - 50;
        _startLiveButton = [[UIButton alloc] initWithFrame:btnRect];
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startLiveButton setBackgroundColor:[UIColor clearColor]];
        _startLiveButton.frame = btnRect;
        [_startLiveButton setImage:[UIImage imageNamed:@"camra_preview"] forState:UIControlStateNormal];
        
        [_startLiveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startLiveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startLiveButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startLiveButton setBackgroundColor:[UIColor colorWithRed:50 green:32 blue:245 alpha:1]];
        _startLiveButton.exclusiveTouch = YES;
        [_startLiveButton addTarget:self action:@selector(clickStartButton) forControlEvents:UIControlEventTouchUpInside];
//        __weak typeof(self) _self = self;
//        [_startLiveButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
//            _self.startLiveButton.selected = !_self.startLiveButton.selected;
//            if(_self.startLiveButton.selected){
//                [_self.startLiveButton setTitle:@"Finish" forState:UIControlStateNormal];
//                LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
////                stream.url = @"rtmp://192.168.101.80/boris/lv";
//                stream.url = @"rtmp://3.89.78.208/live/g121790";
//                //stream.url = @"rtmp://daniulive.com:1935/live/stream2399";
//                [_self.session setZoomScale:2.0];
//                [_self.session setSaveLocalVideo:false];
//                [_self.session setMuted:true];
//                [_self.session startLive:stream];
//            }else{
//                [_self.startLiveButton setTitle:@"Start" forState:UIControlStateNormal];
//                [_self.session stopLive];
//            }
//        }];
    }
    return _startLiveButton;
}

-(void)clickStartButton
{
    self.startLiveButton.selected = !self.startLiveButton.selected;
    if(self.startLiveButton.selected){
        [self.startLiveButton setTitle:@"Finish" forState:UIControlStateNormal];
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
//                stream.url = @"rtmp://192.168.101.80/boris/lv";
        stream.url = @"rtmp://3.89.78.208/live/g121790";
        //stream.url = @"rtmp://daniulive.com:1935/live/stream2399";
        [self.session setZoomScale:2.0];
        [self.session setSaveLocalVideo:false];
        [self.session setMuted:true];
        [self.session startLive:stream];
    }else{
        [self.startLiveButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.session stopLive];
    }
}

@end