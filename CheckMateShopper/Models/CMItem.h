//
//  CMItem.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CMItem : NSManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *category;

+ (CMItem *)findOrBuildById:(NSString *)itemId inContext:(NSManagedObjectContext *)context;
- (id)initWithContext:(NSManagedObjectContext *)context;
- (void)unpackDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
