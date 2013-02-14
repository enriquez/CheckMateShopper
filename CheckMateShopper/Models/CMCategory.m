//
//  CMCategory.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMCategory.h"
#import "CMItem.h"


@implementation CMCategory

@dynamic name;
@dynamic items;

+ (CMCategory *)findOrBuildByName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CMCategory"];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    if (results.count > 0) {
        return [results objectAtIndex:0];
    } else {
        CMCategory *category = [[CMCategory alloc] initWithContext:context];
        category.name = name;
        return category;
    }
}

- (id)initWithContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMCategory" inManagedObjectContext:context];
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    return self;
}

#pragma mark - NSFetchedResultsSectionInfo properties

// name is already a property
//- (NSString *)name {}

- (NSString *)indexTitle
{
    return self.name;
}

- (NSUInteger)numberOfObjects
{
    return self.items.count;
}

- (NSArray *)objects
{
    return self.items.array;
}

@end
