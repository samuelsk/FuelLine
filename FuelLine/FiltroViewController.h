//
//  FiltroViewController.h
//  FuelLine
//
//  Created by Guilherme on 03/03/15.
//  Copyright (c) 2015 Samuel Shin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltroViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>

@property NSArray *matchingItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<FirstViewDelegate> delegate;

- (IBAction)voltar:(id)sender;
- (IBAction)filtrar:(id)sender;
- (void)tracarRota:(id)sender;


@end
