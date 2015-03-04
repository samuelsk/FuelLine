//
//  ViewController.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 02/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "FiltroTableViewController.h"
#import "Posto.h"

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
    
    _matchingItems = [[NSMutableArray alloc] initWithCapacity:10];
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"Nenhum posto encontrado.");
        else
            for (MKMapItem *item in response.mapItems) {
                Posto *posto = [[Posto alloc] initWithBandeira:item.name andCoordenadas:item.placemark.coordinate andPrecoGas:arc4random_uniform(3)+1 andPrecoAlc:arc4random_uniform(3)+1];
                [_matchingItems addObject:posto];
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = posto.coordenadas;
                annotation.title = posto.bandeira;
                annotation.subtitle = [posto getDescricao];
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
        FiltroTableViewController *filtroTableController = [segue destinationViewController];
        
        filtroTableController.matchingItems = [[NSMutableArray alloc] initWithArray:_matchingItems];
    }
}

@end
