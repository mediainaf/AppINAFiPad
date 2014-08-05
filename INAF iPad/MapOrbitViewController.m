//
//  MapOrbitViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 12/06/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "MapOrbitViewController.h"
#import "Satellite.h"
#import "Annotation.h"

@interface MapOrbitViewController ()
{
    int followSatellite;
    
    NSMutableArray * satellites;
    NSMutableArray * annotations;
    
    UIPopoverController * popOverController;
    UIToolbar * toolBar;
    
    UIPickerView * pickerView;
    int popAperto;
    int pickerRowSelected;

    
    NSXMLParser * parser;
    
    NSMutableArray * news;
    
    int load;
    
    NSMutableDictionary *images;
    
    NSMutableString * title, *author, * date, *summary ,*content, *link, *currentElement;
}

@end

@implementation MapOrbitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





const double DEG2RAD = M_PI / 180.;

const double mu = 398600.8;            // in km3 / s2
const double radiusearthkm = 6378.135; // km
const double xke = 0.07436691613;      // 60.0 / sqrt(radiusearthkm*radiusearthkm*radiusearthkm/mu)
const double vkmpersec = 7.9053705078; // radiusearthkm * xke/60.0
const double tumin = 13.446839697;     // 1.0 / xke
const double j2 =   0.001082616;
const double j3 =  -0.00000253881;
const double j4 =  -0.00000165597;
const double j3oj2  =  -0.00234506972; // j3 / j2
const double sfour  = 1.0122292802;    // 78.0 / radiusearthkm + 1.0
const double qzms24 = 1.880279159e-09; // ((120.0 - 78.0) / radiusearthkm)**4
const double x2o3   =  2. / 3.;

double XINCL;
double XNODE0;
double E0;
double OMEGA0;
double XM0;
double TSINCE;

double aycof, xlcof, argpdot, mdot, nodedot;
double ao, cosio, sinio, eccsq, omeosq, rteosq;
double gmst;

