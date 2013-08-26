//
//  ShapeLayerViewController.m
//  MapBox Example
//
//  Created by Steve Gifford on 6/4/13.
//  Copyright (c) 2013 MapBox / Development Seed. All rights reserved.
//

#import "ShapeLayerViewController.h"

#import "MapBox.h"
#import "MaplyComponent.h"

#define kNormalMapID @"examples.map-z2effxa8"
#define kRetinaMapID @"examples.map-zswgei2n"

@interface ShapeLayerViewController ()

@end

@implementation ShapeLayerViewController
{
    RMMapView *mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaMapID : kNormalMapID)];
    
    mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:onlineSource maplyMode:(RMMaplyMode)self.renderingMode];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:mapView];

    // Might as well do the work on another queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                        // Grab a shapefile with country outlines
                        MaplyVectorDatabase *countryDb = [MaplyVectorDatabase vectorDatabaseWithShape:@"ne_110m_admin_0_map_units"];
                        if (countryDb)
                        {
                            MaplyVectorObject *allCountries = [countryDb fetchAllVectors];

                            // Draw the shape with route-me
                            if (self.renderingMode == RMMaplyModeNone)
                            {
                                NSArray *countries = [allCountries splitVectors];
                                for (MaplyVectorObject *country in countries)
                                {
                                    NSArray *loops = [country asCLLocationArrays];
                                    for (NSArray *pts in loops)
                                    {
                                        RMShapeAnnotation *shape = [[RMPolygonAnnotation alloc] initWithMapView:mapView points:pts];
                                        // But we have to merge the shape in on the main thread
                                        dispatch_async(dispatch_get_main_queue(),
                                                       ^{
                                                           [mapView addAnnotation:shape];
                                                       });
                                    }
                                }
                            } else {
                                // Draw the shapes with Maply
                                // Width 4 pixels, black lines, draw on top of the base layers, and fade in over 1s
                                // Okay, I'm just showing off with that last one
                                [mapView.maplyViewController addVectors:@[allCountries] desc:@{kMaplyVecWidth: @(5.0), kMaplyColor: [UIColor blackColor], kMaplyFade: @(1.0)}];
                            }
                        }
                   });
}

@end
