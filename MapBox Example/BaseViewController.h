//
//  BaseViewController.h
//  MapBox Example
//
//  Created by Steve Gifford on 5/29/13.
//  Copyright (c) 2013 MapBox / Development Seed. All rights reserved.
//

#import <UIKit/UIKit.h>

// The rendering mode we want.  This is either old or new.
typedef enum {RouteMeModeOld,RouteMeModeMaply,RouteMeModeMaplySources} RouteMeRenderingMode;

@interface BaseViewController : UIViewController

@property (nonatomic,assign) RouteMeRenderingMode renderingMode;

@end
