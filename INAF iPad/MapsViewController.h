//
//  MapsViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface MapsViewController : UIViewController <MKMapViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentController;
- (IBAction)onChange:(id)sender;

@end
