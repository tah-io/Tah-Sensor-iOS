//
//  AppDelegate.h
//  TAH Sensor
//
//  Created by Dhiraj on 29/05/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSTimer *SonarSensorUpdatetimer;

@end
