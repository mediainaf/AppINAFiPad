//
//  Annotation.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 16/02/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#include <MapKit/MapKit.h>
@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic,assign) CLLocationCoordinate2D  coordinate;
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * subtitle;
@property(nonatomic,strong) NSString * link;
@property(nonatomic,strong) NSString * disco;
@property(nonatomic) int tag;


@end
