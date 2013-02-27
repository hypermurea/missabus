//
//  MainViewController.m
//  missabus
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "MainViewController.h"
#import "UserIdentification.h"
#import "TransportSearchDisplayController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.searchDisplayController.searchResultsDataSource = (id<UITableViewDataSource>) self.searchDisplayController;
	self.searchDisplayController.delegate = (id<UISearchDisplayDelegate>) self.searchDisplayController;
	self.searchDisplayController.searchResultsDelegate = self;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(tableView == self.searchDisplayController.searchResultsTableView) {
		
		TransportSearchDisplayController *controller = (TransportSearchDisplayController *) self.searchDisplayController;
		NSArray *currentResults = [controller getCurrentQueryResults];
		NSDictionary *itemDict = convertSearchResultToLineOfInterest([currentResults objectAtIndex:indexPath.item]);
		
		[[UserIdentification instance] addLineOfInterest:itemDict];
		
		[self.linesOfInterestTableView reloadData];
		[self.searchDisplayController setActive:NO];
		
	} else {
		[[UserIdentification instance] removeLineOfInterest:[indexPath item]];
		[self.linesOfInterestTableView reloadData];
	}
	
	[[UserIdentification instance] login];
}

NSDictionary *convertSearchResultToLineOfInterest(NSDictionary *result) {
	/*
	 code: line.code, shortCode: line.shortCode,
	 transportType: line.transportType, name: line.name, user: user)
	 */
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[result objectForKey:@"code"], @"code",
			[result objectForKey:@"code_short"], @"shortCode",
			[result objectForKey:@"transport_type_id"], @"transportType",
			[result objectForKey:@"name"], @"name",
			nil];
}

// UITableViewDataSource implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([indexPath section] == 1) {
		
		static NSString *MyIdentifier = @"MainViewControllerCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
		}
		
		NSDictionary *entry = [[[UserIdentification instance] linesOfInterest] objectAtIndex:[indexPath item]];
		cell.textLabel.text = [entry objectForKey:@"shortCode"];
		cell.detailTextLabel.text = [entry objectForKey:@"name"];
		cell.imageView.image = [UIImage imageNamed:
								imageNameForTransportType([[entry objectForKey:@"transportType"] stringValue])];
		return cell;
		
	} else {
		return nil;
	}
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return 0;
	} else {
		return [[[UserIdentification instance] linesOfInterest] count];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
			return @"Edelliset häiriötiedotteet";
	} else {
			return @"Seurattavat liikennelinjat";
	}
}



@end
