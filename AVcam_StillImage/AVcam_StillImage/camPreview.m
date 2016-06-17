//
//  BCFocusView.m
//  Leads
//
//  Created by Rathish Krish T on 22/02/16.
//  Copyright © 2016 ZOHOCORP. All rights reserved.
//

#import "camPreview.h"

@implementation camPreview

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

@end
