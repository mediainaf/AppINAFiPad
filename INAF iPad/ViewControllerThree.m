//
//  ViewControllerThree.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerThree.h"
#import "News.h"
#import "ParserImages.h"
#import "ParserThumbnail.h"
#import "EventsCell.h"
#import "DetailEventsViewController.h"
#import "DetailNewsViewController.h"

@interface ViewControllerThree ()
{
    
    float altezzaP,altezzaL;
    
    UIRefreshControl * refreshControl;
    int page;
    
    NSXMLParser * parser;
    
    int load;
    
    NSMutableArray * news;
    
    NSMutableDictionary *images;
    
    NSMutableArray * contentArray;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;
}


@end

@implementation ViewControllerThree

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    if ([elementName isEqualToString:@"item"]) {
        
        title = [[NSMutableString alloc] init];
        author = [[NSMutableString alloc] init];
        date = [[NSMutableString alloc] init];
        summary = [[NSMutableString alloc] init];
        content = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];

        // inizializza tutti gli elementi
          }
   // NSLog(@"%@",elementName);
    
    
    
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"]){
        [title appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [summary appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
        [date appendString:string];
    } else if ([currentElement isEqualToString:@"content:encoded"]) {
        [content appendString:string];
    } else if ([currentElement isEqualToString:@"dc:creator"]) {
        [author appendString:string];
    }
    

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        /* salva tutte le proprietà del feed letto nell'elemento "item", per
         poi inserirlo nell'array "elencoFeed" */
        
        /*
        ParserImages * parserImages = [[ParserImages alloc] init];
        ParserThumbnail * parserThumbnail = [[ParserThumbnail alloc] init];
        
        NSString * linkThumbnail = [parserThumbnail parse:summary];
        
        // NSString * imageLinkBig = [parserThree parse:cdata];
        
        // NSLog(@"img piccola %@ ",imageLinkSmall );
        // NSLog(@"img grande %@ ",imageLinkBig );
        
        NSArray * imagesAndVideo = [[NSArray alloc] init];
        imagesAndVideo = [parserImages parseText:content];
        */
        dispatch_queue_t reentrantAvoidanceQueue = dispatch_queue_create("reentrantAvoidanceQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(reentrantAvoidanceQueue, ^{
            ParserImages * parserImages = [[ParserImages alloc] init];
            NSArray * imagesAndVideo = [[NSArray alloc] init];
            imagesAndVideo = [parserImages parseText:content];
            
            [self addnews:imagesAndVideo];
        });
        dispatch_sync(reentrantAvoidanceQueue, ^{ });
        
        
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
}
-(void) addnews :(NSArray *)imagesAndVideoArray
{
    NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
    imagesArray = [imagesAndVideoArray objectAtIndex:0];
    NSMutableArray * videos = [[NSMutableArray alloc] init];
    videos = [imagesAndVideoArray objectAtIndex:1];
    
    NSLog(@"url %d %d titolo %@", [imagesArray count],[videos count],title );
    
    News * n = [[News alloc] init];
    // manca autore data link
    n.title = title;
    n.images = imagesArray;
    n.videos = videos;
    //n.thumbnail = linkThumbnail;
    // news.linkImageBig = imageLinkBig;
    n.author = author;
    n.link = link;
    
    NSArray * elementiData  = [date componentsSeparatedByString:@" "];
    
    NSString * day = [elementiData objectAtIndex:1];
    NSString * DM = [day stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:2]]];
    NSString * DMY = [DM stringByAppendingString:[NSString stringWithFormat:@" %@",[elementiData objectAtIndex:3]]];
    
    
    
    //     NSLog(@"data %@",DMY);
    
    n.date = DMY;
    
    NSArray *components = [summary componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    n.summary = [componentsToKeep componentsJoinedByString:@""];
    
    
    
    components = [content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    
    
    NSMutableString * contentBeforeReplace = [[NSMutableString alloc] initWithString:[componentsToKeep componentsJoinedByString:@""]];
    [contentBeforeReplace replaceOccurrencesOfString:@"&nbsp" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [contentBeforeReplace length])];
    
    NSString * finalContent= [ NSString stringWithString:contentBeforeReplace];
    
    
    n.content = [self stringByDecodingXMLEntities:finalContent];
    
    [news addObject:n];
}

