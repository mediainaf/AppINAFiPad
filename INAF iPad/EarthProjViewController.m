//
//  EarthProjViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 09/06/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "EarthProjViewController.h"
#import "Telescope.h"
#import "Annotation.h"
#import "ViewControllerAnnotation.h"

@interface EarthProjViewController ()
{
    UIButton *button;
    int load;
    int cont;
    NSMutableArray * annotations;
    CLLocationCoordinate2D  location;
    int Tag;
    ViewControllerAnnotation * va;
    NSMutableArray * telescopes;
}
@end

@implementation EarthProjViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=true&address=%@", esc_addr];
    CLLocationCoordinate2D center;
    
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        //NSLog(@"LOC RESULT: %@", result);
        NSError *e;
        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData: [result dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options: NSJSONReadingMutableContainers
                                                                     error: &e];
        NSArray *resultsArray = [resultDict objectForKey:@"results"];
        
        if(resultsArray.count > 0)
        {
            resultDict = [[resultsArray objectAtIndex:0] objectForKey:@"geometry"];
            resultDict = [resultDict objectForKey:@"location"];
            center.latitude = [[resultDict objectForKey:@"lat"] floatValue];
            center.longitude = [[resultDict objectForKey:@"lng"] floatValue];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results Found" message:@"No locations were found using, please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        
        //goes through each result
        /*for(NSDictionary *dict in resultsArray)
         {
         resultDict = [dict objectForKey:@"geometry"];
         resultDict = [resultDict objectForKey:@"location"];
         }*/
    }
    return center;
}
-(void) openTelescope : (id) sender
{
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Detail",
                            @"Open Link",
                            @"Webcam",
                            @"Call Phone Number",
                            @"Show In Navigator",
                            
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
   
    
}
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   /* switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self Detail];
                    break;
                case 1:
                    [self OpenLink];
                    break;
                case 2:
                    [self Call];
                    break;
                case 3:
                    [self Navigate];
                    break;
                    
            }
            break;
        }
        default:
            break;
    }*/
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
        NSLog(@"%d",view.tag);
        Tag=view.tag;
        
        Annotation * v = (Annotation *)view;
        ;
        
        
        CLLocationCoordinate2D cord ;
        cord.latitude=v.coordinate.latitude;
        cord.longitude=v.coordinate.longitude;
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 1;
        span.longitudeDelta = 1;
        region.span = span;
        region.center = cord;
        
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView regionThatFits:region];
        
        va = [[ViewControllerAnnotation alloc] initWithNibName:@"ViewControllerAnnotation" bundle:nil];
        
        //SMCalloutView *calloutView = (SMCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"CalloutView" owner:self options:nil] objectAtIndex:0];
        
        CGRect calloutViewFrame = va.view.frame;
        
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 +8, -calloutViewFrame.size.height-10);
        
        va.view.frame = calloutViewFrame;
        
        [va.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [va.view.layer setShadowOpacity:0.8];
        [va.view.layer setShadowRadius:3.0];
        [va.view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        
        Telescope * t = [telescopes objectAtIndex:Tag];
        
        [va.nome setText:t.name];
        [va.phone setText:t.phone];
        [va.link setText:t.link];
        [va.address setText:t.address];
        
        [view addSubview:va.view];
        
        
        
    }
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //7
    else
    {
        Annotation * an = annotation;
        
        
        
        MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation reuseIdentifier:@"current"];
        cont++;
        //customPinView.pinColor = MKPinAnnotationColorPurple;
        customPinView.animatesDrop = YES;
        customPinView.highlighted=YES;
        customPinView.draggable=YES;
        customPinView.tag=an.tag;
        
        return customPinView;
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if(load == 0)
    {
        load=1;
        
       /* NSString * url = [NSString stringWithFormat: @"http://app.media.inaf.it/GetLocations.php"];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        NSLog(@"%@",url);
        
        NSArray *jsonArray ;
        if (response) {
            
            NSError *e = nil;
            jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
            
        }
        
        for(NSDictionary * d in jsonArray)
        {
            
            NSString *ID = [d valueForKey:@"id"];
            NSString *name = [d valueForKey:@"name"];
            NSString *descr = [d valueForKey:@"descr"];
            NSString *website = [d valueForKey:@"website"];
            NSString *address = [d valueForKey:@"address"];
            NSString *phone = [d valueForKey:@"phone"];
            NSString *coord = [d valueForKey:@"coordinates"];
            
            Istituto * i = [[Istituto alloc]init];
            
            i.ID=ID;
            i.name=name;
            i.descr=descr;
            i.address=address;
            i.website=website;
            i.phone=phone;
            
            NSArray * elementi = [coord componentsSeparatedByString:@","];
            
            
            
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[elementi objectAtIndex:1] floatValue];
            coordinate.longitude = [[elementi objectAtIndex:0] floatValue];
            
            i.coord = coordinate;
            
            NSLog(@"%f %f",coordinate.longitude,i.coord.longitude);
            
            [istituti addObject:i];
        }
        
        */
        
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(42, 12), MKCoordinateSpanMake(15, 15));
        [self.mapView setRegion:region animated:YES];
        
        
        
        MKUserLocation * userlocation = self.mapView.userLocation;
        self.mapView.showsUserLocation=YES;
        
        
        {
            NSLog(@"apri mappa %d",self.mapView.hidden);
            [self.mapView removeAnnotations:annotations];
            [annotations removeAllObjects];
            
            MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, -40), MKCoordinateSpanMake(180, 360));
            [self.mapView setRegion:region animated:YES];

            
            cont=-1;
            int j = -1;
            
            for(Telescope * i in telescopes)
            {
                j++;
                
                
                Annotation * newAnnotation = [[Annotation alloc] init];
                
                newAnnotation.coordinate= i.coord;
                
                NSLog(@"%f %f",i.coord.latitude,i.coord.longitude);
                
                //newAnnotation.subtitle=i.descr;
                newAnnotation.title =i.name;
                
                newAnnotation.link =i.link;
                newAnnotation.tag=j;
                // NSLog(@"%f %f",ev.center.latitude,ev.center.longitude);
                
                [annotations addObject:newAnnotation];
                
                
            }
            [self.mapView addAnnotations:annotations];
            
        }
        NSLog(@"%d",[annotations count]);
        
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidLoad
{
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openTelescope:) ];
    
    self.navigationItem.rightBarButtonItem= refresh ;
    self.navigationItem.rightBarButtonItem.enabled=NO;
    
    self.title = @"Progetti da Terra";
    
    [self.mapView setMapType:MKMapTypeHybrid];
    
    Telescope * VLT = [[Telescope alloc] init]; VLT.name = @"Very Large Telescope";
    CLLocationCoordinate2D VLTcord; VLTcord.latitude =-24.627222; VLTcord.longitude = -70.404167;
    VLT.coord = VLTcord;
    
    Telescope * REM = [[Telescope alloc] init]; VLT.name = @"Rapid Eye Mount";
    CLLocationCoordinate2D REMcoord; REMcoord.latitude = -29.261167; REMcoord.longitude = -70.731333;
    REM.coord = REMcoord;
    
    Telescope * LBT = [[Telescope alloc] init]; VLT.name = @"Large Binocular Telescope";
    CLLocationCoordinate2D LBTcoord; LBTcoord.latitude = 32.701389; LBTcoord.longitude = -109.889444;
    LBT.coord = LBTcoord;
    
    Telescope * SRT = [[Telescope alloc] init]; VLT.name = @"Sardinia Radio Telescope";
    CLLocationCoordinate2D SRTcoord; SRTcoord.latitude = 39.492778; SRTcoord.longitude = 9.245;
    SRT.coord = SRTcoord;
    
    Telescope * TNG = [[Telescope alloc] init]; VLT.name = @"Telescopio Nazionale Galileo";
    CLLocationCoordinate2D TNGcoord; TNGcoord.latitude = 28.754; TNGcoord.longitude = -17.889056;
    TNG.coord = TNGcoord;
    
    Telescope * RM = [[Telescope alloc] init]; VLT.name = @"Radiotelescopio di Medicina";
    CLLocationCoordinate2D RMcoord; RMcoord.latitude = 44.524018; RMcoord.longitude = 11.645412;
    RM.coord = RMcoord;
    
    Telescope * MAGIC = [[Telescope alloc] init]; VLT.name = @"Major Atmospheric Gamma-ray Imaging Cherenkov Telescope";
    CLLocationCoordinate2D MAGICcoord; MAGICcoord.latitude = 28.761944; MAGICcoord.longitude = -17.89;
    MAGIC.coord = MAGICcoord;
    
    Telescope * CDN = [[Telescope alloc] init]; VLT.name = @"Croce Del Nord";
    CLLocationCoordinate2D CDNcoord; CDNcoord.latitude = 44.52359; CDNcoord.longitude = 11.64576;
    CDN.coord = CDNcoord;
    
    Telescope * RDN = [[Telescope alloc] init]; VLT.name = @"Radiotelescopio di Noto";
    CLLocationCoordinate2D RDNcoord; RDNcoord.latitude = 36.87585; RDNcoord.longitude = 14.98890;
    RDN.coord = RDNcoord;
    
    NSArray * telescopesArray = [NSArray arrayWithObjects:VLT,REM,LBT,SRT,TNG,RM,MAGIC,CDN,RDN, nil];
    
    telescopes = [[NSMutableArray alloc] init];
    [telescopes addObjectsFromArray:telescopesArray];
    
    annotations = [[NSMutableArray alloc] init];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
