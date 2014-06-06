//
//  Telescope.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 28/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Telescope : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * link;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * phone;

@property (nonatomic) CLLocationCoordinate2D coord;

@end
