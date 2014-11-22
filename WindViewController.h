//
//  WindViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 23/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;

@interface WindViewController : UIViewController<BTSmartSensorDelegate>
{
 
    IBOutlet UILabel *windspeedlabel;
    IBOutlet UILabel *windspeedunitlabel;
    
    
    IBOutlet UISegmentedControl *sensorpinsegment;
    IBOutlet UISegmentedControl *sensorunitscalesegment;
    IBOutlet UIView *settingsview;
    IBOutlet UIButton *settings;

    NSTimer *WindSensorUpdatetimer;
    
    IBOutlet UILabel *ConnectionStatusLabel;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

- (IBAction)settings:(id)sender;

@end
