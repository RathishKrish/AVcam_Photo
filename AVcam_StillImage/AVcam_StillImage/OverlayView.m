//
//  OverlayView.m
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 22/02/16.
//  Copyright © 2016 ZOHOCORP. All rights reserved.
//

#import "OverlayView.h"


@interface OverlayView ()

@property int check;

@end


@implementation OverlayView

-(id)init
{
    self=[super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineWidth = 2.0f;
        [self.layer addSublayer:self.shapeLayer];
    }
    return self;
}

- (void)loadShapeLayerinFrame:(CGRect)frame{
    [self drawPath:[UIBezierPath bezierPathWithRect:frame] ofWidth:2.0f];
}

-(void)drawPath:(UIBezierPath *)path ofWidth:(CGFloat)width
{
    if (path) {
        [_shapeLayer setLineWidth:width];
        _shapeLayer.strokeColor = self.strokeColor.CGColor;
        _shapeLayer.fillColor = self.fillColor.CGColor;
        [_shapeLayer setPath:path.CGPath];
        [_shapeLayer setNeedsDisplay];
        [_shapeLayer setNeedsLayout];
    }
}

- (void)erase {
    [_shapeLayer setPath:nil];
    [self setNeedsDisplay];
}


@end
