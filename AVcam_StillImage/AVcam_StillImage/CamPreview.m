//
//  CamPreview.m
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 22/02/16.
//  Copyright © 2016 ZOHOCORP. All rights reserved.
//

#import "CamPreview.h"

@implementation CamPreview

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

- (void)awakeFromNib{

    self.overlay = [[OverlayView alloc] init];
    [self.overlay setFillColor:[UIColor clearColor]];
    [self.overlay setStrokeColor:[UIColor orangeColor]];
    [self addSubview:self.overlay];

}

@end
