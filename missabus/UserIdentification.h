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
	PropertyStore *propertyStore;
	NSURLConnection *connection;
	NSMutableData *jsonData;
}

+ (id) instance;

- (void) login: (id) delegate;
- (NSString *) userId;

@end
