//
//  ViewController.m
//  FuelLine
//
//  Created by Samuel Shin Kim on 02/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "FiltroViewController.h"
#import "DescricaoViewController.h"
#import "Annotation.h"
#define ARC4RANDOM_MAX      0x100000000

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //O MKMapView se atribui como delegate para permitir a atualização de annotations e rotas.
    [_mapView setDelegate:self];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:self];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    [_mapView.userLocation setTitle:@"Você"];
    //São criados dois vetores para guardar as informações de todos os postos de gasolina encontrados. O vetor matchingItems sempre terá no máximo 10 itens, enquanto que o foundItems poderá ter N valores.
    _matchingItems = [[NSMutableArray alloc] initWithCapacity:10];
    _foundItems = [[NSMutableArray alloc] init];
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Não foi possível encontrar sua localização.");
}

//Método que atribui limites para que o mapa preencha as bordas do aparelho, definindo o mapa com o mesmo tamanho mostrado na view.
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

//Método que irá marcar os postos de gasolina no mapa.
- (IBAction)marcar:(id)sender {
    //O método remove todos os postos encontrados antes de fazer uma nova busca.
    [_matchingItems removeAllObjects];
    //O método remove todas as annotations existentes antes de adicionar as novas.
    [_mapView removeAnnotations:_mapView.annotations];
    //É criado um MKLocalSearchRequest, que retém as informações necessárias para se inicializar uma busca por locais de negócio (i.e. business locations) registrados.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //Parâmetro de busca, no caso, todos os locais de negócio que possuam a tag seguinte.
    request.naturalLanguageQuery = @"Fuel";
    //Região de busca, no caso, o mapa inteiro.
    request.region = MKCoordinateRegionMakeWithDistance(_mapView.centerCoordinate, 1000, 1000);
    //É criado um MKLocalSearch, que é responsável por realizar a busca com base nos parâmetros atribuídos na request.
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    //Método que realiza a busca. Por padrão, o método busca por no máximo 10 locais de negócio.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        //O método irá parar a execução caso nenhum local de negócio seja encontrado.
        if (response.mapItems.count == 0)
            NSLog(@"Nenhum posto encontrado.");
        else {
            //O código seguinte irá executar apenas caso esta seja a primeira busca (i.e. o vetor foundItems estiver vazio).
            if (_foundItems.count == 0) {
                //Todos os itens encontrados são acessados.
                for (MKMapItem *item in response.mapItems) {
                    //É criado um objeto Posto para reter as informações do local de negócio encontrado, como nome, coordenadas, endereço e o preço (genérico) da gasolina e do álcool.
                    Posto *posto = [[Posto alloc] initWithBandeira:item.name andCoordenadas:item.placemark.coordinate andEndereco:item.placemark.thoroughfare andCep:item.placemark.postalCode andPrecoGas:(((double)arc4random() / ARC4RANDOM_MAX)* 3.0f)+1 andPrecoAlc:(((double)arc4random() / ARC4RANDOM_MAX)* 2.0f)+1];
                    //Cada objeto Posto é guardado em um vetor para uso futuro.
                    [_matchingItems addObject:posto];
                }
                //Todos os postos de gasolina encontrados são adicionados ao vetor foundItems.
                [_foundItems addObjectsFromArray:_matchingItems];
            } else {
                NSUInteger count = _foundItems.count;
                //Todos os itens encontrados são acessados.
                for (MKMapItem *item in response.mapItems) {
                    BOOL alreadyFound = NO;
                    //É verificado se o posto de gasolina encontrado já havia sido encontrado previamente. Se sim, ele manterá os valores originais. Se não, ele irá gerar valores genéricos para os preços.
                    //Obs.: Foi necessário um for simples porque o vetor foundItems pode aumentar de tamanho durante a execução do for, impossibilitando o for avançado.
                    for (int i = 0; i<count; i++) {
                        Posto *p = _foundItems[i];
                        if (p.coordenadas.latitude == item.placemark.coordinate.latitude &&
                            p.coordenadas.longitude == item.placemark.coordinate.longitude) {
                            [_matchingItems addObject:p];
                            alreadyFound = YES;
                        }
                    }
                    if (!alreadyFound) {
                        //É criado um objeto Posto para reter as informações do local de negócio encontrado, como nome, coordenadas, endereço e o preço (genérico) da gasolina e do álcool.
                        Posto *posto = [[Posto alloc] initWithBandeira:item.name andCoordenadas:item.placemark.coordinate andEndereco:item.placemark.thoroughfare andCep:item.placemark.postalCode andPrecoGas:(((double)arc4random() / ARC4RANDOM_MAX)* 3.0f)+1 andPrecoAlc:(((double)arc4random() / ARC4RANDOM_MAX)* 2.0f)+1];
                        [_matchingItems addObject:posto];
                        //O novo posto é guardado em um vetor para evitar que novos valores aleatórios sejam gerados em buscas futuras.
                        [_foundItems addObject:posto];
                    }
                }
            }
            //É adicionada um pino para cada posto de gasolina encontrado e guardado no vetor.
            for (Posto *p in _matchingItems) {
                //É criada uma annotation para adicionar os pinos no mapa com base nos parâmetros dados.
                Annotation *annotation = [[Annotation alloc] init];
                annotation.coordinate = p.coordenadas;
                annotation.title = p.bandeira;
                annotation.subtitle = [p getDescricao];
                //Método que adiciona a annotation no mapa.
                [_mapView addAnnotation:annotation];
            }
        }
    }];
}

