//
//  MainViewControllerTests.m
//  missabus
//
//  Created by Jaakko Santala on 2/21/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerTests.h"

@implementation MainViewControllerTests

- (void) testSearchResultConversionToLineOfInterest {
	NSString *code = @"koodia";
	NSString *shortCode = @"validshortcode";
	NSString *name = @"validnimi";
	NSString *transportType = @"123";
	
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  code, @"code",
						  shortCode, @"code_short",
						  name, @"name",
						  transportType, @"transport_type_id",
						  nil];
	
	NSDictionary *converted = convertSearchResultToLineOfInterest(dict);
	
	STAssertEqualObjects([converted objectForKey:@"code"], code, @"keys are converted correctly");
	STAssertEqualObjects([converted objectForKey:@"shortCode"], shortCode, @"keys are converted correctly");
	STAssertEqualObjects([converted objectForKey:@"transportType"], transportType, @"keys are converted correctly");
	STAssertEqualObjects([converted objectForKey:@"name"], name, @"keys are converted correctly");
}
	 
@end
