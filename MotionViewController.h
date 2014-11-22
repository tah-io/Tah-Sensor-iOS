//
//  MotionViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 23/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;


@interface MotionViewController : UIViewController<BTSmartSensorDelegate>
{

    IBOutlet UILabel *MotionStatusLabel;
    
    NSTimer *MotionSensorUpdatetimer;
    
    IBOutlet UIView *settingsview;
    IBOutlet UIButton *settings;
    
    IBOutlet UISegmentedControl *sensorpinsegment;
    
    IBOutlet UILabel *ConnectionStatusLabel;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

 - (IBAction)settings:(id)sender;

@end