//Método que irá centralizar o mapa na posição atual do usuário.
- (IBAction)centralizar:(id)sender {
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

//Método que irá remover obstruções visuais no mapa, como as annotations e as rotas.
- (IBAction)limpar:(id)sender {
    [_mapView removeOverlays:[_mapView overlays]];
    [_mapView removeAnnotations:_mapView.annotations];
}

//Método que encontra o posto de gasolina com o preço de gasolina mais barato.
- (IBAction)encontrarBarato:(id)sender {
    if (!_matchingItems.count == 0) {
        Posto *barato = _matchingItems.firstObject;
        for (Posto *p in _matchingItems) {
            if (p.precoGas < barato.precoGas)
                barato = p;
        }
        [self tracarRota:barato];
        [_mapView removeAnnotations:_mapView.annotations];
        Annotation *annotation = [[Annotation alloc] init];
        annotation.coordinate = barato.coordenadas;
        annotation.title = barato.bandeira;
        annotation.subtitle = [barato getDescricao];
        //Método que adiciona o pino no mapa.
        [_mapView addAnnotation:annotation];
    }
}

//Método que será executado durante a transição de uma view para a próxima.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //É feita uma verificação de identificação para saber qual view está sendo acessada.
    if ([[segue identifier] isEqualToString:@"filtroViewSegue"]) {
        //É criada uma instância da próxima view para que seus atributos sejam acessíveis.
        FiltroViewController *filtroTableController = [segue destinationViewController];
        //É criada uma instância desta view para que ela possa se atribuir como uma delegate.
        FirstViewController *firstViewController = [segue sourceViewController];
        filtroTableController.delegate = firstViewController;
        //O vetor com as informações dos postos de gasolina encontrados é passado para a próxima view. Caso nenhum posto seja encontrado, é passado um vetor nulo.
        filtroTableController.matchingItems = [[NSMutableArray alloc] initWithArray:_matchingItems];
    }
    if ([[segue identifier] isEqualToString:@"descricaoViewSegue"]) {
        DescricaoViewController *descricaoViewController = [segue destinationViewController];
        FirstViewController *firstViewController = [segue sourceViewController];
        descricaoViewController.delegate = firstViewController;
        descricaoViewController.posto = _posto;
    }
}