void readTLE(const char *line1, const char *line2)
{   double EPOCH, XN0;
    
    sscanf(line1+18, "%lf", &EPOCH);
    sscanf(line2+9, "%lf %lf %lf %lf %lf %lf", &XINCL, &XNODE0, &E0, &OMEGA0, &XM0, &XN0);
    
    E0*=1.e-7;
    eccsq  = E0 * E0;
    omeosq = 1. - eccsq;
    rteosq = sqrt(omeosq);
    
    XINCL *= DEG2RAD;
    cosio  = cos(XINCL);
    sinio  = sin(XINCL);
    
    XNODE0 *= DEG2RAD;
    OMEGA0 *= DEG2RAD;
    XM0 *= DEG2RAD;
    
    XN0 *= 2 * M_PI / 1440.;
    double cosio2 = cosio * cosio;
    double cosio4 = cosio2 * cosio2;
    double ak     = pow(xke / XN0, x2o3);
    double d1     = 0.75 * j2 * (3. * cosio2 - 1.) / (rteosq * omeosq);
    double del    = d1 / (ak * ak);
    double adel   = ak * (1. - del * (1./3. + del * (1. + 134./81. * del)));
    double ndel   = d1 / (adel * adel);
    XN0  /= 1.0 + ndel;
    
    /* ------------------- calculate GMST at epoch ----------------- */
    double dummy, fday = 1000.*modf(EPOCH/1000., &dummy);
    long y = 1999L + (long)dummy;  // 0 AD does not exist!!!
    long A = y / 100L, B = 2 - A + A/4;
    double jd = floor(365.25*y) + floor(30.6001*14) + 1720994.5 + B + fday;  // Jan => 14!
    double UT = fmod(jd+0.5, 1.);  //  universal time
    double TU = (jd - 2451545. - UT) / 36525.;  // centuries
    gmst = 24110.54841 + TU * (8640184.812866 + TU * (0.093104 - TU * 6.2E-6));
    gmst = fmod(gmst + 86400.*1.00273790934*UT, 86400.);  // GMST in seconds
    gmst*= 2. * M_PI / 86400.;  //  GMST in degrees
    
    // days between Jan 1st and Jan 1st, 2011
    long days = ((long)dummy-11L)*365L + ((long)dummy-9L)/4L;
    fday = modf(fday, &dummy);
    // add days of the year
    fday+= days+(long)dummy-1L;
    TSINCE = 86400.*fday;
    
    /* ------------- calculate auxiliary epoch quantities ---------- */
    ao    = pow(xke / XN0, x2o3);
    double po     = ao * omeosq;
    double con42  = 1.0 - 5.0 * cosio2;
    double pinvsq = 1.0 / po / po;
    double temp1  = 1.5 * j2 * pinvsq * XN0;
    double temp2  = 0.5 * temp1 * j2 * pinvsq;
    double temp3  = -0.46875 * j4 * pinvsq * pinvsq * XN0;
    mdot = XN0 - 0.5 * temp1 * rteosq * (con42 + 2*cosio2)
    + 0.0625 * temp2 * rteosq * (13.0 - 78.0 * cosio2 + 137.0 * cosio4);
    argpdot = -0.5 * temp1 * con42 + 0.0625 * temp2 * (7.0 - 114.0 * cosio2 + 395.0 * cosio4)
    + temp3 * (3.0 - 36.0 * cosio2 + 49.0 * cosio4);
    nodedot = -temp1*cosio + (0.5 * temp2 * (4.0 - 19.0 * cosio2) +
                              2.0 * temp3 * (3.0 - 7.0 * cosio2)) * cosio;
    
    if (fabs(cosio+1.0) > 1.5e-12) // fix for xinc0 close to 180deg
        xlcof = -0.25 * j3oj2 * sinio * (3.0 + 5.0 * cosio) / (1.0 + cosio);
    else xlcof = -0.25 * j3oj2 * sinio * (3.0 + 5.0 * cosio) / 1.5e-12;
    aycof   = -0.5 * j3oj2 * sinio;
}

void getLatLong(double *lat, double *lon)
{   /* ----------- find the number of minutes since EPOCH ---------- */
    time_t now = time(NULL);
    struct tm *ptm = gmtime(&now);
    long year = ptm->tm_year-100L,
    days = (year-11L)*365L + (year-9L)/4L + ptm->tm_yday;
    double secs = (((days*24)+ptm->tm_hour)*60+ptm->tm_min)*60+ptm->tm_sec;
    double mins=(secs-TSINCE)/60.;
    
    /* ------- update for secular gravity and atmospheric drag ----- */
    double mm  = fmod(XM0 + mdot * mins, 2*M_PI);
    double argpm = fmod(OMEGA0 + argpdot * mins, 2*M_PI);
    double nodem = fmod(XNODE0 + nodedot * mins, 2*M_PI);
    
    /* -------------------- add lunar-solar periodics -------------- */
    double axnl = E0 * cos(argpm);
    double norm = 1.0 / (ao * omeosq);
    double aynl = E0 * sin(argpm) + norm * aycof;
    
    /* --------------------- solve kepler's equation --------------- */
    double u    = fmod(mm + argpm + norm * xlcof * axnl, 2*M_PI);
    double eo1  = u;
    double tem5 = 9999.9, coseo1, sineo1;
    int ktr = 0;
    for (ktr =0; ktr<10 && fabs(tem5)>1.0e-12; ktr++)
    {   sineo1 = sin(eo1);
        coseo1 = cos(eo1);
        tem5   = (u - aynl*coseo1 + axnl*sineo1 - eo1) / (1. - coseo1*axnl - sineo1*aynl);
        if (tem5>0.95) tem5=0.95;
        else if (tem5<-0.95) tem5=-0.95;
        eo1 += tem5; }
    
    /* --------------------- orientation vectors ------------------- */
    double el2    = 1.0 - axnl*axnl - aynl*aynl;
    double rl     = 1.0 - axnl*coseo1 - aynl*sineo1;
    double esbe   = (axnl*sineo1 - aynl*coseo1) / (1.0 + sqrt(el2));
    double sinu   = (sineo1 - aynl - axnl * esbe) / rl;
    double cosu   = (coseo1 - axnl + aynl * esbe) / rl;
    double sin2u  = 2.0 * cosu * sinu;
    double cos2u  = 1.0 - 2.0 * sinu * sinu;
    double pl     = ao*el2;
    double j2pl2  = 0.5 * j2 / pl / pl;
    double su    =  atan2(sinu, cosu) - 0.25 * j2pl2 * sin2u * (7.0*cosio*cosio - 1.0);
    double xnode =  nodem + 1.5 * j2pl2 * cosio * sin2u;
    double xinc  =  XINCL + 1.5 * j2pl2 * cosio * sinio * cos2u;
    double sinsu =  sin(su);
    double cossu =  cos(su);
    double snod  =  sin(xnode);
    double cnod  =  cos(xnode);
    double cosi  =  cos(xinc);
    double ux    = -snod * cosi * sinsu + cnod * cossu;
    double uy    =  cnod * cosi * sinsu + snod * cossu;
    double uz    =  sin(xinc) * sinsu;
    
    /* --------- compute the latitude and the longitude ------------ */
    *lat = asin(uz/sqrt(ux*ux+uy*uy+uz*uz))/DEG2RAD;
    *lon = (atan2(uy, ux) - gmst - 7.29211510e-5*60*mins)/DEG2RAD;
    *lon = fmod(*lon, 360);
    if (*lon<-180.) *lon+=360.;
    else if (*lon>180.) *lon-=360.;
}


