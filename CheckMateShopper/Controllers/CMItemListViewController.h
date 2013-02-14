//
//  CMItemListViewController.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMItemListViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end
