//
//  TweetViewController.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 25/07/14.
// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


#import "TweetViewController.h"
#import <Social/Social.h>

@interface TweetViewController ()
{
    NSString * tweetHashTag, *link, *dateStart, *dateStop;
}
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    NSLog(@"%@", error.description);
    
    if(error.code!=-999)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internet connection failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        
        [alert show];
        
        [self.indicator stopAnimating];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.indicator startAnimating];
    
    NSData * response = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetAbout.php"]];
    
    NSString * resp = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://app.media.inaf.it/GetAbout.php"] encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",resp);
    
    if (response)
    {
        NSArray * jsonArray;
        
        NSError *e = nil;
        jsonArray = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error: &e];
        
        
        for(NSDictionary * d in jsonArray)
        {
            
            
            link = [d valueForKey:@"tweventurl"];
            tweetHashTag = [d valueForKey:@"twhashtag"];
            dateStart = [d valueForKey:@"twbegindate"];
            dateStop = [d valueForKey:@"twenddate"];
            
            
            
        }
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
        
        
        
        NSDate *currDate = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
              
        NSDate *tweetDateStart = [dateFormatter dateFromString:dateStart];
        NSDate *tweetDateStop = [dateFormatter dateFromString:dateStop];
      
        NSLog(@" %@ %@",dateStart,dateStop);
        NSLog(@" %@ %@",tweetDateStart,tweetDateStop);
        NSLog(@" %@",currDate);
        
        NSComparisonResult result = [currDate compare:tweetDateStart];
        
        
        int one=0,two=0;
        
        switch (result)
        
        {
                
            case NSOrderedAscending: ; break;
                
            case NSOrderedDescending: one = 1; break;
                
            case NSOrderedSame:  one = 1; break;
                
            default: ; break;        }
        
        
        NSComparisonResult result2 = [currDate compare:tweetDateStop];
        
        switch (result2)
        
        {
                
            case NSOrderedAscending: two = 1; break;
                
            case NSOrderedDescending: ; break;
                
            case NSOrderedSame: two= 1; break;
                
            default: ; break;
        }

        if(one == 1 && two == 1 && ![tweetHashTag isEqualToString:@""] && ![dateStart isEqualToString:@""] && ![dateStop isEqualToString:@""])
        {
            NSLog(@"si");
            self.navigationItem.rightBarButtonItem.enabled = YES;

        }
        else
        {
            NSLog(@"no");
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Non sono aperti eventi per inviare tweet" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
        
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Error" message:@"Change internet settings" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}
- (void)viewDidLoad
{
    
    UIButton * bottone = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [bottone addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bottone setTitle:@"Condividi Tweet" forState:UIControlStateNormal];
    
    
    UIDevice * device = [UIDevice currentDevice];
    
    if([device.systemVersion hasPrefix:@"6"])
    {
        [bottone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottone setTintColor:[UIColor blackColor]];
    }
    
    [bottone setFrame:CGRectMake(310, 2, 130, 30)];
    
    UIBarButtonItem * buttonBar = [[UIBarButtonItem alloc] initWithCustomView:bottone];
    
    self.navigationItem.rightBarButtonItem=buttonBar;

    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.webView.scalesPageToFit=YES;

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void) openAction
{
    UIActionSheet* popupQuery = [[UIActionSheet alloc] initWithTitle:@"Condividi un Tweet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet New Picture", @"Tweet Image From Library", nil]; // @"Tweet Text",
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showInView:self.view];
   

}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init] ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing=TRUE;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can not find Camera Device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
            [alertView show];
        }
    }
    if(buttonIndex == 1) {
        //[self uploadFileToServer:@"test.png"];
        //return;
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.allowsEditing=TRUE;
        [self presentViewController:picker animated:YES completion:nil];
    }
    /*if (buttonIndex == 0)
    {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat: @"#%@",tweetHashTag]];
            //[tweetSheet addImage:img];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Errore!" message:@"Controllare che le impostazioni permettano di condividere Tweet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }*/
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSData *dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],1);
    UIImage *img = [[UIImage alloc] initWithData:dataImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
       [tweetSheet setInitialText:[NSString stringWithFormat: @"#%@",tweetHashTag]];
        [tweetSheet addImage:img];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Errore!" message:@"Controllare che le impostazioni permettano di condividere Tweet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    //NSLog(@"%@",dataImage);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
