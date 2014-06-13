//
//  ViewControllerTwo.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerTwo.h"
#import "News.h"
#import "ParserImages.h"
#import "ParserThumbnail.h"
#import "EventsCell.h"
#import "DetailNewsViewController.h"



@interface ViewControllerTwo ()
{
    UIPopoverController * popOverController;
    UIToolbar * toolBar;
    NSArray * telescopes;
    NSArray * telescopesTag;
    NSArray * institutes;
    NSArray * institutesTag;
    NSArray * satellites;
    NSArray * satellitesTag;
    UIPickerView * pickerView;
    int popAperto;
    UISegmentedControl *segmentedControl;
    int pickerRowSelected;
    int segmentSelected;
    
    NSXMLParser * parser;
    
    NSMutableArray * news;
    
    int load;
    
    NSMutableDictionary *images;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;
}


@end

@implementation ViewControllerTwo

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
        
        
        ParserImages * parserImages = [[ParserImages alloc] init];
        ParserThumbnail * parserThumbnail = [[ParserThumbnail alloc] init];
        
        NSString * linkThumbnail = [parserThumbnail parse:summary];
        
        // NSString * imageLinkBig = [parserThree parse:cdata];
        
        // NSLog(@"img piccola %@ ",imageLinkSmall );
       //  NSLog(@"content %@ ",content );
        
        NSArray * imagesAndVideoArray = [[NSArray alloc] init];
        imagesAndVideoArray = [parserImages parseText:content];
        
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
        n.thumbnail = linkThumbnail;
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
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
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

-(void) loadData : (NSString *) url
{
    
    [news removeAllObjects];
    [images removeAllObjects];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    self.loadingView.alpha = 0.0;
    
}


-(void)viewDidAppear:(BOOL)animated
{
    if(load ==0 )
    {
        self.loadingView.alpha = 1.0;

        load =1;
        pickerRowSelected = 0;
        segmentedControl =0;

        [self loadData:@"http://www.media.inaf.it/feed/"];
        
    }
}

-(void) segmentChanged : (id) segment
{
    segmentSelected = segmentedControl.selectedSegmentIndex;
    [pickerView reloadAllComponents];
}

-(void) apriFiltri
{
    if(!popOverController.popoverVisible)
    {
        NSLog(@"apri pop");
        popAperto=1;
         pickerView=[[UIPickerView alloc]init];
        
        toolBar = [[UIToolbar alloc] init];
        
        UIViewController * popOverContent = [[UIViewController alloc] init];
        UIView * popOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,446 , 300)];
        
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Sedi",@"Progetti da Terra",@"Progetti Spaziali", nil]];
        
        segmentedControl.frame = CGRectMake(41, 68, 364, 30);
        segmentedControl.tintColor = [UIColor blackColor];

        [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = segmentSelected;
        [popOverView addSubview:segmentedControl];
        
        pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,104, 446, 216)];
        pickerView.delegate=self;
        pickerView.dataSource=self;
        pickerView.showsSelectionIndicator=YES;
        [pickerView selectRow:pickerRowSelected inComponent:0 animated:YES];
        [popOverView addSubview:pickerView];
        
        toolBar =[[UIToolbar alloc] initWithFrame:CGRectMake([popOverView frame].origin.x, [popOverView frame].origin.y, [popOverView frame].size.width, 44)];
        
        if([[UIDevice currentDevice].systemVersion hasPrefix:@"7"])
        {
            toolBar.tintColor=[UIColor blackColor];
        }
        
        
        UIBarButtonItem * flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(chiudiPop)];
        
        [toolBar setItems:[NSArray arrayWithObjects:flexSpace,done, nil]];
        
        [popOverView addSubview:toolBar];
        [popOverContent setView:popOverView];
        
        popOverController = [[UIPopoverController alloc] initWithContentViewController:popOverContent];
        popOverController.popoverContentSize = CGSizeMake(446,300);
         popOverController.delegate=self;
        
        [popOverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        
    }

}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    pickerRowSelected = row;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([segmentedControl selectedSegmentIndex] == 0)
        return [institutes count];
    if([segmentedControl selectedSegmentIndex] == 1)
        return [telescopes count];
    if([segmentedControl selectedSegmentIndex] == 2)
        return [satellites count];
    
    return  0;
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([segmentedControl selectedSegmentIndex] == 0)
        return [institutes objectAtIndex:row];
    if([segmentedControl selectedSegmentIndex] == 1)
        return [telescopes objectAtIndex:row];
    if([segmentedControl selectedSegmentIndex] == 2)
        return [satellites objectAtIndex:row];
    
    return @"";
}
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 400;
}
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"should dismis pop");
    
    return  YES;
    
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"dismis pop");
    
}

