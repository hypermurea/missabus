//
//  PropertyStore.h
//  missabus
//
//  Created by Jaakko Santala on 2/18/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyStore : NSObject

@property (nonatomic, readonly, strong) NSMutableDictionary *properties;

+ (NSString *) propertyFilePath;

- (BOOL) save;
- (BOOL) setAndSave:(NSString *) name value: (NSString *) value;

@end
