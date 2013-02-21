//
//  UserIdentification.h
//  missabus
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyStore.h"

@interface UserIdentification : NSObject

{
	NSURLConnection *connection;
	NSMutableData *jsonData;
}

@property (nonatomic, strong) PropertyStore *propertyStore;

+ (id) instance;

- (void) login: (id) delegate;
- (NSString *) userId;
- (NSArray *) linesOfInterest;
- (void) linesOfInterest: (NSArray *) array;
- (void) addLineOfInterest: (NSDictionary *) item;
- (void) removeLineOfInterest: (NSUInteger) index;

@end
