//
//  CamViewController.m
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 17/06/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "CamViewController.h"

#import "CamPreview.h"

@interface CamViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, weak) IBOutlet CamPreview *cameraPreview;

@property (nonatomic) AVCaptureSession *session;

@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic) AVCaptureMetadataOutput *metaDataOutput;

@property (nonatomic) NSTimer* metaDataTimer;

@property (nonatomic) NSInteger ovelayDismissTime;

@end

@implementation CamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Create the AVCaptureSession.
    self.session = [[AVCaptureSession alloc] init];

    // Setup the preview view.
    [self.cameraPreview setSession:self.session];

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }

    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    output.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA)};
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }


    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddOutput:self.stillImageOutput]){
        [self.session addOutput:self.stillImageOutput];
    }


    self.metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:self.metaDataOutput])
    {
        [self.session addOutput:self.metaDataOutput];
        [self.metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode39Code]];
    }

    [self.session startRunning];

}


#pragma mark - Frames

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.ovelayDismissTime >2) {
        [self resetDetectedTimer];
    }
}

#pragma mark - Meta data Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{

    if (![self.metaDataTimer isValid]) [self startDetectedTimer];


    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
         {
             AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)[(AVCaptureVideoPreviewLayer *)[self.cameraPreview layer] transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)obj];
             CGPoint topLeftPoint = [self pointFromArray:code.corners atIndex:0];
             CGPoint bottomLeftPoint = [self pointFromArray:code.corners atIndex:1];
             CGPoint bottomRightPoint = [self pointFromArray:code.corners atIndex:2];
             CGPoint topRightPoint = [self pointFromArray:code.corners atIndex:3];
             [self drawHighlightOverlayForPoints:[NSArray arrayWithObjects:
                                                  [NSValue valueWithCGPoint:topLeftPoint],
                                                  [NSValue valueWithCGPoint:bottomLeftPoint],
                                                  [NSValue valueWithCGPoint:bottomRightPoint],
                                                  [NSValue valueWithCGPoint:topRightPoint],
                                                  nil]];

             self.ovelayDismissTime = 0;
         }
     }];

}

#pragma mark - Overlay Points

- (CGPoint)pointFromArray:(NSArray *)points atIndex:(NSUInteger)index {
    NSDictionary *dict = [points objectAtIndex:index];
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)dict, &point);
    return [self.cameraPreview convertPoint:point fromView:self.view];
}

-(void)drawHighlightOverlayForPoints:(NSArray *)featureAry
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath *aPath = [UIBezierPath bezierPath];// intiallize new bezierPath for each path change
        [aPath moveToPoint:[featureAry[1]CGPointValue]];
        [aPath addLineToPoint:[featureAry[0]CGPointValue]];
        [aPath addLineToPoint:[featureAry[3]CGPointValue]];
        [aPath addLineToPoint:[featureAry[2]CGPointValue]];
        [aPath closePath];
        [self.cameraPreview.overlay drawPath:aPath ofWidth:3.0f];
    });
}

#pragma mark - Timer

-(void)startDetectedTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ovelayDismissTime = 0;
        self.metaDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDetectedTime:) userInfo:nil repeats:YES];
    });
}
-(void)resetDetectedTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.metaDataTimer isValid]) {
            [self.metaDataTimer invalidate];
            self.metaDataTimer = nil;
            [self.cameraPreview.overlay erase];
            self.ovelayDismissTime =0;
        }
    });
}

- (void) updateDetectedTime:(NSTimer *)timer{
    self.ovelayDismissTime += 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
