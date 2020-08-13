//
//  LivePreview.m
//  PARtmp
//
//  Created by DevMaster on 8/9/20.
//  Copyright © 2020 DevMaster. All rights reserved.
//

#import "LivePreview.h"


@implementation LivePreview


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//        self.backgroundColor = [UIColor clearColor];
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
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            [_self.session setRunning:YES];
            //});
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            
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

        self.currentScaleFactor = MAX(1.0, MIN(desiredZoomFactor, maxZoomFactor));
//        if (self.session.state == LFLiveStart) {
        [self.session setZoomScale:self.currentScaleFactor];
        [self.session setTorch:false];
//        }
    }
 }


#pragma mark -- LFStreamingSessionDelegate

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
       _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        
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
        

    }
    return _cameraButton;
}



- (UIButton*)startLiveButton{
    if(!_startLiveButton){

        
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

