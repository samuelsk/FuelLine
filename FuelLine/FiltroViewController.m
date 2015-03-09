//
//  FiltroViewController.m
//  FuelLine
//
//  Created by Guilherme on 03/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FirstViewController.h"
#import "FiltroViewController.h"
#import "FiltroTableViewCell.h"
#import "DescricaoViewController.h"
#import "Posto.h"


@interface FiltroViewController ()

@end


@implementation FiltroViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _matchingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiltroTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"FiltroTableCell" forIndexPath:indexPath];
    Posto *posto = _matchingItems[[indexPath row]];
    cell.bandeira.text = posto.bandeira;
    cell.precoGas.text = [NSString stringWithFormat:@"R$%.4g", posto.precoGas];
    cell.precoAlc.text = [NSString stringWithFormat:@"R$%.4g", posto.precoAlc];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//Método que será executado durante a transição de uma view para a próxima.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //É criada uma instância da próxima view para que seus atributos sejam acessíveis.
    DescricaoViewController *descricaoViewController = [segue destinationViewController];
    //É criada uma instância desta view para que ela possa se atribuir como uma delegate.
    FirstViewController *firstViewController = [segue sourceViewController];
    descricaoViewController.delegate = firstViewController;
    //O posto de gasolina representado pela célula selecionada é passado para a próxima view.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    descricaoViewController.posto = _matchingItems[[indexPath row]];
}

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

//Método que exibe um menu quando o botão for selecionado.
- (IBAction)filtrar:(id)sender {
    //O menu é configurado com um título e opções, ordenadas a partir do índice 0 (i.e. Gasolina seria 0 e Álcool seria 1).
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Filtrar por:" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Gasolina", @"Álcool", nil];
    //O menu é exibido.
    [actionSheet showInView:self.view];
}

//Método executado quando o usuário faz uma seleção após abrir o menu 'Filtrar', incluindo fora do menu.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 || buttonIndex == 1) {
        [self ordenar:buttonIndex];
        [self.tableView reloadData];
    }
}

//Método que ordena o vetor de postos de gasolina com base no atributo precoGas ou precoAlc, dependendo do parâmetro enviado.
- (void)ordenar:(NSInteger)buttonIndex{
    _matchingItems = [_matchingItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        double first, second;
        if (buttonIndex == 0) {
            first = [(Posto *)obj1 precoGas];
            second = [(Posto *)obj2 precoGas];
        } else {
            first = [(Posto *)obj1 precoAlc];
            second = [(Posto *)obj2 precoAlc];
        }
        if (first > second)
            return NSOrderedDescending;
        if (first < second)
            return NSOrderedAscending;
        return NSOrderedSame;
    }];
}

- (void)tracarRota:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.delegate tracarRota:_matchingItems[[indexPath row]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
