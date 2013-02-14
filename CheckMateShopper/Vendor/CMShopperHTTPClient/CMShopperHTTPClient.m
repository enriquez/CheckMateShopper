//
//  CMShopperHTTPClient.m
//  CheckMateShopper
//
//  Created by Michael Enriquez on 2/13/13.
//  Copyright (c) 2013 Mike Enriquez. All rights reserved.
//

#import "CMShopperHTTPClient.h"

@interface CMShopperHTTPClient()
@property (nonatomic, strong) NSURL *baseUrl;
@property (nonatomic, strong) NSString *token;
@end

@implementation CMShopperHTTPClient

+ (CMShopperHTTPClient *)sharedInstance
{
	static CMShopperHTTPClient *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.baseUrl = [NSURL URLWithString:@"http://cmshopper.herokuapp.com"];
        self.token = @"56ef17da1442a79a1011388cdb390857";
    }
    
    return self;
}

- (void)listItemsOnComplete:(void(^)(NSArray *items, NSError *error))completeBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseUrl URLByAppendingPathComponent:@"items.json"]];
    request.HTTPMethod = @"GET";
    [request setValue:self.token forHTTPHeaderField:@"X-CM-Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completeBlock(nil, error);
        } else {
            NSArray *items = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completeBlock(items, nil);
        }
    }];
}

- (void)createItemWithName:(NSString *)name category:(NSString *)category onComplete:(void(^)(NSDictionary *item, NSError *error))completeBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseUrl URLByAppendingPathComponent:@"items.json"]];
    request.HTTPMethod = @"POST";
    [request setValue:self.token forHTTPHeaderField:@"X-CM-Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSDictionary *itemJsonData = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", category, @"category", nil];
    NSDictionary *topLevelItemData = [NSDictionary dictionaryWithObject:itemJsonData forKey:@"item"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:topLevelItemData options:0 error:nil];
    
    request.HTTPBody = jsonData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completeBlock(nil, error);
        } else {
            NSDictionary *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completeBlock(item, nil);
        }
    }];
}

- (void)updateItemWithId:(NSString *)itemId name:(NSString *)name category:(NSString *)category onComplete:(void(^)(NSDictionary *item, NSError *error))completeBlock
{
    NSString *path = [NSString stringWithFormat:@"items/%@.json", itemId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseUrl URLByAppendingPathComponent:path]];
    request.HTTPMethod = @"PUT";
    [request setValue:self.token forHTTPHeaderField:@"X-CM-Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSDictionary *itemJsonData = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", category, @"category", nil];
    NSDictionary *topLevelItemData = [NSDictionary dictionaryWithObject:itemJsonData forKey:@"item"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:topLevelItemData options:0 error:nil];
    
    request.HTTPBody = jsonData;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completeBlock(nil, error);
        } else {
            NSDictionary *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            completeBlock(item, nil);
        }
    }];
}

- (void)deleteItemWithId:(NSString *)itemId onComplete:(void(^)(NSError *error))completeBlock;
{
    NSString *path = [NSString stringWithFormat:@"items/%@.json", itemId];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseUrl URLByAppendingPathComponent:path]];
    request.HTTPMethod = @"DELETE";
    [request setValue:self.token forHTTPHeaderField:@"X-CM-Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            completeBlock(error);
        } else {
            completeBlock(nil);
        }
    }];
}

@end
