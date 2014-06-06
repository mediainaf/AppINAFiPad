//
//  ViewControllerAnnotation.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 03/04/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import "ViewControllerAnnotation.h"

@interface ViewControllerAnnotation ()

@end

@implementation ViewControllerAnnotation
@synthesize phone,link,nome,address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
