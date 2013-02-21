//
//  UserIdentification.m
//  missabus
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "UserIdentification.h"
#import "Constants.h"
#import "PropertyStore.h"

@implementation UserIdentification

static UserIdentification *user;

@synthesize propertyStore;

+ (id) instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		user = [[self alloc] init];
    });
    return user;
}

- (id) init {
	self = [super init];
	if(self != nil) {
		propertyStore = [[PropertyStore alloc] init];
	}
	return self;
}

- (void) login:(id)delegate {
	
	// params for http request are /mobile/?uuid=xxx&lof=xxx&device=ios
	
    jsonData = [[NSMutableData alloc] init];
    
	NSError *error;
	NSData *json = [NSJSONSerialization dataWithJSONObject:[self linesOfInterest]  options:kNilOptions error:&error];
	NSString *linesOfInterestText = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
		
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/mobile", SERVER_URL]];
	NSString *post = [NSString stringWithFormat: @"device=ios&uuid=%@&lof=%@", [self userId], linesOfInterestText];
	NSData *postData = [post dataUsingEncoding: NSUTF8StringEncoding];
				  
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	[req setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
	[req setHTTPMethod: @"POST"];
	[req setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[req setHTTPBody: postData];
	NSLog(@"opening connection to: %@ ;data:%@", [url absoluteString], post);
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:delegate startImmediately: YES];
}

- (NSArray *) linesOfInterest {
	NSData *json = [[propertyStore properties] objectForKey:@"lof"]; // TODO magic constant
	
	if(json != nil) {
		NSError *error;
		// TODO error handling not implemented
		return [NSJSONSerialization JSONObjectWithData:json options:kNilOptions error:&error];
	} else {
		return [NSArray array];
	}
}

- (void) addLineOfInterest: (NSDictionary *) item {
	BOOL duplicate = NO;
	for(NSDictionary *line in [self linesOfInterest]) {
		
		if([[item objectForKey:@"shortCode"] isEqualToString: [line objectForKey:@"shortCode"]] &&
		   [[item objectForKey:@"transportType"] isEqualToString: [line objectForKey:@"transportType"]]) {
			duplicate = YES;
			break;
		}
		
	}
	
	if(!duplicate) {
		NSMutableArray *mutableCopy = [[self linesOfInterest] mutableCopy];
		[mutableCopy addObject:item];
		[self linesOfInterest:mutableCopy];
	}
}

- (void) removeLineOfInterest: (NSUInteger) index {
	NSMutableArray *mutableCopy = [[self linesOfInterest] mutableCopy];
	[mutableCopy removeObjectAtIndex:index];
	[self linesOfInterest:mutableCopy];
}


- (void) linesOfInterest: (NSArray *) array {
	NSError *error;
	NSData* json = [NSJSONSerialization dataWithJSONObject:array  options:kNilOptions error:&error];

	[[propertyStore properties] setObject: json forKey: @"lof"]; // TODO magic constant
}

- (NSString *) userId {
	NSString *idKey = @"userid";
	NSString *ident = [[propertyStore properties] objectForKey:idKey];
	if(ident == nil) {
		ident = [self newUuid];
		[propertyStore setAndSave: idKey value: ident];
	}
	return ident;
}

- (NSString *) newUuid {
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge NSString *) string;
}

@end
