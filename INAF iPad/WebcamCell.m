//
//  WebcamCell.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 13/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "WebcamCell.h"

@implementation WebcamCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"WebcamCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
