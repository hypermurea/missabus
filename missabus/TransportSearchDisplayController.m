//
//  TransportSearchDisplayController.m
//  missabus
//
//  Created by Jaakko Santala on 2/19/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "TransportSearchDisplayController.h"
#import "Constants.h"

static NSString *bus = BUS_IMAGE;
static NSString *train = TRAIN_IMAGE;
static NSString *metro = METRO_IMAGE;
static NSString *tram = TRAM_IMAGE;
static NSString *ferry = FERRY_IMAGE;

static NSDictionary *transportTypeImageMapping;

@implementation TransportSearchDisplayController

- (void) startTransportLineQuery: (NSString *) query {
	
	if(searchResults == nil) {
		searchResults = [NSMutableArray array];
	}
	
	NSString *escapedQuery = [query stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@/?request=lines&p=111001&format=json&user=%@&pass=%@&query=%@", REITTIOPAS_API_URL, REITTIOPAS_USER, REITTIOPAS_PWD, escapedQuery]];
	
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
	NSLog(@"opening connection to: %@", [url absoluteString]);
	
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately: YES];

}

- (NSArray *) getCurrentQueryResults {
	return searchResults;
}


// NSURLConnectionDelegate implementation
// TODO Implemented in this way, the jsonData/connection are bound to be overwritten accidentally when multiple quries come in, fix.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		[searchResults removeAllObjects];
		[self.searchResultsTableView reloadData];
	}];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[jsonData appendData: data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	jsonData = [NSMutableData data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		
		NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		//NSLog(@"JSON output: %@", json);
		
		NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error;

		NSMutableArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
		removeDuplicateTransportLines(results);
				
		[searchResults removeAllObjects];
		[searchResults addObjectsFromArray:results];
		[self.searchResultsTableView reloadData];
	}];

}

void removeDuplicateTransportLines(NSMutableArray *array) {
	
	NSMutableSet *keys = [NSMutableSet set];
	int i = 0;
	while(i < [array count]) {
		NSDictionary *item = [array objectAtIndex:i];
		NSString *key = [NSString stringWithFormat: @"%@_%@", [item objectForKey:@"transport_type_id"], [item objectForKey:@"code_short"]];
		if([keys containsObject:key]) {
			[array removeObjectAtIndex: i];
		} else {
			[keys addObject:key];
			i++;
		}
	}
	
}


// UITableViewDataSource implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
	
	NSDictionary *entry = [searchResults objectAtIndex:[indexPath item]];
	cell.textLabel.text = [entry objectForKey:@"code_short"];
	cell.detailTextLabel.text = [entry objectForKey:@"name"];
	cell.imageView.image = [UIImage imageNamed:
								imageNameForTransportType([[entry objectForKey:@"transport_type_id"] stringValue])];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

NSString *imageNameForTransportType(NSString *type) {
	if(!transportTypeImageMapping) {
		transportTypeImageMapping = [NSDictionary dictionaryWithObjectsAndKeys:
									 bus, @"1",
									 tram, @"2",
									 bus, @"3",
									 bus, @"5",
									 metro, @"6",
									 ferry, @"7",
									 bus, @"8",
									 train, @"12",
									 bus, @"21",
									 bus, @"22",
									 bus, @"23",
									 bus, @"24",
									 bus, @"25",
									 bus, @"36",
									 bus, @"39",
									 nil];
		
	}
	
	return [transportTypeImageMapping objectForKey: type];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [searchResults count];
}


// UISearchDisplayDelegate implementation

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	
	NSLog(@"shouldReloadTableForSearchString: %@", searchString);
	
	if([searchString length] > 0) {
		[self startTransportLineQuery:searchString];
		return NO;
	} else {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[searchResults removeAllObjects];
			[self.searchResultsTableView reloadData];
		}];
		return YES;
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	NSLog(@"shouldReloadTableForSearchScope");
	return NO;
}

@end

