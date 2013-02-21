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

- (void)testArrayAndDictionariesToJson {
	// structure of JSON data:
	// [ {code: "xx", shortCode: "xx", transportType:"xx", name:"linename"} ... ]
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"1411", @"code", @"14", @"shortCode", @"13", @"transportType", @"Keskusta - Pitäjänmäki", @"name", nil];
	[array addObject: line];
	[array addObject: line2];
	
	NSError *error;
	NSData* json = [NSJSONSerialization dataWithJSONObject:array  options:kNilOptions error:&error];
	
	NSString *result = [[NSString alloc] initWithData:json
											 encoding:NSUTF8StringEncoding];
	
	NSLog(@"dict:\n%@", result);
	STAssertNotNil(result, @"array/dicst conversion to JSON should have a result");
}

- (void)testJsonToArrayAndDictionaries {
	NSString *json = @"[{\"code\":\"195\",\"transportType\":\"12\",\"name\":\"Keskusta - Espoo\",\"shortCode\":\"19\"},{\"code\":\"1411\",\"transportType\":\"13\",\"name\":\"Keskusta - Pitäjänmäki\",\"shortCode\":\"14\"}]";
	
	NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	STAssertTrue([array count] == 2, @"JSON array elements converted to NSArray elements");
	NSDictionary *line = [array objectAtIndex: 0];
	NSDictionary *line2 = [array objectAtIndex: 1];
	STAssertTrue([[line objectForKey:@"code"] isEqualToString: @"195"], @"json dictionary values must match");
	STAssertTrue([[line2 objectForKey:@"transportType"] isEqualToString: @"13"], @"json dictionary values must match");
}

@end
