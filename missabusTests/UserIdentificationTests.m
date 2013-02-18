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

- (void) testUserIdentificationIsSingleton {
	UserIdentification *ident = [UserIdentification instance];
	UserIdentification *ident2 = [UserIdentification instance];
	STAssertEquals(ident, ident2, @"Different variables should point to the same instance");
}

- (void) testUuidShouldStaySameOverMultipleInvocations {
	UserIdentification *ident = [UserIdentification instance];
	STAssertNotNil([ident userId], @"UUID should be generated for the user");
	STAssertEquals([ident userId], [ident userId], @"UUID should remain the same on multiple invocations");
}

- (void) testGetEmptyLinesOfInterest {
	STFail(@"not implemented yet");
}

- (void) testSetLinesOfInterestShouldChangeGetResult {
	STFail(@"not implemented yet");
}

@end
