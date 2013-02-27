//
//  TransportSearchDisplayController.h
//  missabus
//
//  Created by Jaakko Santala on 2/19/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportSearchDisplayController : UISearchDisplayController <NSURLConnectionDelegate, UITableViewDataSource, UISearchDisplayDelegate>

// Ideal implementation would likely be a class that executes NSURLConnections by adding them to a queue, and returning complete results to a delegate (results could be a json dictionary), or reporting when an error happens. It could also be that

{
	NSURLConnection *currentConnection;
	NSMutableData *jsonData;
	NSMutableArray *searchResults;
	NSOperationQueue *searchQueue;
}


- (void) startTransportLineQuery: (NSString *) query;
- (NSArray *) getCurrentQueryResults;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end

void removeDuplicateTransportLines(NSMutableArray *array);
NSString *imageNameForTransportType(NSString *type);