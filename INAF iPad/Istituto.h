//
//  Istituto.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 29/03/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Istituto : NSObject

@property (nonatomic,strong) NSString * ID;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * descr;
@property (nonatomic,strong) NSString * website;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic) CLLocationCoordinate2D   coord;

@end
