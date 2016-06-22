//
//  OverlayView.h
//  Try
//
//  Created by Arunachalam Saravanan on 04/03/15.
//  Copyright (c) 2015 Zoho. All rights reserved.
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


