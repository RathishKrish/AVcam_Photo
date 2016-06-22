//
//  OverlayView.h
//  AVcam_StillImage
//
//  Created by Rathish Krish T on 22/02/16.
//  Copyright © 2016 ZOHOCORP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (void)loadShapeLayerinFrame:(CGRect)frame;
-(void)drawPath:(UIBezierPath *)path ofWidth:(CGFloat)width;
- (void)erase;

@end


