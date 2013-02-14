//
//  CMItemListViewController.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMItemListViewController.h"
#import "CMNewItemViewController.h"
#import "CMEditItemViewController.h"
#import "CMAppDelegate.h"

@interface CMItemListViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)synchronizeWithServerOnComplete:(void(^)(NSError *error))completeBlock;
@end

@implementation CMItemListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];

    self.context = ((CMAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    [self.fetchedResultsController performFetch:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self synchronizeWithServerOnComplete:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    _table = nil;
    _context = nil;
    _fetchedResultsController = nil;
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:@"CMItem" inManagedObjectContext:self.context];
    fetchRequest.fetchBatchSize = 30;
    fetchRequest.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.context
                                                                      sectionNameKeyPath:@"category.name"
                                                                               cacheName:nil];
    _fetchedResultsController.delegate = self;
        
	return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *sections = [self.fetchedResultsController sections];
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [self.fetchedResultsController sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return sectionInfo.name;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.table beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    UITableView *tableView = self.table;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
                [self configureCell:(UITableViewCell *)[self.table cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.table endUpdates];
    [self.table reloadData];
}

#pragma mark - UIViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(segue.identifier) withObject:segue.destinationViewController];
#pragma clang diagnostic pop
}

#pragma mark - Prepare for segue methods

- (void)prepareNewItemViewController:(CMNewItemViewController *)newItemViewController
{
    newItemViewController.context = self.context;
}

- (void)prepareEditItemViewController:(CMEditItemViewController *)editItemViewController
{
    CMItem *item = (CMItem *)[self.fetchedResultsController objectAtIndexPath:[self.table indexPathForSelectedRow]];
    editItemViewController.item = item;
    editItemViewController.context = self.context;
}

#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CMItem *item = (CMItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
}

- (void)synchronizeWithServerOnComplete:(void(^)(NSError *error))completeBlock;
{
    CMShopperHTTPClient *httpClient = [CMShopperHTTPClient sharedInstance];
    [httpClient listItemsOnComplete:^(NSArray *items, NSError *error) {
        if (error) {
            NSLog(@"TODO: alert");
        } else {
            for (NSDictionary *itemJson in items) {
                NSString *itemId = [itemJson objectForKey:@"id"];
                CMItem *item = [CMItem findOrBuildById:itemId inContext:self.context];
                [item unpackDictionary:itemJson inContext:self.context];
            }
            
            [self.context save:nil];
            [self.fetchedResultsController performFetch:nil];
        }
        
        if (completeBlock) completeBlock(error);
    }];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    [self synchronizeWithServerOnComplete:^(NSError *error) {
        [refreshControl endRefreshing];
    }];
}

@end
