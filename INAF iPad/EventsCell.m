//
//  EventsCell.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "EventsCell.h"

@implementation EventsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"EventsCell" owner:self options:nil];
        
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
