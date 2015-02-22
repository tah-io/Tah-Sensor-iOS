//
//  RainViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 23/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;


@interface RainViewController : UIViewController<BTSmartSensorDelegate>
{
 IBOutlet UILabel *ConnectionStatusLabel;
    
    IBOutlet UIImageView *cloud;
    IBOutlet UIButton *settings;
    IBOutlet UIView *settingsview;
    IBOutlet UILabel *rainstatuslabel;
    IBOutlet UITextField *sensorthreshold;
    
    
    NSTimer *RainSensorUpdatetimer;
    
    IBOutlet UISegmentedControl *sensorpinsegment;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;
@property (strong, nonatomic) IBOutlet UITextField *sensorthresholdset;

- (IBAction)settings:(id)sender;
@end
