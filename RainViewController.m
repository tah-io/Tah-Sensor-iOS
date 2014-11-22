//
//  RainViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 23/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "RainViewController.h"

@interface RainViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *rawDataString;
}
@end

@implementation RainViewController

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
    
    RainSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(RainSensorUpdate:)
                                                            userInfo:nil
                                                             repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [RainSensorUpdatetimer invalidate];
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



// Received Data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    if (value.length >= 3)
    {
    ReceivedData = [value componentsSeparatedByString: @":"];
    rawDataString = [ReceivedData objectAtIndex: 1];
    [self valuetoRain];  // Update Rain Status
    }
    
}


-(void)RainSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 410.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHRainSensorUpdate:sensor.activePeripheral AnalogPin:connectedsensorpin];
    }
}


-(void)valuetoRain
{
    NSLog(@"Rain: %@", rawDataString);
    int rawrain = [rawDataString intValue];
    
    if (rawrain >= 900)
    {
      rainstatuslabel.text = @"It's Raining";
        
        [self cloudanimationstart];
    }
    
    else if(rawrain < 900)
    {
      rainstatuslabel.text = @"Raining Stopped";
        [cloud stopAnimating];
    }
    
}



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
        [RainSensorUpdatetimer invalidate];
    }
    
    else
    {
        settingsview.hidden = YES;
        
        [self valuetoRain];  // Update if any change in  Distance Unit Type
        
        ///////// Temperature Sensor Update Timer //////////
        
        RainSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                  target:self
                                                                selector:@selector(RainSensorUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
    }
}



-(void)cloudanimationstart
{
    
    NSArray *drops=[NSArray arrayWithObjects:[UIImage imageNamed:@"rainsmall 1.png"],[UIImage imageNamed:@"rainsmall 2.png"],[UIImage imageNamed:@"rainsmall 3.png"],[UIImage imageNamed:@"rainsmall 1.png"],[UIImage imageNamed:@"rainsmall 2.png"],[UIImage imageNamed:@"rainsmall 3.png"],[UIImage imageNamed:@"rainsmall 1.png"],[UIImage imageNamed:@"rainsmall 2.png"],[UIImage imageNamed:@"rainsmall 3.png"],nil];
    
    cloud.animationImages  = drops;
    cloud.animationDuration = 0.3;
    cloud.animationRepeatCount = -1;
    
    [cloud startAnimating];
    
    
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

@end
