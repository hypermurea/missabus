//
//  missabusTests.m
//  missabusTests
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "missabusTests.h"

@implementation missabusTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testArrayAndDictionaryToJson {
	// structure of JSON data:
	// [ {code: "xx", shortCode: "xx", transportType:"xx", name:"linename"} ... ]
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"1411", @"code", @"14", @"shortCode", @"13", @"transportType", @"Keskusta - Pitäjänmäki", @"name", nil];
	[array addObject: line];
	[array addObject: line2];
	
	NSError *error;
	NSData* json = [NSJSONSerialization dataWithJSONObject:array  options:0 error:&error];
	
	NSString *result = [[NSString alloc] initWithData:json
											 encoding:NSUTF8StringEncoding];
	
	NSLog(@"dict:\n%@", result);
	STAssertNotNil(result, @"array/dicst conversion to JSON should have a result");
}

@end
