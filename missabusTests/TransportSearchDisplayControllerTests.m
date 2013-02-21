//
//  TransportSearchDisplayControllerTests.m
//  missabus
//
//  Created by Jaakko Santala on 2/20/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "TransportSearchDisplayControllerTests.h"
#import "TransportSearchDisplayController.h"
#import "Constants.h"

@implementation TransportSearchDisplayControllerTests

@synthesize controller;

- (void) setUp {
	controller = [[TransportSearchDisplayController alloc] init];
}

- (void) testQueryDoesNotBreakWithCharactersThatNeedEscaping {
	[controller startTransportLineQuery: @"/&?blaa"];
}

- (void) testWhenConnectionFailsWithErrorResultsAreCleared {
	STAssertNil([controller getCurrentQueryResults], @"Query result should be nil before any queries have been performed");
	[controller connection: nil didFailWithError: nil];
	STAssertEquals([[controller getCurrentQueryResults] count], (NSUInteger) 0, @"Query result should be empty after connection has failed");
}

- (void) testWhenResponseIsEmptyResultsAreCleared {
	[controller connection:nil didReceiveResponse:nil];
	[controller connection:nil didReceiveData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
	[controller connectionDidFinishLoading:nil];
	
	STAssertEquals([[controller getCurrentQueryResults] count], (NSUInteger) 0, @"Empty response is possible, and should be correctly parsed as an empty NSArray");
}

- (void) testTransportTypeConvertedToCorrectImageName {
	STAssertEqualObjects(imageNameForTransportType(@"1"), BUS_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"2"), TRAM_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"8"), BUS_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"12"), TRAIN_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"5"), BUS_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"7"), FERRY_IMAGE, @"transport-type image mapping must be correct");
	STAssertEqualObjects(imageNameForTransportType(@"39"), BUS_IMAGE, @"transport-type image mapping must be correct");
}

- (void) testDuplicateTransportLinesRemovedCorrectly {
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"505", @"code_short",  @"12", @"transport_type_id", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"504", @"code_short",  @"14", @"transport_type_id", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line3 = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"505", @"code_short",  @"12", @"transport_type_id", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line4 = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"506", @"code_short",  @"14", @"transport_type_id", @"Keskusta - Espoo", @"name", nil];
	NSMutableArray *lines = [NSMutableArray arrayWithObjects:line, line2, line3, line4, nil];
	
	removeDuplicateTransportLines(lines);
	
	STAssertEquals([lines count], (NSUInteger) 3, @"One duplicate line should be removed from array");
	STAssertEquals([lines objectAtIndex:0], line, @"First version of duplicate should remain in array");
	STAssertEquals([lines objectAtIndex:1], line2, @"Unique lines should remain in array");
	STAssertEquals([lines objectAtIndex:2], line4, @"Unique lines should remain in array");
}

// TODO implementation of NSURLConnection use has changed, this method needs to be refactored appropriately
- (void) testWhenConnectionFinishedCurrentResultsParsedFromResponseJson {
	/*
	 NSString *chunk1 = @"[{\"code\":\"1018  1\",\"code_short\":\"18\",\"transport_type_id\":1,\"name\":\"Eira - Kamppi - Munkkivuori\"},{\"code\":\"1018  2\",\"code_short\":\"18\",\"transport_type_id\":1,\"name\":";
	 NSString *chunk2 = @"\"Eira - Kamppi - Munkkivuori\"},{\"code\":\"2018  1\",\"code_short\":\"18\",\"transport_type_id\":3,\"name\":\"Tapiola-Kauniainen-Espoon keskus-Kauklahti\"},{\"code\":\"2018  2\",";
	 NSString *chunk3 = @"\"code_short\":\"18\",\"transport_type_id\":3,\"name\":\"Tapiola-Kauniainen-Espoon keskus-Kauklahti\"}]";
	 
	 [controller connection:nil didReceiveResponse:nil];
	 [controller connection:nil didReceiveData:[chunk1 dataUsingEncoding:NSUTF8StringEncoding]];
	 [controller connection:nil didReceiveData:[chunk2 dataUsingEncoding:NSUTF8StringEncoding]];
	 [controller connection:nil didReceiveData:[chunk3 dataUsingEncoding:NSUTF8StringEncoding]];
	 [controller connectionDidFinishLoading:nil];
	 
	 STAssertEquals([[controller getCurrentQueryResults] count], (NSUInteger) 4, @"Valid response JSON should be correctly parsed");
	 */
}

@end
