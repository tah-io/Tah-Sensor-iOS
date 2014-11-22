//
//  TouchViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;

@interface TouchViewController : UIViewController<BTSmartSensorDelegate>
{
 
    IBOutlet UIImageView *touchcircles;
    
     IBOutlet UILabel *ConnectionStatusLabel;
     IBOutlet UILabel *TouchStatusLabel;
    
    NSTimer *TouchSensorUpdatetimer;
    
    IBOutlet UIView *settingsview;
    IBOutlet UIButton *settings;

    IBOutlet UISegmentedControl *sensorpinsegment;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

 - (IBAction)settings:(id)sender;

@end
