//
//  MainViewController.h
//  missabus
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "TransportSearchDisplayController.h"

@interface MainViewController : UIViewController <UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *linesOfInterestTableView;

@end

NSDictionary *convertSearchResultToLineOfInterest(NSDictionary *result);