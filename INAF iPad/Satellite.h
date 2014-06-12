//
//  Satellite.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 12/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface Satellite : NSObject

@property (nonatomic,strong) NSString * line1;
@property (nonatomic,strong) NSString * line2;
@property (nonatomic,strong) NSString * lat;
@property (nonatomic,strong) NSString * lon;
@property (nonatomic,strong) NSString * name;
- (id)init:(NSString *) line1 : (NSString* ) line2 : (NSString* ) name;

@end