-(void) goToRegion
{
    
    
    MKCoordinateRegion  satelliteRegion  ;
    
    int ID = pickerRowSelected;
    
   // NSLog(@"id %d",ID);
    
    if(ID !=0)
    {
        followSatellite =0 ;
        Annotation * a = [annotations objectAtIndex:ID-1];
        
        satelliteRegion.center.latitude = a.coordinate.latitude;
        satelliteRegion.center.longitude = a.coordinate.longitude;
        
        satelliteRegion.span.latitudeDelta= 20.0;
        satelliteRegion.span.longitudeDelta=20.0;
        
        [self.mapView setRegion:satelliteRegion animated:YES];
    }
    
}

-(void) calcolaPosizione
{
    
    int count = -1;
    
    for(Satellite *s in satellites)
    {
        count++;
        
        
        const char * line1 = [s.line1 UTF8String];
        const char * line2 = [s.line2 UTF8String];
        
        
        double LAT, LON;
        readTLE(line1, line2);
        getLatLong(&LAT, &LON);
        //printf("%f %f\n", LAT, LON);
        
        
        
        CLLocationCoordinate2D  coordinate ;
        coordinate.latitude=LAT;
        coordinate.longitude=LON;
        
        //[self.mapView removeAnnotation:self.satellite];
        
        Annotation * ann = [annotations objectAtIndex:count];
        
        ann.coordinate = coordinate;
        ann.title = s.name;
        
    
        //[self.mapView removeAnnotation:ann];
        [self.mapView addAnnotation:ann];
        
        
            
        /*
        if(Switch.on)
            printf("YES");
        else
            printf("NO");
        
        if(Switch.on)
            [self posizionaRegione];
        */
        /*struct tm  now ;
         asctime(&now);
         
         self.dateTimeLabel.text=[NSString stringWithFormat:@"Date/Time: %d a %d a %d",now.tm_mday,now.tm_hour,now.tm_min];
         */
        
       // [self.indicator stopAnimating];
    }
    
    if(followSatellite == 1 && popOverController.popoverVisible == NO)
       [self goToRegion];
}
+ (CGFloat)annotationPadding;
{
    return 5.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self setMapView:nil];
    
    [self.timer invalidate];
    
    [super viewDidDisappear:YES];
}
-(void) satelliteTouched : (id) button
{
    
    UIButton * buttonTouched = button;
    
    pickerRowSelected = buttonTouched.tag;
    
    //NSLog(@"button tag %d",buttonTouched.tag);
    
    followSatellite = 1;
}
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"annotationIdentifier"];
    annotationView.canShowCallout = YES;
    //[annotationView setSelected:YES];
    
    
    Annotation * a = annotation;
    
    UIImage *flagImage = [UIImage imageNamed:[NSString stringWithFormat:@"Assets/satellitiIcone/%d.png",a.tag+1]];
    
    // size the flag down to the appropriate size
    CGRect resizeRect;
    resizeRect.size = flagImage.size;
    CGSize maxSize = CGRectInset(self.view.bounds,
                                 [MapOrbitViewController annotationPadding],
                                 [MapOrbitViewController annotationPadding]).size;
    
    maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapOrbitViewController calloutHeight];
    if (resizeRect.size.width > maxSize.width)
        resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
    if (resizeRect.size.height > maxSize.height)
        resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
    
    resizeRect.origin = CGPointMake(0.0, 0.0);
    UIGraphicsBeginImageContext(resizeRect.size);
    [flagImage drawInRect:resizeRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    annotationView.image = resizedImage;
    annotationView.opaque = NO;
    
    
    UIImage * bottoneSatellite = [UIImage imageNamed:@"Assets/iconaMarker.png"];
    
    UIButton * bottone;
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"7"])
    {
        bottone = [UIButton buttonWithType:UIButtonTypeInfoDark];
          [bottone setImage:bottoneSatellite forState:UIControlStateNormal];
    }
    else
    {
        bottone = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    bottone.tag = a.tag+1;
    
   // NSLog(@" tag %d",bottone.tag);
    
    [bottone addTarget:self action:@selector(satelliteTouched:) forControlEvents:UIControlEventTouchUpInside];
    
  
    
    //[bottone setFrame:CGRectMake(310, 2, 30, 30)];
    
   

    annotationView.rightCalloutAccessoryView=bottone;
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.multipleTouchEnabled = NO;
    
    return annotationView;
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"appear");
    
    self.timer = [NSTimer  scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(calcolaPosizione)
                                                 userInfo:nil
                                                  repeats:YES];
    
    
    followSatellite = 0;
    //[self posizionaRegione];
    
    
}

