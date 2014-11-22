//
//  WindViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 23/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "WindViewController.h"

@interface WindViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *rawDataString;
    
}
@end

@implementation WindViewController

@synthesize sensor;
@synthesize peripheral;

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
    // Do any additional setup after loading the view.
    
    // Sets TAH class delegate
    self.sensor.delegate = self;
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    
    ///////// TAH Status Update Timer //////////
    
    WindSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(WindSensorUpdate:)
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [WindSensorUpdatetimer invalidate];
}



-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}

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






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)WindSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 410.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHWindSensorUpdate:sensor.activePeripheral AnalogPin:connectedsensorpin];
    }
    
    
}


// Received Data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    if (value.length >= 3)
    {
    ReceivedData = [value componentsSeparatedByString: @":"];
    rawDataString = [ReceivedData objectAtIndex: 1];
    [self valuetospeedunit];  // update distance
    }
    
}


//////////// Received Data conversion to Actual Distance //////////////

-(void)valuetospeedunit
{
    int rawspeed = [rawDataString floatValue];
    
    if (sensorunitscalesegment.selectedSegmentIndex == 0)
    {
       windspeedlabel.text = [NSString stringWithFormat:@"%d",rawspeed];
        windspeedunitlabel.text = @"km/hr";
    }

    else if(sensorunitscalesegment.selectedSegmentIndex == 1)
    {
        windspeedlabel.text = [NSString stringWithFormat:@"%.1f",(rawspeed*0.27)];
        windspeedunitlabel.text = @"m/s";
    }
    
    
}


//////////////////////////////////////////////////////////////////////



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
        [WindSensorUpdatetimer invalidate];
    }
    
    else
    {
        settingsview.hidden = YES;
        
        [self valuetospeedunit];  // Update if any change in  Distance Unit Type
        
        ///////// Wind Sensor Update Timer //////////
        
        WindSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                  target:self
                                                                selector:@selector(WindSensorUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
    }
}



@end
