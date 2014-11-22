//
//  SonarViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//


#import <AudioToolbox/AudioToolbox.h>
#import "SonarViewController.h"

@interface SonarViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *durationString;
    
}
@end

@implementation SonarViewController

@synthesize peripheral;
@synthesize sensor;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    

    
    // Sets TAH class delegate
    self.sensor.delegate = self;
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    
    ///////// TAH Status Update Timer //////////
    
   SonarSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(SonarSensorUpdate:)
                                                          userInfo:nil
                                                           repeats:YES];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}


///////////// Update Device Connection Status Image //////////
-(void)UpdateConnectionStatusLabel
{
    
    
    if (sensor.activePeripheral.state)
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    else
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}




-(void)viewWillDisappear:(BOOL)animated
{
    [SonarSensorUpdatetimer invalidate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


-(void)SonarSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 2.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHSonarSensorUpdate:sensor.activePeripheral SensorPin:connectedsensorpin];
    }
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



// Called when TAH is connected
-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}


// Called when TAH is Disconnected
-(void)setDisconnect
{
    [sensor disconnect:sensor.activePeripheral];
    
    NSLog(@"TAH Device Disconnected");
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    /////////////////////////////////////////////
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}




// Received Data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{

    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    
    if (value.length >= 3)
    {
    ReceivedData = [value componentsSeparatedByString: @":"];
    durationString = [ReceivedData objectAtIndex: 1];
    [self durationtodistanceunit];  // update distance
    }
    
}


//////////// Received Data conversion to Actual Distance //////////////

-(void)durationtodistanceunit
{
    float rawdistance = [durationString floatValue];
    
    if (sensorunitscalesegment.selectedSegmentIndex == 0)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.0f",rawdistance/29/2];
        distanceunitlabel.text = @"cms";
        
        NSLog(@"Distance in Cms: %.0f",rawdistance/29/2);

    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 1)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/74/2];
        distanceunitlabel.text = @"inches";
        
        NSLog(@"Distance in Inches: %.1f",rawdistance/74/2);
    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 2)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/883/2];
        distanceunitlabel.text = @"feets";
        
        NSLog(@"Distance in Feets: %.1f",rawdistance/883/2);
    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 3)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/2900/2];
        distanceunitlabel.text = @"meters";
        
        NSLog(@"Distance in Meters: %.1f",rawdistance/2900/2);
    }
    


}


//////////////////////////////////////////////////////////////////////



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
        [SonarSensorUpdatetimer invalidate];
    }
    
    else
    {
        settingsview.hidden = YES;
        
        [self durationtodistanceunit];  // Update if any change in  Distance Unit Type
        
        ///////// Sonar Sensor Update Timer //////////
        
        SonarSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                              target:self
                                                                            selector:@selector(SonarSensorUpdate:)
                                                                            userInfo:nil
                                                                             repeats:YES];
    }
}

@end