//Método que será executado quando uma annotation for adicionada no mapa.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *pinView = nil;
    //O método apenas continuará a execução caso a annotation adicionada for diferente da que mostra a localização atual do usuário.
    if(annotation != mapView.userLocation) {
        //É criado um identificador para determinar que o pino é um pino personalizado.
        static NSString *defaultPinID = @"com.invasivecode.pin";
        //É criada uma MKAnnotationView para determinar o que será mostrado quando um pino for selecionado.
        pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        //Caso o balão do pino esteja vazio (o que sempre será o caso) ela será preenchida com a annotation que está sendo adicionada no mapa.
        if (pinView == nil)
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
        //É criado um botão para ser adicionado no balão do pino.
        UIButton *buttonRota = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //É adicionada uma imagem no botão.
        UIImage *img = [UIImage imageNamed:@"carro.png"];
        [buttonRota setImage:img forState:UIControlStateNormal];
        //É adicionado o botão no pino.
        pinView.leftCalloutAccessoryView = buttonRota;
        UIButton *info = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        img = [UIImage imageNamed:@"rightarrow"];
        [info setImage:img forState:UIControlStateNormal];
        pinView.rightCalloutAccessoryView = info;
        pinView.canShowCallout = YES;
        //É adicionada uma imagem para sobrescrever a imagem padrão do pino. Caso existam múltiplas annotations, elas serão vermelhas. Caso exista apenas uma, ela será amarela.
        pinView.image = [UIImage imageNamed:@"redpin.png"];
        if (_mapView.annotations.count == 2) {
            pinView.image = [UIImage imageNamed:@"yellowpin.png"];
        }
        
    }
    return pinView;
}

//Método que será executado quando um objeto CalloutAccessoryView for selecionado.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    //A annotation que foi selecionada é guardada em um ponteiro.
    Annotation *annotation = view.annotation;
    Posto *p;
    //É encontrado o posto de gasolina selecionado dentre os postos de gasolina guardados no vetor.
    for (p in _matchingItems) {
        if (p.coordenadas.latitude == annotation.coordinate.latitude &&
            p.coordenadas.longitude == annotation.coordinate.longitude)
            break;
    }
    if (control == view.leftCalloutAccessoryView)
        [self tracarRota:p];
    else {
        _posto = p;
        [self performSegueWithIdentifier:@"descricaoViewSegue" sender:self];
    }
}

//Método que traça uma rota da localização atual do usuário ao posto de gasolina recebido como parâmetro.
- (void)tracarRota:(Posto *)p {
    //É criado um MKDirectionRequest, que retém as informações necessárias para se inicializar uma busca por rotas.
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    //No atributo source é guardada a origem da rota.
    request.source = [MKMapItem mapItemForCurrentLocation];
    //É criado um placemark que guarda as informações do posto de gasolina representado pela annotation selecionada, porque os atributos source e destination são do tipo MKMapItem, e um placemark é necessário para inicializar uma MKMapItem.
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:p.coordenadas addressDictionary:(NSDictionary *)@{(NSString *)kABPersonAddressStreetKey:p.endereco, (NSString *)kABPersonAddressZIPKey:p.cep}];
    //No atributo destination é guardado o destino da rota, no caso, o posto de gasolina recebido.
    request.destination = [[MKMapItem alloc] initWithPlacemark:placemark];
    //É criado um MKDirections, que é responsável por realizar a busca e o preenchimento de possíveis rotas entre a origem e o destino atribuídas na request.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //Método que calcula possíveis rotas.
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Falha em encontrar uma rota.");
        } else {
            [_mapView removeOverlays:[_mapView overlays]];
            //A sequência de rotas encontradas é adicionada no mapa.
            for (MKRoute *route in response.routes) {
                [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                [_mapView setVisibleMapRect:route.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0) animated:YES];
            }
            [_mapView removeAnnotations:[_mapView annotations]];
            Annotation *annotation = [[Annotation alloc] init];
            annotation.coordinate = p.coordenadas;
            annotation.title = p.bandeira;
            annotation.subtitle = [p getDescricao];
            [_mapView addAnnotation:annotation];
            [_mapView selectAnnotation:annotation animated:YES];
            }
        }];
}

//Método necessário para que um MKMapView consiga preencher as rotas no mapa com base nas características atribuídas no renderizador.
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}


@end
