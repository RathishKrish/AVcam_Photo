//
//  ViewController.m
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 17/06/16.
//  Copyright © 2016 Rathish Marthandan T. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "CamViewController.h"
#import "camPreview.h"

@interface CamViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, weak) IBOutlet camPreview *camPreview;

@property (nonatomic) AVCaptureSession *session;

@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic) AVCaptureMetadataOutput *metaDataOutput;

@end

@implementation CamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Create the AVCaptureSession.
    self.session = [[AVCaptureSession alloc] init];

    // Setup the preview view.
    [self.camPreview setSession:self.session];
    ((AVPlayerLayer *)[self.camPreview layer]).videoGravity = AVLayerVideoGravityResizeAspectFill;

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
    NSDictionary *outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};;
    [self.stillImageOutput setOutputSettings:outputSettings];
    if ([self.session canAddOutput:self.stillImageOutput]){
        [self.session addOutput:self.stillImageOutput];
    }


    self.metaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.metaDataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:self.metaDataOutput])
    {
        [self.session addOutput:self.metaDataOutput];
        [self.metaDataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode39Code]];
    }

    [self.session startRunning];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
