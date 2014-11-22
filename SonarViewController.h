//
//  SonarViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"


@class CBPeripheral;
@class TAHble;

@interface SonarViewController : UIViewController<BTSmartSensorDelegate>
{
    
    IBOutlet UILabel *distancelabel;
    IBOutlet UILabel *distanceunitlabel;

    
    IBOutlet UISegmentedControl *sensorpinsegment;
    IBOutlet UISegmentedControl *sensorunitscalesegment;
    IBOutlet UIView *settingsview;
    IBOutlet UIButton *settings;
    
    IBOutlet UILabel *ConnectionStatusLabel;
    NSTimer *SonarSensorUpdatetimer;


}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

- (IBAction)settings:(id)sender;


@end
