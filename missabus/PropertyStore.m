//
//  PropertyStore.m
//  missabus
//
//  Created by Jaakko Santala on 2/18/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "PropertyStore.h"
#import "Constants.h"

@implementation PropertyStore

@synthesize properties;

- (id) init {
	self = [super init];
	if(self != nil) {
		properties = [[NSMutableDictionary alloc] initWithContentsOfFile: [PropertyStore propertyFilePath]];
	}
	return self;
}

- (BOOL) setAndSave:(NSString *)name value:(NSString *)value {
	[self.properties setObject: value forKey: name];
	return [self save];
}


- (BOOL) save {
	NSString *error;

	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:self.properties
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	
	NSString *path = [PropertyStore propertyFilePath];
	NSLog(@"Saving properties to path:%@\ndata:%@", path, self.properties);
	
	if(plistData) {
		[plistData writeToFile:path atomically:YES];
		return YES;
	} else {
		NSLog(@"Error : %@",error);
		return NO;
	}
}

+ (NSString *) propertyFilePath {
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [rootPath stringByAppendingPathComponent:@"application.plist"];
}


@end
