//
//  ViewControllerFour.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#import "ViewControllerFour.h"
#import "VideoCell.h"
#import "Video.h"
#import "DetailVideoViewController.h"

@interface ViewControllerFour ()
{
    BOOL load;
    
    NSMutableArray * video;
    NSMutableDictionary *cachedImages;
    NSMutableDictionary *tableImages;
    UIRefreshControl *refreshControl;

    int page;
    
}

@end

@implementation ViewControllerFour

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
    if(!load)
    {
        page = 1;
        load=YES;
        
        [self loadData];
        
        
    }
}
-(void) loadData
{
    [self.loadingView setHidden:YES];

    
    NSString *response1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/inaftv/uploads?alt=json"] encoding:NSUTF8StringEncoding error:nil];
    if(!response1)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/users/inaftv/uploads?alt=json"]];
    
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSArray *jsonArray ;
    if (response) {
        
        NSError *e = nil;
        jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
        
    }
    
    NSDictionary *results = [jsonArray valueForKey:@"feed"];
    
    NSArray * entry = [results valueForKey:@"entry"];
    
    for(NSDictionary * vid in entry)
    {
        
        Video * v = [[Video alloc]init];
        
        NSDictionary * token = [vid valueForKey:@"id"];
        NSString * linktoken = [token valueForKey:@"$t"];
        NSArray * elementi =  [linktoken componentsSeparatedByString:@"/"];
        v.videoToken = [elementi objectAtIndex:6];
        
        NSDictionary * titolo = [vid valueForKey:@"title"];
        NSLog(@"titolo %@",[titolo valueForKey:@"$t"]);
        v.title = [titolo valueForKey:@"$t"];
        
        NSDictionary * lin = [vid valueForKey:@"link"];
        NSArray * linkTot = [lin valueForKey:@"href"];
        v.link = [linkTot objectAtIndex:0];
        NSLog(@"link %@",v.link);
        
        NSDictionary * mediaGroup = [vid valueForKey:@"media$group"];
        NSDictionary * mediaDescription = [mediaGroup valueForKey:@"media$description"];
        v.summary = [mediaDescription valueForKey:@"$t"];
        NSLog(@"description %@",v.summary);
        
        NSArray * mediaThumbnail = [mediaGroup valueForKey:@"media$thumbnail"];
        NSDictionary * thumbnail = [mediaThumbnail objectAtIndex:0];
        v.thumbnail = [thumbnail valueForKey:@"url"];
        NSLog(@"thumbnail %@",v.thumbnail);
        
        NSDictionary * like = [vid valueForKey:@"gd$rating"];
        v.numberOfLike = [like valueForKey:@"numRaters"];
        NSLog(@"raters %@",v.numberOfLike);
        
        NSDictionary * view = [vid valueForKey:@"yt$statistics"];
        v.numberOfView = [view valueForKey:@"viewCount"];
        NSLog(@"view %@",v.numberOfView);
        
        NSDictionary * date = [vid valueForKey:@"published"];
        NSString * dateFormatted = [date valueForKey:@"$t"];
        NSLog(@"data %@",dateFormatted);
        NSArray * elementiData  = [dateFormatted componentsSeparatedByString:@"T"];
        /*
         NSString * day = [elementiData objectAtIndex:1];
         NSString * DM = [day stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:2]]];
         NSString * DMY = [DM stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:3]]];
         */
        v.data = [elementiData objectAtIndex:0];
        
        NSLog(@"data %@",v.data);
        
        
        [video addObject:v];
    }
    
    [self.collectionView reloadData];
    
    [self.loadingView setHidden:YES];
    
    [refreshControl endRefreshing];

    
    
    
}
-(void) reloadData : (id) selector
{
    
    [self.loadingView setHidden:NO];
    
    load =1;
    page = 1;
    
    
    [self loadData];
    
    
    
}
- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(354, 400)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumLineSpacing:20.0];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.collectionView setCollectionViewLayout:flowLayout];
        self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
        
        //[self.collectionView reloadData];
        
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            //[flowLayout setItemSize:CGSizeMake(354, 414)];
            [flowLayout setItemSize:CGSizeMake(314, 354)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [flowLayout setMinimumLineSpacing:20.0];
            [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
            [self.collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            [self.collectionView setCollectionViewLayout:flowLayout];
            self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNewsL.png"];
            //  [self.collectionView reloadData];
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self deviceOrientationDidChangeNotification:nil];
    
}
-(void) refresh
{
    [self performSelector:@selector(reloadData:) withObject:nil afterDelay:0.5];
}
- (void)viewDidLoad
{
    
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(354, 400)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumLineSpacing:20.0];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.collectionView setCollectionViewLayout:flowLayout];
        self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
        
        //[self.collectionView reloadData];
        
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            //[flowLayout setItemSize:CGSizeMake(354, 414)];
            [flowLayout setItemSize:CGSizeMake(314, 354)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [flowLayout setMinimumLineSpacing:20.0];
            [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
            [self.collectionView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            [self.collectionView setCollectionViewLayout:flowLayout];
            self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNewsL.png"];
            //  [self.collectionView reloadData];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    /* UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
     [flowLayout setItemSize:CGSizeMake(354, 400)];
     [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
     [flowLayout setMinimumLineSpacing:20.0];
     [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
     // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
     
     [self.collectionView setCollectionViewLayout:flowLayout];
     
*/

    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl setTintColor:[UIColor whiteColor]];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    
    
    
    [self.collectionView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
    
    
    self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
    
    //[self.loadingView setHidden:NO];

    
   // UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData) ];
    
    //xself.navigationItem.rightBarButtonItem= refresh ;

    
    
    cachedImages = [[NSMutableDictionary alloc] init];
    
    
    [self.collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    
    self.title=@"Video";
    //self.sfondoView.image= [UIImage imageNamed:@"Assets/galileo2.jpg"];
    self.sfondoView.image=[UIImage imageNamed:@"Assets/cerisola2.jpg"];
    self.sfondoView.alpha = 0.6;
    
    
    video = [[NSMutableArray alloc] init];
    
    
    
    // [self.tableView setFrame:CGRectMake(0, 44, 320, 387)];
    // if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //   self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([video count]>0)
        return  [video count];
    
    return 6 ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    VideoCell *cell = (VideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];
    
    if([video count]>0)
    {
        
        
        NSLog(@"cel");
        
        Video * v  = [video objectAtIndex:indexPath.row];
        
        cell.title.textColor=[UIColor blackColor];
        cell.title.text = v.title;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        cell.date.text = v.data;
       
        cell.view.text = [NSString stringWithFormat:@"%@ visualizzazioni", v.numberOfView];
        // [cell.immaginePreview loadImageAtURL:[NSURL URLWithString:[[notizie objectAtIndex:indexPath.row] linkImageSmall]]];
        NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                                indexPath.row];
        
        
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.image.image = [cachedImages valueForKey:identifier];
            NSLog(@"metti immagine"); cell.play.hidden=NO;

        }
        else
        {
            cell.image.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:v.thumbnail]];
               
                if(data)
                {
                
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageWithData:data];
                        if(image)
                            [cachedImages setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            cell.play.hidden=NO;

                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                        if(image)
                            [cachedImages setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            [cell.play setHidden:NO];
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });
                }
            });
            
            
        }

        
        /*
        if([cachedImages objectForKey:identifier] != nil)
        {
            cell.image.image = [cachedImages valueForKey:identifier];
             cell.play.hidden=NO;
        }
        else
        {
            
            char const * s = [identifier  UTF8String];
            
            dispatch_queue_t queue = dispatch_queue_create(s, 0);
            
            dispatch_async(queue, ^
                           {
                               
                               NSString *url = v.thumbnail;
                               
                               UIImage *img = nil;
                               
                               NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                               
                               img = [[UIImage alloc] initWithData:data];
                               
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  
                                                  if ([self.collectionView indexPathForCell:cell].row == indexPath.row)
                                                  {
                                                      
                                                      [cachedImages setValue:img forKey:identifier];
                                                      
                                                       cell.image.image = [cachedImages valueForKey:identifier];
                                                       cell.play.hidden=NO;
                                                  }
                                              });//end
                           });//end
        }*/
    }
    //[titleLabel setText:cellData];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect");
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%d" ,
                            indexPath.row];
    
    DetailVideoViewController * detail = [[DetailVideoViewController alloc] initWithNibName:@"DetailVideoViewController" bundle:nil];
    
    
    
    detail.video = [video objectAtIndex:indexPath.row];
    detail.thumbnail = [cachedImages objectForKey:identifier];
   

    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