-(void)  openSatellites
{
    if(!popOverController.popoverVisible)
    {
        NSLog(@"apri pop");
        popAperto=1;
        pickerView=[[UIPickerView alloc]init];
        
        toolBar = [[UIToolbar alloc] init];
        
        UIViewController * popOverContent = [[UIViewController alloc] init];
        UIView * popOverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,300 , 260)];
        
        
       
        
        pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0,44, 300, 216)];
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
        popOverController.popoverContentSize = CGSizeMake(300,260);
        popOverController.delegate=self;
        
        [popOverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else
    {
        
    }

}
-(void) chiudiPop
{
    
    [popOverController dismissPopoverAnimated:YES];
    
    if (pickerRowSelected !=0)
        followSatellite=1;
    else
    {
        
        followSatellite=0;
    }
    
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    pickerRowSelected = row;
    if(row !=0)
         [self.mapView selectAnnotation:[annotations objectAtIndex:row-1] animated:YES];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    return  [satellites count]+1;
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row!=0)
    {
        Satellite * s = [satellites objectAtIndex:row-1];
      
        return s.name;
    }
    return @"Tutti";
}
-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    if(fromInterfaceOrientation == 3 || fromInterfaceOrientation == 4)
    {
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, -40), MKCoordinateSpanMake(180, 360));
        [self.mapView setRegion:region animated:YES];

    }
    if(fromInterfaceOrientation == 1 || fromInterfaceOrientation == 2)
    {
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, 140), MKCoordinateSpanMake(180, 360));
        [self.mapView setRegion:region animated:YES];

    }
    
    
    NSLog(@" %f %f",self.mapView.region.center.latitude,self.mapView.region.center.longitude);

}
- (void)viewDidLoad
{
    
    [self.mapView setMapType:MKMapTypeHybrid];
    
    
    
    UIImage * buttonMarker = [UIImage imageNamed:@"Assets/iconaMarker.png"];
    
    UIButton * bottone;
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"6"])
    {
        bottone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    else
    {
        bottone = [UIButton buttonWithType:UIButtonTypeInfoDark];
    }

    
    
    
    [bottone addTarget:self action:@selector(openSatellites) forControlEvents:UIControlEventTouchUpInside];
    
    [bottone setImage:buttonMarker forState:UIControlStateNormal];
    
    [bottone setFrame:CGRectMake(310, 2, 30, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.rightBarButtonItem=buttonBar;

    
    self.title = @"Orbite Satelliti";
    
   // MKCoordinateRegion worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
    //self.mapView.region = worldRegion;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0, -40), MKCoordinateSpanMake(180, 360));
    [self.mapView setRegion:region animated:YES];


    
    satellites = [[NSMutableArray alloc] init];
    
    const char * line1 = "1 31135U 07013A   14163.34680237  .00005153  00000-0  18593-3 0  9849";
    const char * line2 = "2 31135 002.4637 352.3052 0016887 246.2767 113.5792 15.19897183395266";

    
    Satellite * s1 = [[Satellite alloc] init:[NSString stringWithUTF8String:line1] :[NSString stringWithUTF8String:line2]  :@"AGILE" ];
    
    [satellites addObject:s1];
    
   const char * line3 = "1 33053U 08029A   14161.76628270  .00001306  00000-0  63609-4 0  5886";
   const char * line4 = "2 33053 025.5822 296.4061 0013102 145.0912 215.0483 15.08435056330496";
    

    Satellite * s2 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"FERMI" ];
    
    [satellites addObject:s2];
    
     line3 = "1 27540U 02048A   14162.82361356  .00001041  00000-0  00000+0 0  5025";
     line4 = "2 27540 056.2995 239.1140 8397945 257.4318 000.3039 00.33349459 10388";
    
    
    Satellite * s3 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"INTEGRAL" ];
    
    [satellites addObject:s3];
    
    line3 = "1 25867U 99040B   14165.24932237 -.00000272  00000-0  00000+0 0   283";
    line4 = "2 25867 076.8702 320.8309 8118375 274.2524 359.9080 00.37800584 11904";
    
    
    Satellite * s4 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"CHANDRA" ];
    
    [satellites addObject:s4];
    
    line3 = "1 28485U 04047A   14162.46649644  .00002050  00000-0  13073-3 0  7047";
    line4 = "2 28485 020.5562 256.8927 0012973 038.0784 322.0564 14.98862278522332";
    
    
    Satellite * s5 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"SWIFT" ];
    
    [satellites addObject:s5];
    
    line3 = "1 25989U 99066A   14162.83713824  .00000041  00000-0  00000+0 0  6411";
    line4 = "2 25989 065.2736 056.8723 7695797 093.6205 359.6003 00.50127112 15360";
    
    
    Satellite * s6 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"XMM NEWTON" ];
    
    [satellites addObject:s6];
    
    line3 = "1 29678U 06063A   14162.19373516  .00000425  00000-0  96034-4 0  4369";
    line4 = "2 29678 090.0189 011.6656 0203110 239.5882 262.3331 14.42990413381076";
    
    
    Satellite * s7 = [[Satellite alloc] init:[NSString stringWithUTF8String:line3] :[NSString stringWithUTF8String:line4]  :@"COROT" ];
    
    [satellites addObject:s7];



    
    annotations = [[NSMutableArray alloc ] init];
    
    for(int i = 0; i<[satellites count]; i++)
    {
        Annotation * a = [[Annotation alloc] init];
        
        a.tag = i;
         
        [annotations addObject:a];
    }
 
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
