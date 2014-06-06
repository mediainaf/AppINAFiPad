//
//  AppTableCell.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 05/06/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "AppTableCell.h"

@implementation AppTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"AppTableCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
