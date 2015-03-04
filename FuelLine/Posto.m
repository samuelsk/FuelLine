//
//  Posto.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 04/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "Posto.h"


@implementation Posto

@synthesize bandeira, coordenadas, precoGas, precoAlc;

- (instancetype)initWithBandeira:(NSString *)newBandeira andCoordenadas:(CLLocationCoordinate2D)newCoordenadas andPrecoGas:(short)newPrecoGas andPrecoAlc:(short)newPrecoAlc {
    
    self = [super init];
    bandeira = newBandeira;
    coordenadas = newCoordenadas;
    precoGas = newPrecoGas;
    precoAlc = newPrecoAlc;
    return self;
}

- (NSString *)getDescricao {
    return [NSString stringWithFormat:@"Gasolina/Álcool: %hd/%hd", precoGas, precoAlc];
}

@end
