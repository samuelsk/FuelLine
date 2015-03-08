//
//  DescricaoViewController.h
//  FuelLine
//
//  Created by Victor Lisboa on 04/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Posto.h"

@interface DescricaoViewController : UIViewController

@property Posto *posto;
@property (weak, nonatomic) IBOutlet UILabel *bandeira;
@property (weak, nonatomic) IBOutlet UILabel *endereco;
@property (weak, nonatomic) IBOutlet UILabel *precoGas;
@property (weak, nonatomic) IBOutlet UILabel *precoAlc;

- (IBAction)voltar:(id)sender;
- (IBAction)voltarMapa:(id)sender;
- (IBAction)tracarRota:(id)sender;

@end
