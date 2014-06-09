//
//  ViewControllerOne.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ViewControllerOne.h"
#import "ViewControllerInfo.h"
#import "ViewControllerCredits.h"
#import "EventsCell.h"
#import "News.h"
#import "ParserImages.h"
#import "ParserThumbnail.h"
#import "DetailNewsViewController.h"

@interface ViewControllerOne ()
{
    NSXMLParser * parser;
    
    NSMutableArray * news;
    
    int load;
    
    NSMutableDictionary *images;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;
}
@end

@implementation ViewControllerOne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;

}
-(void) apriInfo
{
    NSLog(@"info");
    
    ViewControllerInfo * viewControllerInfo = [[ViewControllerInfo alloc] initWithNibName:@"ViewControllerInfo" bundle:nil];
    
    [self presentViewController:viewControllerInfo animated:YES completion:nil];
    
}
-(void) apriCredits

{
    ViewControllerCredits * viewControllerCredits = [[ViewControllerCredits alloc] initWithNibName:@"ViewControllerCredits" bundle:nil];
    
    [self presentViewController:viewControllerCredits animated:YES completion:nil];
    
}
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"recive data");
    
    NSError * jsonParsingError = nil;
    
    NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSDictionary * json = [jsonElement objectForKey:@"response"];
    
    NSString * urlImage = [json objectForKey:@"urlMainSplashScreen"];
    
    
    
    NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
    
    UIImage * image = [UIImage imageWithData:dataImmagine];
    
    NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
    NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];
    
    
    [NSKeyedArchiver archiveRootObject:image toFile:pathIm2 ];
    
    
    
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
    
    if([news count] == 2)
       [parser abortParsing];
    
    if ([elementName isEqualToString:@"item"]) {
        /* salva tutte le proprietà del feed letto nell'elemento "item", per
         poi inserirlo nell'array "elencoFeed" */
        
        
        ParserImages * parserImages = [[ParserImages alloc] init];
        ParserThumbnail * parserThumbnail = [[ParserThumbnail alloc] init];
        
        NSString * linkThumbnail = [parserThumbnail parse:summary];
        
        // NSString * imageLinkBig = [parserThree parse:cdata];
        
        // NSLog(@"img piccola %@ ",imageLinkSmall );
        //  NSLog(@"content %@ ",content );
        
        NSMutableArray * imagesArray = [[NSMutableArray alloc] init];
        imagesArray = [parserImages parseText:content];
        
        NSLog(@"url %d titolo %@", [imagesArray count],title);
        
        News * n = [[News alloc] init];
        // manca autore data link
        n.title = title;
        n.images = imagesArray;
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
        
        
        NSMutableString * finalContent = [[NSMutableString alloc] initWithString:[componentsToKeep componentsJoinedByString:@""]];
        [finalContent replaceOccurrencesOfString:@"&nbsp" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [finalContent length])];
       
        
        
        n.content = [self stringByDecodingXMLEntities:finalContent];
        NSLog(@"%@",n.content);
        
        [news addObject:n];
        
        
        
        //
        // NSLog(@"autore %@",imageLinkBig);
        
        
        
        
        //  news.titolo =
        
    }
    
}


-(void) loadData
{
    
    NSString * url = @"http://www.media.inaf.it/feed/";
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    
    [parser setDelegate:self];
    
    // settiamo alcune proprietà
    [parser setShouldProcessNamespaces:NO];
    [parser  setShouldReportNamespacePrefixes:NO];
    [ parser  setShouldResolveExternalEntities:NO];
    
    // avviamo il parsing del feed RSS
    [parser parse];
    
    [self.collectionView reloadData];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([news count]>0)
        return  [news count];
    
    return 6 ;
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
                
                NSData   *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: [n.images objectAtIndex:0]]];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    UIImage * image = [UIImage imageWithData:data];
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
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                            (long)indexPath.row];
    
    DetailNewsViewController * detail = [[DetailNewsViewController alloc] initWithNibName:@"DetailNewsViewController" bundle:nil];
    
    detail.news = [news objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}



-(void)viewDidAppear:(BOOL)animated
{
    if(load ==0 )
    {
        load =1;
        
        [self loadData];
    }
}

- (void)viewDidLoad
{
    news = [[NSMutableArray alloc] init];
    images = [[NSMutableDictionary alloc] init];
    
       
    self.navigationItem.title=@"INAF";

    self.sfondoView.image=[UIImage imageNamed:@"Assets/galileo2.jpg"];
    self.sfondoView.alpha = 0.6;
    
    UIButton * credits = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    [credits addTarget:self
                action:@selector(apriCredits)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * Credits = [[UIBarButtonItem alloc] initWithCustomView: credits ];
    
    self.navigationItem.leftBarButtonItem= Credits;
    
    // UIImage * bottoneSatellite = [UIImage imageNamed:@"Assets/logoINAF1.png"];
    UIImage * bottoneSatellite = [UIImage imageNamed:@"Assets/starIcon.png"];

    
    UIButton * bottone = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    [bottone addTarget:self action:@selector(apriInfo) forControlEvents:UIControlEventTouchUpInside];
    
    [bottone setImage:bottoneSatellite forState:UIControlStateNormal];
    
    [bottone setFrame:CGRectMake(310, 2, 30, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.rightBarButtonItem=buttonBar;
    
    
    // scarica immagine home
    NSString* foofile = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"immaginehome.plist"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:foofile])
    {
        NSLog(@"caso 1");
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSplashImage.php?width=768&height=395&deviceName=ipad"]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError * jsonParsingError = nil;
        
        NSDictionary * jsonElement = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        NSDictionary * json = [jsonElement objectForKey:@"response"];
        
        NSString * urlImage = [json objectForKey:@"urlMainSplashScreen"];
        
        
        
        NSData * dataImmagine = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]];
        
        UIImage * image = [UIImage imageWithData:dataImmagine];
        
        
        NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
        NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];
        
        self.logoInaf.image=image;
        
        
        [NSKeyedArchiver archiveRootObject:image toFile:pathIm2 ];
        
    }
    else
    {
        NSLog(@"caso 2");
        
        NSString * pathIm= [[NSString alloc] initWithFormat:@"immaginehome.plist"];
        NSString * pathIm2 = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:pathIm];
        
        UIImage * image =   [NSKeyedUnarchiver unarchiveObjectWithFile:pathIm2];
        
        self.logoInaf.image=image;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetSplashImage.php?width=320&height=209&deviceName=iphone"]];
        
        NSURLConnection * connection = [[NSURLConnection alloc ] initWithRequest:request delegate:self];
        
        [connection start];
        
        
    }
    
    [self.collectionView registerClass:[EventsCell class] forCellWithReuseIdentifier:@"cvCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(354, 414)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumLineSpacing:20.0];
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    [self.collectionView setCollectionViewLayout:flowLayout];

    
    
    //self.tableView.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"%@",immagine);
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
