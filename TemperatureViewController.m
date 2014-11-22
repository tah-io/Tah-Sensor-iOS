//
//  TemperatureViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "TemperatureViewController.h"

@interface TemperatureViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *rawDataString;
}
@end

@implementation TemperatureViewController

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
    // Do any additional setup after loading the view.
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(updateTimer)
                                           userInfo:nil 
                                            repeats:YES];
    
    // Sets TAH class delegate
    self.sensor.delegate = self;
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    
    ///////// TAH Status Update Timer //////////
    
    TemperatureSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(TemperatureSensorUpdate:)
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
    [TemperatureSensorUpdatetimer invalidate];
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



-(void)updateTimer
{
    
    NSString *hour,*state;
    
    NSDateFormatter *hourformatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *stateformatter = [[NSDateFormatter alloc] init];
    
    [hourformatter setDateFormat:@"hh"]; // Gets Hours from current time
     hour = [hourformatter stringFromDate:[NSDate date]];
    int time = [hour intValue];
    
    [stateformatter setDateFormat:@"a"];
    state = [stateformatter stringFromDate:[NSDate date]];
    
    
    
    if([state isEqual:@"am"]) // set day image
    {
       
        if (time >= 1 && time <= 5)
        {
            [tempbg setImage:[UIImage imageNamed:@"night.png"]];
            [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
            
            temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
            

        }
        
        
        else if(time >= 6  &&  time <= 11)
        {
        [tempbg setImage:[UIImage imageNamed:@"day.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
   

        }
        
        
        else if (time == 12)
        {
            [tempbg setImage:[UIImage imageNamed:@"night.png"]];
            [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
            
            temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];

        }

        
    }
    
    if([state isEqual:@"pm"]) // set night image
    {
        
        if (time >= 1 && time <= 5)
        {
            [tempbg setImage:[UIImage imageNamed:@"day.png"]];
            [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
            
            temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
 
        }
        
        else if(time >= 6  &&  time <= 11)
        {
        [tempbg setImage:[UIImage imageNamed:@"night.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
      

        }
        
        
        else if (time == 12)
        {
            [tempbg setImage:[UIImage imageNamed:@"day.png"]];
            [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
            
            temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
            

        }
        

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


// Received Data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    if(value.length >= 3)
    {
    ReceivedData = [value componentsSeparatedByString: @":"];
    rawDataString = [ReceivedData objectAtIndex: 1];
    [self valuetoTemperatureunit];  // update temperature
    }
    
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



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
        [TemperatureSensorUpdatetimer invalidate];
    }
    
    else
    {
        settingsview.hidden = YES;
        
        [self valuetoTemperatureunit];  // Update if any change in  Temperature Unit Type
        
        ///////// Temperature Sensor Update Timer //////////
        
        TemperatureSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                  target:self
                                                                selector:@selector(TemperatureSensorUpdate:)
                                                                userInfo:nil
                                                                 repeats:YES];
    }
}


-(void)TemperatureSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 410.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHTemperatureSensorUpdate:sensor.activePeripheral AnalogPin:connectedsensorpin];
    }
}

-(void)valuetoTemperatureunit
{
    float rawtemperature = [rawDataString floatValue];

    
    if (sensorunitscalesegment.selectedSegmentIndex == 0)
   {
       temperaturelabel.text = [NSString stringWithFormat:@"%.0f%@", rawtemperature,@"ºC"];
       //temperatureunitlabel.text = @"ºC";

   }
    
    else if(sensorunitscalesegment.selectedSegmentIndex == 1)
   {
       temperaturelabel.text = [NSString stringWithFormat:@"%.0f%@", (1.8*rawtemperature + 36),@"ºF"];
       //temperatureunitlabel.text = @"ºF";

   }
}


@end
