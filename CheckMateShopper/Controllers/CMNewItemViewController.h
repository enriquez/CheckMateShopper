//
//  CMNewItemViewController.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMNewItemViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
