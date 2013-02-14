//
//  CMCategory.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CMItem;

@interface CMCategory : NSManagedObject <NSFetchedResultsSectionInfo>

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface CMCategory (CoreDataGeneratedAccessors)

+ (CMCategory *)findOrBuildByName:(NSString *)name inContext:(NSManagedObjectContext *)context;
- (id)initWithContext:(NSManagedObjectContext *)context;

- (void)insertObject:(CMItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(CMItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(CMItem *)value;
- (void)removeItemsObject:(CMItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
