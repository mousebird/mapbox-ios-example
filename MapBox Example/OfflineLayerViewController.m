//
//  OfflineLayerViewController.m
//  MapBox Example
//
//  Created by Justin Miller on 4/5/12.
//  Copyright (c) 2012 MapBox / Development Seed. All rights reserved.
//

#import "OfflineLayerViewController.h"

#import "MapBox.h"

@implementation OfflineLayerViewController
{
    RMMapView *mapView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"control-room-0.2.0" ofType:@"mbtiles"];
    
    mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource maplyMode:(self.renderingMode != RouteMeModeOld)];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    
    [self.view addSubview:mapView];    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [mapView removeFromSuperview];
    mapView = nil;
}

@end