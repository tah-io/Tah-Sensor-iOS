//
//  HomeViewController.m
//  TAH Sensor
//
//  Created by Dhiraj on 05/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "HomeViewController.h"
#import "TAHbleTableController.h"
#import "TAHble.h"
#import "CustomCell.h"
#import "SonarViewController.h"
#import "TemperatureViewController.h"
#import "TouchViewController.h"
#import "LightViewController.h"
#import "WindViewController.h"
#import "RainViewController.h"
#import "MotionViewController.h"
#import "SoilMoistureViewController.h"
#import "SocialViewController.h"
#import "MediaViewController.h"
#import "SettingsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

    
    
    // Settings Up Sensor Delegate
    self.sensor.delegate = self;
    
    
    
    /////////////// Setting Collection View Delegate and Datasource /////////////
    
    [[self myCollectionView]setDelegate:self];
    [[self myCollectionView]setDataSource:self];
    ////////////////////////////////////////////////////////////////////////////
    
    
    /////////////// Setting array of Images and Identifiers for Collection View Cells /////////////
    arrayofImages = [[NSArray alloc]initWithObjects:@"sonar.png",@"temp.png",@"touch.png",@"light.png",@"rain.png",@"wind.png",@"motion.png",@"soil.png",@"share",@"youtube.png",@"settings.png", nil];
    arrayofCellIdentifiers = [[NSArray alloc]initWithObjects:@"Cell1",@"Cell2",@"Cell3",@"Cell4",@"Cell5",@"Cell6",@"Cell7",@"Cell8",@"Cell9",@"Cell10",@"Cell11", nil];
    
    ////////////////////////////////////////////////////////////////////////////
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];

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



///////////// Collection View Setup /////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 11;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[arrayofCellIdentifiers objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
    [[cell myImage]setImage:[UIImage imageNamed:[arrayofImages objectAtIndex:indexPath.row]]];
    
    
    
    return cell;
}

//////////////////////////////////////////////////









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




//////////////////////// Preparing Segue for Navigation //////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Changes title of the Back Button in destintion controller
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    
    
    if ([[segue identifier] isEqualToString:@"Cell1"])
    {
        SonarViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Sonar Sensor";
        
        
        
    }
    
    else if ([[segue identifier] isEqualToString:@"Cell2"])
    {
        TemperatureViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        
        detailViewController.title = @"Temperature";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell3"])
    {
        TouchViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Touch Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell4"])
    {
        LightViewController *detailViewController = [segue destinationViewController];
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Light Level";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell5"])
    {
        RainViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Rain Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell6"])
    {
        WindViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Wind Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell7"])
    {
        MotionViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Motion Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell8"])
    {
        SoilMoistureViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Soil Moisture";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell9"])
    {
        SocialViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Share";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell10"])
    {
        MediaViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Youtube";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell11"])
    {
        SettingsViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        detailViewController.title = @"Settings";
    }
    
    
}

//////////////////////////////////////////////////////////////////////////////////






//recv data
-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",value);
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



@end
