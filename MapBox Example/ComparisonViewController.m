//
//  ComparisonViewController.m
//  MapBox Example
//
//  Created by Steve Gifford on 5/29/13.
//  Copyright (c) 2013 MapBox / Development Seed. All rights reserved.
//

#import "OnlineLayerViewController.h"
#import "OfflineLayerViewController.h"
#import "InteractiveLayerViewController.h"
#import "ComparisonViewController.h"
#import "MaplyMapViewController.h"

@interface ComparisonViewController ()

@end

@implementation ComparisonViewController
{
    UITableView *tableView;
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

    self.title = @"Select Renderer";
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor grayColor];
    tableView.separatorColor = [UIColor whiteColor];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.view.autoresizesSubviews = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"route-me";
            break;
        case 1:
            cell.textLabel.text = @"route-me + Maply";
            break;
        case 2:
            cell.textLabel.text = @"Maply only";
            break;
        default:;
            break;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}

#pragma mark - Table Delegate

static NSString *MaplyTileSources[3] = {@"examples.map-z2effxa8",@"control-room-0.2.0",@"examples.map-zmy97flj"};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 2)
    {
        // Fire up the Maply view controllers for this one
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.title = @"Maply only";
        NSMutableArray *viewControllers = [NSMutableArray array];
        
        int which = 0;
        for (NSString *typeString in [NSArray arrayWithObjects:@"online", @"offline", @"interactive", nil])
        {
            // This option just has the one view controller
            MaplyMapViewController *maplyViewC = [[MaplyMapViewController alloc] init];
            maplyViewC.baseMap = MaplyTileSources[which];
            maplyViewC.remoteBaseMap = (which == 1) ? false : true;

            maplyViewC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Layer", [typeString capitalizedString]]
                                                                      image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", typeString]]
                                                                        tag:0];
            
            [viewControllers addObject:maplyViewC];
            which++;
        }
        
        tabBarController.viewControllers = viewControllers;
        
        
        [self.navigationController pushViewController:tabBarController animated:YES];
    } else {
        // Use the combo or route-me exclusive controllers here
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        tabBarController.title = (indexPath.row == 0 ? @"route-me renderer" : @"Maply renderer");
        
        NSMutableArray *viewControllers = [NSMutableArray array];
        
        for (NSString *typeString in [NSArray arrayWithObjects:@"online", @"offline", @"interactive", @"shape", nil])
        {
            Class ViewControllerClass = NSClassFromString([NSString stringWithFormat:@"%@LayerViewController", [typeString capitalizedString]]);
            
            BaseViewController *viewController = [[ViewControllerClass alloc] initWithNibName:nil bundle:nil];
            switch (indexPath.row)
            {
                case 0:
                default:
                    viewController.renderingMode = RouteMeModeOld;
                    break;
                case 1:
                    viewController.renderingMode = RouteMeModeMaply;
                    break;
            }
            
            viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSString stringWithFormat:@"%@ Layer", [typeString capitalizedString]]
                                                                      image:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", typeString]]
                                                                        tag:0];
            
            [viewControllers addObject:viewController];
        }
        
        tabBarController.viewControllers = viewControllers;
            
        
        [self.navigationController pushViewController:tabBarController animated:YES];
    }
}

@end