-(void) loadData
{
    [self.loadingView setHidden:NO];

    
    [news removeAllObjects];
    [images removeAllObjects];

    
    NSString * url = @"http://www.media.inaf.it/category/eventi/feed/";
    
    NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    if(!response)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];

    [self.collectionView reloadData];
    [refreshControl endRefreshing];
    [self.loadingView setHidden:YES];

    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if ([scrollView contentOffset].y >= self.collectionView.contentSize.height-self.view.frame.size.height){
        
        
        NSLog(@"reload");
        
        
            [self.loadingView setHidden:NO];
            
            [self performSelector:@selector(changePage) withObject:nil afterDelay:0.5];
         
        
    }
    
}
-(void) changePage
{
    page++;
    
    
    title = [[NSMutableString alloc] init];
    author = [[NSMutableString alloc] init];
    date = [[NSMutableString alloc] init];
    summary = [[NSMutableString alloc] init];
    content = [[NSMutableString alloc] init];
    link = [[NSMutableString alloc] init];
    
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.media.inaf.it/category/eventi/feed/?paged=%d",page]]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    
    [self.loadingView setHidden:YES];
    
}
-(void) reloadData : (id) selector
{
    
    [self.loadingView setHidden:NO];
    
    load =1;
    page = 1;
    
    
    [self loadData];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)

    {
        page = 1;
        load = 1;
        [self loadData];
    }
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(354, 414)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumLineSpacing:20.0];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setFrame:CGRectMake(0, 0,768, altezzaP)];
         self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
        
        [self.collectionView setCollectionViewLayout:flowLayout];
        
        // [self.collectionView reloadData];
        
        
    }
    else
    {
        if(orientation == 3 || orientation == 4)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            //[flowLayout setItemSize:CGSizeMake(354, 414)];
            [flowLayout setItemSize:CGSizeMake(314, 367)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [flowLayout setMinimumLineSpacing:20.0];
            [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
            
           [self.collectionView setFrame:CGRectMake(0, 0,1024, altezzaL)];
            
            // [self.collectionView setFrame:CGRectMake(0, 0, 1024, 668)];
          
            
            self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNewsL.png"];
            
            [self.collectionView setCollectionViewLayout:flowLayout];
            
            //  [self.collectionView reloadData];
            
        }
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self deviceOrientationDidChangeNotification:nil];
    
    //[self.collectionView setContentOffset:CGPointZero animated:YES];
    
    [refreshControl removeFromSuperview];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl setTintColor:[UIColor whiteColor]];
    
    self.collectionView.alwaysBounceVertical = YES;


}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"ruota");
    
    if(fromInterfaceOrientation == 3 || fromInterfaceOrientation == 4)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(354, 414)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [flowLayout setMinimumLineSpacing:20.0];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
        // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [self.collectionView setFrame:CGRectMake(0, 0,768, altezzaP)];
        self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
        
        [self.collectionView setCollectionViewLayout:flowLayout];
        
        // [self.collectionView reloadData];
        
        
    }
    else
    {
        if(fromInterfaceOrientation == 1 || fromInterfaceOrientation == 2)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            //[flowLayout setItemSize:CGSizeMake(354, 414)];
            [flowLayout setItemSize:CGSizeMake(314, 367)];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            [flowLayout setMinimumLineSpacing:20.0];
            [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
            
            [self.collectionView setFrame:CGRectMake(0, 0,1024, altezzaL)];
            
            // [self.collectionView setFrame:CGRectMake(0, 0, 1024, 668)];
            
            
            self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNewsL.png"];
            
            [self.collectionView setCollectionViewLayout:flowLayout];
            
            //  [self.collectionView reloadData];
            
        }
    }
    
   // [self.collectionView setContentOffset:CGPointZero];

}
-(void) refresh
{
    [self performSelector:@selector(reloadData:) withObject:nil afterDelay:0.5];
}
- (void)viewDidLoad
{
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"7"])
    {
        altezzaP = 924.0;
        altezzaL = 668.0;
    }
    else
    {
        altezzaP = 931.0;
        altezzaL = 675.0;
    }
    

    
    
    
    [self.collectionView setContentOffset:CGPointMake(0, -refreshControl.frame.size.height) animated:YES];
    [refreshControl beginRefreshing];
    

    
    int orientation= [UIApplication sharedApplication].statusBarOrientation;
    
    
    
    if(orientation == 1 || orientation == 2)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(354, 414)];
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
            [flowLayout setItemSize:CGSizeMake(314, 367)];
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

    
    //self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
    
    //[self.loadingView setHidden:NO];
    
    //UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData) ];
    
    //self.navigationItem.rightBarButtonItem= refresh ;
        load = 0;
    self.title = @"Events";
    
    [self.collectionView registerClass:[EventsCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(354, 414)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:20.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];

    
    news = [[NSMutableArray alloc] init];
    images = [[NSMutableDictionary alloc] init];
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo3.jpg"];
    self.sfondoView.alpha = 0.6;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([news count]>0)
        return  [news count];
    
    return 6 ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    EventsCell *cell = (EventsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor colorWithWhite:0.9 alpha:0.7];
    
    if([news count]>0)
    {
        
        
        NSLog(@"cel");
        
        News * n  = [news objectAtIndex:indexPath.row];
        
        cell.title.textColor=[UIColor blackColor];
        cell.title.text = n.title;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        cell.date.text = n.date;
        cell.descriptionText.text = n.summary;
        cell.author.text = [NSString stringWithFormat:@"di %@",n.author];
                // [cell.immaginePreview loadImageAtURL:[NSURL URLWithString:[[notizie objectAtIndex:indexPath.row] linkImageSmall]]];
        NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                                (long)indexPath.row];
        
        if([images objectForKey:identifier] != nil)
        {
            cell.thumbnail.image = [images valueForKey:identifier];
            NSLog(@"metti immagine");
            [cell.indicator stopAnimating];
        }
        else
        {
            [cell.indicator startAnimating];
            cell.thumbnail.image = nil;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                //NSData   *data;
                if([n.images count]>0)
                {
                    
                    NSString * imageUrl =  [n.images objectAtIndex:0] ;
                    
                    NSArray * elements = [ imageUrl componentsSeparatedByString:@"/"];
                    
                    int number = [elements count];
                    
                    NSString * url = [NSString stringWithFormat:@"http://app.media.inaf.it/GetMediaImage.php?sourceYear=%@&sourceMonth=%@&sourceName=%@&width=354&height=201",[elements objectAtIndex:number-3],[elements objectAtIndex:number-2],[elements objectAtIndex:number-1]];
                    
                    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                    
                    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    
                    if(response != nil)
                    {
                        
                        NSError * jsonParsingError = nil;
                        
                        NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
                        
                        NSDictionary * json = [jsonElement objectForKey:@"response"];
                        
                        NSString * urlImage = [json objectForKey:@"urlResizedImage"];
                        
                        NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            NSLog(@"%@",[n.images objectAtIndex:0]);
                            
                            
                            
                            UIImage * image = [UIImage imageWithData:dataImmagine];
                             if(image)
                                [images setObject:image forKey:identifier];
                            //cell.thumbnail.image = image;
                            [cell setNeedsLayout];
                        
                            if(indexPath.row  < [news count])
                            {
                                [UIView setAnimationsEnabled:NO];
                                
                                [self.collectionView performBatchUpdates:^{
                                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                                    [cell.indicator stopAnimating];
                                } completion:^(BOOL finished) {
                                    [UIView setAnimationsEnabled:YES];
                                }];
                            }
                            
                        });
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                            if(image)
                                [images setObject:image forKey:identifier];
                            //cell.thumbnail.image = image;
                            [cell setNeedsLayout];
                            if(indexPath.row  < [news count])
                            {

                                [UIView setAnimationsEnabled:NO];
                                
                                [self.collectionView performBatchUpdates:^{
                                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                                    [cell.indicator stopAnimating];
                                } completion:^(BOOL finished) {
                                    [UIView setAnimationsEnabled:YES];
                                }];
                            }
                            
                        });
                        
                        
                    }

                    

                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                         if(image)
                            [images setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            [cell.indicator stopAnimating];
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });
                    
                }
            });
            
        }

        
      
    }
    //[titleLabel setText:cellData];
    
    return cell;
}
- (NSString *)stringByDecodingXMLEntities: (NSString*) string {
    
    NSUInteger myLength = [string length];
    NSUInteger ampIndex = [string rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return string;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect");
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                            (long)indexPath.row];
    
    DetailEventsViewController * detail = [[DetailEventsViewController alloc] initWithNibName:@"DetailEventsViewController" bundle:nil];
    
    detail.event = [news objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
