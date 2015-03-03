//
//  ViewController.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 02/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "FiltroTableViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", [locations lastObject]);
    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [_mapView setRegion:region animated:YES];
    _mapView.showsUserLocation=YES;
    [locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Erro.");
}

- (IBAction)marcar:(id)sender {
    [_mapView removeAnnotations:_mapView.annotations];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"Fuel";
    request.region = _mapView.region;
    
    _matchingItems = [[NSMutableArray alloc] init];
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"Nenhum posto encontrado.");
        else
            for (MKMapItem *item in response.mapItems) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = item.placemark.coordinate;
                annotation.title = item.name;
                NSNumber *precoGas = [[NSNumber alloc] initWithDouble:arc4random_uniform(4)];
                NSNumber *precoAlc = [[NSNumber alloc] initWithDouble:arc4random_uniform(4)];
                annotation.subtitle = (@"Gasolina/Álcool: %g/%g");
                [_precosGas addObject:precoGas];
                [_precosAlc addObject:precoAlc];
                [_matchingItems addObject:item];
                [_mapView addAnnotation:annotation];
            }
    }];
    
}

- (IBAction)centralizar:(id)sender {
    [locationManager startUpdatingLocation];
}

- (IBAction)limpar:(id)sender {
     [_mapView removeAnnotations:_mapView.annotations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"filtroTableView"]) {
        FiltroTableViewController *filtroTableController = [[FiltroTableViewController alloc] init];
        
        filtroTableController.matchingItems = [[NSMutableArray alloc] initWithArray:_matchingItems];
    }
}

@end
