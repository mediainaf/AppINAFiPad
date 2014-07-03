//
//  JobsTableViewCell.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 03/07/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "JobsTableViewCell.h"

@implementation JobsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"JobsTableViewCell" owner:self options:nil];
        
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
