//
//  Posto.h
//  FuelLine
//
//  Created by Samuel Shin Kim on 04/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Posto : NSObject {
    NSString *descricao;
}

@property NSString* bandeira;
@property CLLocationCoordinate2D coordenadas;
@property short precoGas, precoAlc;

- (instancetype) initWithBandeira:(NSString *)newBandeira andCoordenadas:(CLLocationCoordinate2D)newCoordenadas andPrecoGas:(short)newPrecoGas andPrecoAlc:(short)newPrecoAlc;
- (NSString *)getDescricao;

@end