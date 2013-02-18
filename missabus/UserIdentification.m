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

+ (id) instance {
    static UserIdentification *user = nil;
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
    		
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/mobile?device=ios&uuid=%@&lof=%@", SERVER_URL, [self userId], @""]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:delegate startImmediately: YES];
	
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
