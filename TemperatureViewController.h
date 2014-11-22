//
//  TemperatureViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;

@interface TemperatureViewController : UIViewController<BTSmartSensorDelegate>
{
   
    NSTimer *timer;  // timer for updating Real time
    
    IBOutlet UIImageView *tempbg;
    IBOutlet UIImageView *daynightstate;
    IBOutlet UILabel *temperaturelabel;



    
    IBOutlet UILabel *ConnectionStatusLabel;
    
    IBOutlet UIView *settingsview;
    IBOutlet UIButton *settings;
    
    NSTimer *TemperatureSensorUpdatetimer;
    
    IBOutlet UISegmentedControl *sensorpinsegment;
    IBOutlet UISegmentedControl *sensorunitscalesegment;

    
}
-(void)updateTimer;

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

 - (IBAction)settings:(id)sender;


@end
