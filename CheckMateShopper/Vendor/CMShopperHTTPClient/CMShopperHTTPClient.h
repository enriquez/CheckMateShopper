//
//  CMShopperHTTPClient.h
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMShopperHTTPClient : NSObject
+ (CMShopperHTTPClient *)sharedInstance;
- (void)listItemsOnComplete:(void(^)(NSArray *items, NSError *error))completeBlock;
- (void)createItemWithName:(NSString *)name category:(NSString *)category onComplete:(void(^)(NSDictionary *item, NSError *error))completeBlock;
- (void)updateItemWithId:(NSString *)itemId name:(NSString *)name category:(NSString *)category onComplete:(void(^)(NSDictionary *item, NSError *error))completeBlock;
- (void)deleteItemWithId:(NSString *)itemId onComplete:(void(^)(NSError *error))completeBlock;

//- (void)createItem:(CMItem *)item onComplete:(void(^)(CMItem *item, NSError *error))completeBlock;
//- (void)updateItem:(CMItem *)item onComplete:(void(^)(CMItem *item, NSError *error))completeBlock;
@end
