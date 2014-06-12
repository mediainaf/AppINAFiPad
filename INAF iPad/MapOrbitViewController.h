//
//  MapOrbitViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 12/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapOrbitViewController : UIViewController <MKMapViewDelegate,MKAnnotation,UIPopoverControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) NSTimer * timer;
@end
