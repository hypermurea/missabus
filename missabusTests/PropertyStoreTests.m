//
//  PropertyStoreTests.m
//  missabus
//
//  Created by Jaakko Santala on 2/18/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "PropertyStoreTests.h"
#import "PropertyStore.h"

@implementation PropertyStoreTests

- (void) testPropertyFilePath {
	STAssertNotNil([PropertyStore propertyFilePath], @"Property file path needs to be defined");
}

- (void) testPropertyStored {
	PropertyStore *store = [[PropertyStore alloc] init];
	NSString *key = @"testing";
	NSString *value = @"valueland";
	[store.properties setObject:value forKey:key];
	
	STAssertNotNil(store.properties, @"Dictionary should be initialized");
	STAssertNotNil([store.properties objectForKey: key], @"PropertyStore key+value should be set");
}

- (void) testSaveAndLoadProperties {
	PropertyStore *store = [[PropertyStore alloc] init];
	NSString *key = @"testing";
	NSString *value = @"valueland";
	[store.properties setObject:value forKey:key];
	[store save]; // Note that the property file is actually persisted on the simulator, so the file can already exist when the test is run

	PropertyStore *store2 = [[PropertyStore alloc] init];
	
	NSString *notStoredKey = @"notstoredkey";
	[store.properties setObject:value forKey:notStoredKey];
	
	STAssertNotNil(store.properties, @"Dictionary should be initialized");
	STAssertNotNil([store.properties objectForKey: key], @"PropertyStore key+value should be set");
	
	STAssertNotNil([store.properties objectForKey: key], @"PropertyStore properties should be acquired from file");
	STAssertNil([store2.properties objectForKey: notStoredKey], @"Properties that have not been persisted should not be included in a new instance");

}

- (void) testSetAndSave {
	PropertyStore *store = [[PropertyStore alloc] init];
	NSString *key = @"setandsave";
	NSString *value = @"autosaved";
	[store setAndSave: key value: value];
	STAssertEquals(value, [store.properties objectForKey: key], @"Property should have been set");
}

@end
