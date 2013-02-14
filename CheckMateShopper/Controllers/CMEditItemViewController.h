//
//  CMEditItemViewController.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMEditItemViewController : UIViewController
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)deleteItem:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) CMItem *item;
@end
