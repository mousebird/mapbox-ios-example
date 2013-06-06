//
//  MaplyViewController.h
//  MapBox Example
//
//  Created by Steve Gifford on 6/6/13.
//  Copyright (c) 2013 MapBox / Development Seed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaplyMapViewController : UIViewController

// Use this basemap, local or remote
@property (nonatomic) NSString *baseMap;
// Set if this is a remote basemap
@property (nonatomic) bool remoteBaseMap;

@end
