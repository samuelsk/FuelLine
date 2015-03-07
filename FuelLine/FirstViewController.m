//
//  ViewController.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 02/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "FiltroViewController.h"
#import "Annotation.h"
#import "Posto.h"
#define ARC4RANDOM_MAX      0x100000000

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_mapView setDelegate:self];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_mapView.userLocation setTitle:@"Você"];
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
                Posto *posto = [[Posto alloc] initWithBandeira:item.name andCoordenadas:item.placemark.coordinate andEndereco:item.placemark.thoroughfare andCep:item.placemark.postalCode andPrecoGas:(((double)arc4random() / ARC4RANDOM_MAX)* 3.0f)+1 andPrecoAlc:(((double)arc4random() / ARC4RANDOM_MAX)* 2.0f)+1];
                [_matchingItems addObject:posto];
                Annotation *annotation = [[Annotation alloc] init];
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
    if ([[segue identifier]isEqualToString:@"filtroViewSegue"]) {
        FiltroViewController *filtroTableController = [segue destinationViewController];
        filtroTableController.matchingItems = [[NSMutableArray alloc] initWithArray:_matchingItems];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation) {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if (pinView == nil)
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        UIButton *buttonRota = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImage *img = [UIImage imageNamed:@"carro.png"];
        [buttonRota setImage:img forState:UIControlStateNormal];
        pinView.leftCalloutAccessoryView = buttonRota;
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"redpin.png"];
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    Annotation *annotation = view.annotation;
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:(NSDictionary *)@{(NSString *)kABPersonAddressStreetKey:annotation.title}];
    request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Falha em encontrar uma rota.");
        } else {
            [_mapView removeOverlays:[_mapView overlays]];
            for (MKRoute *route in response.routes) {
                [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}



@end
