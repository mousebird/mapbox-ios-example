//
//  MaplyViewController.m
//  MapBox Example
//
//  Created by Steve Gifford on 6/6/13.
//  Copyright (c) 2013 MapBox / Development Seed. All rights reserved.
//

#import "MaplyMapViewController.h"
#import "MaplyComponent.h"

@interface MaplyViewController ()

@end

@implementation MaplyMapViewController
{
    MaplyViewController *mapViewC;
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
    
    // Fire up the map view controller
    mapViewC = [[MaplyViewController alloc] init];
    [self.view addSubview:mapViewC.view];
    mapViewC.view.frame = self.view.bounds;
    [self addChildViewController:mapViewC];
    
    // For network paging layers, where we'll store temp files
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  objectAtIndex:0];
    NSString *thisCacheDir = nil;
    thisCacheDir = [NSString stringWithFormat:@"%@/%@",cacheDir,_baseMap];

    // Fill out the cache dir if there is one
    if (thisCacheDir)
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:thisCacheDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    // Toss on the layer
    if (_remoteBaseMap)
    {
        MaplyRemoteTileSource *tileSource = [[MaplyRemoteTileSource alloc] initWithBaseURL:@"http://a.tiles.mapbox.com/v3/%@/" ext:@"png" minZoom:0 maxZoom:19];
        MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
        layer.cacheDir = thisCacheDir;
        [mapViewC addLayer:layer];
    } else {
        MaplyMBTileSource *tileSource = [[MaplyMBTileSource alloc] initWithMBTiles:_baseMap];
        MaplyQuadImageTilesLayer *layer = [[MaplyQuadImageTilesLayer alloc] initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
        [mapViewC addLayer:layer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
