//
//  Telescope.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Telescope : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * img;
@property (nonatomic,strong) NSString * tag;
@property (nonatomic,strong) NSString * phase;
@property (nonatomic,strong) NSString * scope;

@property (nonatomic) CLLocationCoordinate2D coord;

@end
