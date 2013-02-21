//
//  UserIdentificationTests.m
//  missabus
//
//  Created by Jaakko Santala on 2/18/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "UserIdentificationTests.h"
#import "UserIdentification.h"

@implementation UserIdentificationTests

@synthesize ident;

- (void) setUp {
	[super setUp];
	
	ident = [UserIdentification instance];
}

- (void) testUserIdentificationIsSingleton {
	UserIdentification *ident2 = [UserIdentification instance];
	STAssertEquals(ident, ident2, @"Different variables should point to the same instance");
}

- (void) testUuidShouldStaySameOverMultipleInvocations {
	STAssertNotNil([ident userId], @"UUID should be generated for the user");
	STAssertEquals([ident userId], [ident userId], @"UUID should remain the same on multiple invocations");
}

- (void) testGetEmptyLinesOfInterest {
	// Interesting problem arose by using code such as [ident.propertyStore.properties setObject:@"blaa" forKey:@"lof"]-> unrecognized selector etc.
	// this should be tested further
	NSString *key = @"lof";
	[ident.propertyStore.properties removeObjectForKey:key];

	NSArray *linesOfInterest = [ident linesOfInterest];
	STAssertEquals([linesOfInterest count], (NSUInteger) 0, @"Lines of interest should be empty");
}

- (void) testSetLinesOfInterestShouldChangeGetResult {
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"505", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Helsinki - Joku", @"name", nil];
	NSMutableArray *linesOfInterest = [NSMutableArray arrayWithObjects:line, line2, nil];
	
	[ident linesOfInterest: linesOfInterest];

	NSArray *result = [ident linesOfInterest];
	STAssertTrue([result count] == 2, @"Array size has changed to correct one");
	line = [result objectAtIndex: 0];
	line2 = [result objectAtIndex: 1];
	STAssertTrue([[line objectForKey: @"code"] isEqualToString: @"195"], @"dictionary keys must match with JSON input");
	STAssertTrue([[line objectForKey: @"transportType"] isEqualToString: @"12"], @"dictionary keys must match with JSON input");
}

- (void) testAdditionToLinesOfInterestFailsWhenNewItemDuplicated {
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"505", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Helsinki - Joku", @"name", nil];
	NSArray *original = [NSArray arrayWithObjects:line, line2, nil];
	
	[ident linesOfInterest: original];
	STAssertEquals([[ident linesOfInterest] count], (NSUInteger) 2, @"lines of interest size should match");
	
	[ident addLineOfInterest: line2];
	STAssertEquals([[ident linesOfInterest] count], (NSUInteger) 2, @"lines of interest size should not change when adding a duplicate");
}

- (void) testAdditionToLinesOfInterestSucceeds {
	NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys: @"195", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Keskusta - Espoo", @"name", nil];
	NSDictionary *line2 = [NSDictionary dictionaryWithObjectsAndKeys: @"505", @"code", @"19", @"shortCode",  @"12", @"transportType", @"Helsinki - Joku", @"name", nil];
	NSArray *original = [NSArray arrayWithObjects:line, line2, nil];
	
	[ident linesOfInterest: original];
	STAssertEquals([[ident linesOfInterest] count], (NSUInteger) 2, @"lines of interest size should match");

	NSDictionary *newLine = [NSDictionary dictionaryWithObjectsAndKeys: @"505", @"code", @"256", @"shortCode",  @"12", @"transportType", @"Helsinki - Joku", @"name", nil];

	[ident addLineOfInterest: newLine];
	STAssertEquals([[ident linesOfInterest] count], (NSUInteger) 3, @"lines of interest size should change when adding a new line");
}

@end
