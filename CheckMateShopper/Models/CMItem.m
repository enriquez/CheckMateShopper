//
//  CMItem.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMItem.h"


@implementation CMItem

@dynamic itemId;
@dynamic name;
@dynamic category;

+ (CMItem *)findOrBuildById:(NSString *)itemId inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CMItem"];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"itemId = %@", itemId];
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    if (results.count > 0) {
        return [results objectAtIndex:0];
    } else {
        return [[CMItem alloc] initWithContext:context];
    }
}

- (id)initWithContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CMItem" inManagedObjectContext:context];
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    return self;
}

- (void)unpackDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    NSString *itemId       = [[dictionary objectForKey:@"id"] stringValue];
    NSString *itemName     = [dictionary objectForKey:@"name"];
    NSString *categoryName = [dictionary objectForKey:@"category"];
    
    CMCategory *category = [CMCategory findOrBuildByName:categoryName inContext:context];
    
    self.itemId   = itemId;
    self.name     = itemName;
    self.category = category;
}

@end
