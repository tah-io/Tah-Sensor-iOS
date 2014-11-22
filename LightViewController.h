//
//  LightViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;


@interface LightViewController : UIViewController<BTSmartSensorDelegate>
{
    IBOutlet UILabel *ConnectionStatusLabel;
    
    IBOutlet UIButton *settings;
    IBOutlet UIView *settingsview;
    
    IBOutlet UILabel *lightlevellabel;
    
    NSTimer *LightSensorUpdatetimer;
    
    IBOutlet UISegmentedControl *sensorpinsegment;

    
}
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

 - (IBAction)settings:(id)sender;

@end
