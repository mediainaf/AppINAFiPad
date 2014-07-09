//
//  MapsViewController.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface MapsViewController : UIViewController <MKMapViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *detailView;



@end
