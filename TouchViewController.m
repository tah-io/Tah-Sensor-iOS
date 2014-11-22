//
//  TouchViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "TouchViewController.h"

@interface TouchViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *rawDataString;
}
@end

@implementation TouchViewController

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
    
    //[self touchcirclesanimationstart];
    
    // Sets TAH class delegate
    self.sensor.delegate = self;
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    
    ///////// TAH Status Update Timer //////////
    
    TouchSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TouchSensorUpdate:)
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
    [TouchSensorUpdatetimer invalidate];
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


-(void)touchcirclesanimationstart
{
    
    NSArray *eyes=[NSArray arrayWithObjects:[UIImage imageNamed:@"t1.png"],[UIImage imageNamed:@"t2.png"],[UIImage imageNamed:@"t3.png"],[UIImage imageNamed:@"t4.png"],[UIImage imageNamed:@"t3.png"],[UIImage imageNamed:@"t2.png"],[UIImage imageNamed:@"t1.png"],nil];
    
    touchcircles.animationImages  = eyes;
    touchcircles.animationDuration = 1;
    touchcircles.animationRepeatCount = -1;
    
    [touchcircles startAnimating];
    
    
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
        [self valuetoTouch];  // Update Touch Status
    }

    
    
}


-(void)TouchSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 2.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHTouchSensorUpdate:sensor.activePeripheral SensorPin:connectedsensorpin];
    }
}


-(void)valuetoTouch
{
    NSLog(@"Touch: %@", rawDataString);
   int rawtouch = [rawDataString intValue];
    
    if (rawtouch == 1)
    {
        [self touchcirclesanimationstart];
        
        TouchStatusLabel.text = @"Touch Detected";
        
    }
    
    else
    {
       [touchcircles stopAnimating];
        
        TouchStatusLabel.text = @"Touch Not Detected";
    }

}



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
        [TouchSensorUpdatetimer invalidate];
    }
    
    else
    {
        settingsview.hidden = YES;
        
        [self valuetoTouch];  // Update if any change in  Distance Unit Type
        
        ///////// Temperature Sensor Update Timer //////////
        
        TouchSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:self
                                                                      selector:@selector(TouchSensorUpdate:)
                                                                      userInfo:nil
                                                                       repeats:YES];
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

@end
