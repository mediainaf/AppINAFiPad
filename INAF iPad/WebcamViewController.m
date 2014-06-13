//
//  WebcamViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 13/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import "WebcamViewController.h"
#import "WebcamCell.h"

@interface WebcamViewController ()
{
    NSArray * webcamName;
    NSMutableDictionary *cachedImages;

    NSArray * webcamLink;

}

@end

@implementation WebcamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
   // [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    
    cachedImages = [[NSMutableDictionary alloc] init];
    
    webcamLink = [NSArray arrayWithObjects:@"http://www.med.ira.inaf.it/webcam.jpg",
                            @"http://abell.as.arizona.edu/~hill/lbtmc02/image.jpg",
                            @"http://abell.as.arizona.edu/~hill/lbtcam/hugesize.jpg",
                            @"http://www.tt1obs.org/slideshow/p013_1_1.jpg",
                            @"http://www.srt.inaf.it/static/img/web-image-last-ts.jpg?1402669975",
                            @"http://www.tng.iac.es/webcam/get.html?resolution=640x480&compression=30&clock=1&date=1&dummy=1402670070248",
                            @"http://www.noto.ira.inaf.it/cams/cam1.jpg",
                            @"http://www.magic.iac.es/webcams/webcam/2014/06/13/1530_la.jpg",
                            @"http://www.magic.iac.es/webcams/webcam2/2014/06/13/1530_la.jpg",
                            @"http://archive.oapd.inaf.it/meteo/webcam_high.jpg",
                            @"http://archive.oapd.inaf.it/meteo/videocam_low.jpg",
                            @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbc1.jpg",
                            @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbc2.jpg",
                            @"http://polaris.me.oa-brera.inaf.it/remwbc/remwbcx.jpg",
                            @"http://www.media.inaf.it/wp-content/uploads/webcams/img_6.jpg",nil];
    
    
     webcamName = [NSArray arrayWithObjects:
                            @"Radiotelescopio di Medicina (Bologna)",
                            @"Large Binocular Telescope (Arizona,US) - Interno sx fronte",
                            @"Large Binocular Telescope (Arizona,US) - Esterno",
                            @" Il telescopio TT1 di Toppo Castel-grande (PZ)",
                            @"Sardinia Radio Telescope (Cagliari)",
                            @"Telescopio Nazionale Galileo (Isole Canarie)",
                            @"Radiotelescopio di Noto (SR)",
                            @"Il telescopio Cherenkov MAGIC-I (Isole Canarie)",
                            @"Il telescopio Cherenkov MAGIC-II (Isole Canarie)",
                            @"Stazione Osservativa di Cima Ekar (Asiago) - High",
                            @"Stazione Osservativa di Cima Ekar (Asiago) - Low",
                            @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
                            @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
                            @"Telescopio REM- Rapid Ey Mount (La Silla, Cile)",
                            @"Il telescopio di Loiano (Bologna)",
                             nil];
    
    
    
    self.title = @"Webcam";
    
    [self.collectionView registerClass:[WebcamCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(354, 356)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:20.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    WebcamCell *cell = (WebcamCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];
    
    cell.title.text = [webcamName objectAtIndex:indexPath.row];

        
    
    NSLog(@"cel %d",indexPath.row);
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                            indexPath.row];

    
    if([cachedImages objectForKey:identifier] != nil)
    {
        cell.webcam.image = [cachedImages valueForKey:identifier];
        [cell.indicator stopAnimating];
        NSLog(@"metti immagine");
        
    }
    else
    {
        cell.webcam.image = nil;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
        dispatch_async(queue, ^{
            //This is what you will load lazily
            
            NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[webcamLink objectAtIndex:indexPath.row ] ]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                UIImage * image = [UIImage imageWithData:data];
                [cachedImages setObject:image forKey:identifier];
                //cell.thumbnail.image = image;
                [cell setNeedsLayout];
                [UIView setAnimationsEnabled:NO];
                
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
            });
        });
        
    }
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   /*
    NSLog(@"deselect");
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                            indexPath.row];
    
    DetailVideoViewController * detail = [[DetailVideoViewController alloc] initWithNibName:@"DetailVideoViewController" bundle:nil];
    
    
    
    detail.video = [video objectAtIndex:indexPath.row];
    detail.thumbnail = [cachedImages objectForKey:identifier];
    
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];*/
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
