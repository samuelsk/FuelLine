//
//  Posto.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 04/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "Posto.h"


@implementation Posto

@synthesize bandeira, coordenadas, endereco, cep, precoGas, precoAlc;

- (instancetype)initWithBandeira:(NSString *)newBandeira andCoordenadas:(CLLocationCoordinate2D)newCoordenadas andEndereco:(NSString *)newEndereco andCep:(NSString *)newCep  andPrecoGas:(double)newPrecoGas andPrecoAlc:(double)newPrecoAlc {
    
    self = [super init];
    bandeira = newBandeira;
    coordenadas = newCoordenadas;
    endereco = newEndereco;
    cep = newCep;
    precoGas = newPrecoGas;
    precoAlc = newPrecoAlc;
    return self;
}

- (NSString *)getDescricao {
    return [NSString stringWithFormat:@"Gasolina/Álcool: %f/%f", precoGas, precoAlc];
}

@end
