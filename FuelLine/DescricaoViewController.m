//
//  DescricaoViewController.m
//  FuelLine
//
//  Created by Victor Lisboa on 04/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "DescricaoViewController.h"


@interface DescricaoViewController () <CLLocationManagerDelegate>

@end

@implementation DescricaoViewController{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _bandeira.text = _posto.bandeira;
    _endereco.text = [NSString stringWithFormat:@"%@, %@", _posto.endereco, _posto.cep];
    _precoGas.text = [NSString stringWithFormat:@"R$%.4g", _posto.precoGas];
    _precoAlc.text = [NSString stringWithFormat:@"R$%.4g", _posto.precoAlc];


    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Método que retorna a primeira view, no caso, a FirstViewController.
//- (IBAction)voltarMapa:(id)sender {
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//}

//Método que traça uma rota da localização atual do usuário ao posto de gasolina exibido.
- (IBAction)tracarRota:(id)sender {
    [self.delegate tracarRota:_posto];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


@end
