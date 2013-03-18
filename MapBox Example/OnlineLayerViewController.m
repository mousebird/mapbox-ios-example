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

#import <CoreLocation/CoreLocation.h>

#define kTintColor [UIColor colorWithRed:0.120 green:0.550 blue:0.670 alpha:1.000]

@interface OnlineLayerViewController ()

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) RMMapView *mapView;

@end

@implementation OnlineLayerViewController

@synthesize geocoder;
@synthesize searchBar;
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // geocoder & search bar
    //
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    self.searchBar.placeholder = @"123 Fifth Avenue Anytown, USA";
    
    self.searchBar.delegate = self;

    self.searchBar.tintColor = kTintColor;
    
    [self.view addSubview:searchBar];
    
    // map view
    //
    RMMapBoxSource *onlineSource = [[RMMapBoxSource alloc] initWithMapID:(([[UIScreen mainScreen] scale] > 1.0) ? kRetinaMapID : kNormalMapID)];

    self.mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, self.searchBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.searchBar.bounds.size.height) andTilesource:onlineSource];
    
    self.mapView.zoom = 2;
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.mapView];
    
    // tap gesture on map to dismiss search
    //
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    tap.delegate = self;
    
    [self.mapView addGestureRecognizer:tap];
}

#pragma mark -

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    [self.searchBar resignFirstResponder];
}

#pragma mark -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.geocoder cancelGeocode];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [self.mapView removeAllAnnotations];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [aSearchBar resignFirstResponder];
    
    [self.geocoder geocodeAddressString:aSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if ( ! placemarks)
        {
            [[[UIAlertView alloc] initWithTitle:@"Search Error"
                                       message:@"There was an error while performing the search. Please try again."
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:@"OK", nil] show];
        }
        else
        {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
            RMProjectedPoint projectedCenter = [self.mapView coordinateToProjectedPoint:firstPlacemark.location.coordinate];

            [self.mapView setProjectedBounds:RMProjectedRectMake(projectedCenter.x - (firstPlacemark.region.radius / 2), 
                                                                 projectedCenter.y - (firstPlacemark.region.radius / 2), 
                                                                 firstPlacemark.region.radius, 
                                                                 firstPlacemark.region.radius) 
                                    animated:NO];

            RMPointAnnotation *annotation = [RMPointAnnotation annotationWithMapView:self.mapView coordinate:self.mapView.centerCoordinate andTitle:[[firstPlacemark valueForKeyPath:@"addressDictionary.FormattedAddressLines"] componentsJoinedByString:@", "]];

            [self.mapView addAnnotation:annotation];

            [self.mapView selectAnnotation:annotation animated:YES];
        }
    }];
}

#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end