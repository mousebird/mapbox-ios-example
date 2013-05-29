//
//  OnlineLayerViewController.m
//  MapBox Example
//
//  Created by Justin Miller on 3/27/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "OnlineLayerViewController.h"

#import "MapBox.h"

#define kNormalMapID @"examples.map-z2effxa8"
#define kRetinaMapID @"examples.map-zswgei2n"

@implementation OnlineLayerViewController
{
    RMMapView *mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaMapID : kNormalMapID)];
    
    mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource maplyMode:(self.renderingMode != RouteMeModeOld)];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:mapView];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [mapView removeFromSuperview];
    mapView = nil;
}

@end