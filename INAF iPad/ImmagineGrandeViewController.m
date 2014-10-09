//
//  ViewControllerImagineGrande.m
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 25/04/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ImmagineGrandeViewController.h"

@interface ImmagineGrandeViewController ()
{
    NSURLConnection * connection ;
}
@end

@implementation ImmagineGrandeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // 2
    CGFloat newZoomScale = self.scrollerView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollerView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollerView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollerView zoomToRect:rectToZoomTo animated:YES];
}
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollerView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollerView.minimumZoomScale);
    [self.scrollerView setZoomScale:newZoomScale animated:YES];
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollerView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.indicator startAnimating];
    
    NSData * data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
    if(data)
    {
        
        UIImage * image = [UIImage imageWithData:data];
        
        //self.imageView.image=image;
        
        
        // 2
        self.scrollerView.contentSize = image.size;
        
        CGRect scrollViewFrame = self.scrollerView.frame;
        CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollerView.contentSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollerView.contentSize.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.scrollerView.zoomScale = minScale;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollViewFrame.size.width-(image.size.width * minScale)) /2, (scrollViewFrame.size.height-(image.size.height * minScale)) /2, image.size.width* minScale, image.size.height * minScale)];
        
        
        // 6
        [self centerScrollViewContents];
        
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.numberOfTouchesRequired = 1;
        [self.scrollerView addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
        twoFingerTapRecognizer.numberOfTapsRequired = 1;
        twoFingerTapRecognizer.numberOfTouchesRequired = 2;
        [self.scrollerView addGestureRecognizer:twoFingerTapRecognizer];
        
        [self.imageView setImage:image];
        
        [self.scrollerView setScrollEnabled:YES];
        [self.scrollerView setBackgroundColor:[UIColor blackColor]];
        
        
        [self.scrollerView setContentSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
        
        [self.scrollerView setMinimumZoomScale: 1];
        [self.scrollerView setMaximumZoomScale:5.0];
        self.scrollerView.delegate=self;
        
        [self.view addSubview:self.scrollerView];
        [self.scrollerView addSubview:self.imageView];
        
        
    }
    else
    {
        [self.indicator stopAnimating];
        [self.indicator setHidden: YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internet Connection Failed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    }
    
}
- (void)viewDidLoad
{
    [self.indicator startAnimating];
    // NSURLConnection * c = [[NSURLConnection alloc ] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageUrl]]delegate:self startImmediately:YES];
    
    NSLog(@"%@",self.imageUrl);
    
    [self.scrollerView setBackgroundColor:[UIColor blackColor]];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
