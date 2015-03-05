//
//  FiltroTableViewController.m
//  FuelLine
//
//  Created by Guilherme on 03/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import "FiltroViewController.h"
#import "FirstViewController.h"
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FiltroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FiltroTableCell" forIndexPath:indexPath];
    Posto *posto = _matchingItems[[indexPath row]];
    cell.nomeBandeira.text = posto.bandeira;
    cell.precoGas.text = [NSString stringWithFormat:@"%.4g", posto.precoGas];
    cell.precoAlc.text = [NSString stringWithFormat:@"%.4g", posto.precoAlc];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DescricaoViewController *descricaoViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    descricaoViewController.posto = _matchingItems[[indexPath row]];
}

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.


- (IBAction)voltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)filtrar:(id)sender {
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Filtrar por:" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Gasolina", @"Álcool", @"Bandeira", nil];
    
    
    
    [actionSheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0 || buttonIndex ==1) {
        [self ordenar:buttonIndex];
        [self.tableView reloadData];
    }
}


- (void)ordenar:(NSInteger)buttonIndex{
    _matchingItems = [_matchingItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        double first, second;
        if (buttonIndex==0) {
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



@end
