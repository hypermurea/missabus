//
//  MainViewController.h
//  missabus
//
//  Created by Jaakko Santala on 2/7/13.
//  Copyright (c) 2013 Jaakko Santala. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
