//
//  VideoCell.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.

// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "VideoCell.h"

@implementation VideoCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];
        
        self.play.image = [UIImage imageNamed:@"Assets/play.png"];
        self.play.alpha=0.5;
        self.play.hidden=YES;
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