-(void) chiudiPop
{
    [popOverController dismissPopoverAnimated:YES];
    
    self.loadingView.alpha = 1.0;
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       
        if([segmentedControl selectedSegmentIndex] == 0)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[institutesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 1)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[telescopesTag objectAtIndex:pickerRowSelected]]];
        }
        if([segmentedControl selectedSegmentIndex] == 2)
        {
            if(pickerRowSelected == 0)
                [self loadData:@"http://www.media.inaf.it/feed/"];
            else
                [self loadData:[NSString stringWithFormat:@"http://www.media.inaf.it/tag/%@/feed/",[satellitesTag objectAtIndex:pickerRowSelected]]];
        }

        
    });
    
    
    

}
- (void)viewDidLoad
{
    self.loadingView.image = [UIImage imageNamed:@"Assets/loadingNews.png"];
    self.loadingView.alpha = 0.0;
    
   

    telescopes = [NSArray arrayWithObjects:@"Tutte le news",@"VLT Survey Telescope",@"REM (Rapid Eye Mount)",@"Large Binocular Telescope (LBT)",nil];
    satellites = [NSArray arrayWithObjects:@"Tutte le news",@"SOHO",@"Cassini Huygens",@"Cluster",@"Mars Express",@"Rosetta", nil];
    institutes = [NSArray arrayWithObjects:@"Tutte le news",@"Osservatorio di Torino",@"Osservatorio di Brera",@"IASF Milano",@"Osservatorio di Padova",@"Osservatorio di Trieste",@"Osservatorio di Bologna",@"IRA Bologna", nil];
    
    //,@"IASF Bologna",@"Osservatorio di Arcetri (FI)",@"Osservatorio di Teramo",@"Osservatorio di Roma",@"IAPS Roma",@"Osservatorio di Capodimonte (NA)",@"Osservatorio di Cagliari",@"Osservatorio di Palermo",@"IASF Palermo",@"Osservatorio di Catania"
    
    institutesTag = [NSArray arrayWithObjects:@"",@"oa_torino",@"oa_brera",@"iasf_milano",@"oa_padova",@"oa_trieste",@"oa_bologna",@"ira_bologna", nil];
    satellitesTag = [NSArray arrayWithObjects:@"",@"soho",@"cassini",@"cluster",@"mars-express",@"rosetta", nil];
    telescopesTag = [NSArray arrayWithObjects:@"",@"vst",@"rem",@"lbt",nil];
    
    
    
    
    
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData:) ];
    
    self.navigationItem.rightBarButtonItem= refresh ;
    
    UIBarButtonItem * filtri = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(apriFiltri) ];
    
    self.navigationItem.leftBarButtonItem= filtri ;

    
    load = 0;
    self.title = @"News";
    
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
    
    self.sfondoView.image = [UIImage imageNamed:@"Assets/galileo4.jpg"];
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
        
        
       
        
        News * n  = [news objectAtIndex:indexPath.row];
        
        cell.title.textColor=[UIColor blackColor];
        cell.title.text = n.title;
        //sNSLog(@"%lu",(unsigned long)[notizie count]);
        cell.date.text = n.date;
        cell.description.text = n.summary;
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
            cell.thumbnail.image = nil;
            [cell.indicator startAnimating];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,  0ul);
            dispatch_async(queue, ^{
                //This is what you will load lazily
                
                NSData   *data;
                if([n.images count]>0)
                {
                    data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [n.images objectAtIndex:0]]];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageWithData:data];
                        [images setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            [cell.indicator startAnimating];
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        
                        UIImage * image = [UIImage imageNamed:@"Assets/newsDefault.png"];
                        [images setObject:image forKey:identifier];
                        //cell.thumbnail.image = image;
                        [cell setNeedsLayout];
                        [UIView setAnimationsEnabled:NO];
                        
                        [self.collectionView performBatchUpdates:^{
                            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                            [cell.indicator startAnimating];
                        } completion:^(BOOL finished) {
                            [UIView setAnimationsEnabled:YES];
                        }];
                        
                    });

                }
                    
               
            });
            
        }
   
       /*
        
        
        if([images objectForKey:identifier] != nil)
        {
            cell.thumbnail.image = [images valueForKey:identifier];
             NSLog(@"metti immagine");
        }
        else if([n.images count]>0)
        {
            //NSLog(@"scarica immagine");
            
            char const * s = [identifier  UTF8String];
            
            dispatch_queue_t queue = dispatch_queue_create(s, 0);
            
            dispatch_async(queue, ^
                           {
                               
                               NSString *url = [n.images objectAtIndex:0];
                               
                               UIImage *img = nil;
                               
                               NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                               
                               img = [[UIImage alloc] initWithData:data];
                               
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  
                                                  if ([self.collectionView indexPathForCell:cell].row == indexPath.row)
                                                  {
                                                      NSLog(@"carica %@",identifier);

                                                      [images setValue:img forKey:identifier];
                                                      
                                                      cell.thumbnail.image = [images valueForKey: identifier ];
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
    
    
    DetailNewsViewController * detail = [[DetailNewsViewController alloc] initWithNibName:@"DetailNewsViewController" bundle:nil];
    
    detail.news = [news objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
