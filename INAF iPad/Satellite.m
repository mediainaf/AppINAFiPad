//
//  Satellite.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 12/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "Satellite.h"

@implementation Satellite

- (id)init:(NSString *) line1 : (NSString* ) line2 : (NSString* ) name
{
    
    self.line1 = line1;
    self.line2 = line2;
    self.name = name;
    
    return  self;
    
}

@end
