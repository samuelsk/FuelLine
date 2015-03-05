//
//  ViewController.h
//  FuelLine
//
//  Created by Samuel Shin Kim on 02/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    
}

@property NSMutableArray* matchingItems;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;



- (IBAction)marcar:(id)sender;
- (IBAction)centralizar:(id)sender;
- (IBAction)limpar:(id)sender;

@end