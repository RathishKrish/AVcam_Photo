//
//  CamPreview.h
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 22/02/16.
//  Copyright © 2016 ZOHOCORP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "OverlayView.h"

@interface CamPreview : UIView

@property (nonatomic) AVCaptureSession *session;

@property (nonatomic, strong) OverlayView *overlay;

@end
