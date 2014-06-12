//
//  ParserImages.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ParserImages.h"


@interface ParserImages ()
{
    NSXMLParser * parser;
    NSString * imPath;
    NSString * video;
    NSMutableArray * images;
    NSMutableArray * videos;
}

@end

@implementation ParserImages

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"error %@",parseError.description);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
   // NSLog(@"elemento %@",elementName);
    
  //  NSLog(@"%@",attributeDict);
    if([elementName isEqualToString:@"img"]){
        
        //   NSLog(@"elemento2");
      
        imPath=[attributeDict valueForKey:@"src"];
       //   NSLog(@"url %@", imPath );
        [images addObject:imPath];
        //  NSLog(@"%@",imPath);
    }
    if([elementName isEqualToString:@"iframe"]){
        
     //     NSLog(@"elemento2");
        
        video=[attributeDict valueForKey:@"src"];
        //   NSLog(@"url %@", imPath );
        [videos addObject:video];
        //  NSLog(@"%@",imPath);
    }
    
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
     // NSLog(@"character %@",string);
}

-(NSArray *)parseText:(NSString *)text
{
   // NSLog(@"inizio1");
    
    images = [[NSMutableArray alloc] init];
    videos = [[NSMutableArray alloc] init];
    
    
    NSMutableString * textForParsing = [[NSMutableString alloc ] init];
    textForParsing = [NSMutableString stringWithFormat:@" <content:encoded> %@ </content:encoded>",text];
    
    
    [textForParsing replaceOccurrencesOfString:@"&nbsp" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [textForParsing length])];
  
    
    [textForParsing replaceOccurrencesOfString:@"allowfullscreen" withString:@"tag=\"allowfullscreen\"" options:NSLiteralSearch range:NSMakeRange(0, [textForParsing length])];

    
  //  NSLog(@"text %@",textForParsing);
        NSData* data =[textForParsing dataUsingEncoding:NSUTF8StringEncoding];
        
        parser = [[NSXMLParser alloc] initWithData:data ];
        [parser setShouldProcessNamespaces:NO];
        [parser  setShouldReportNamespacePrefixes:NO];
        [ parser  setShouldResolveExternalEntities:NO];
        parser.delegate = self;
        
        [parser parse];
   
   // NSLog(@"inizio 3 %d",[images count]);
    
    NSArray * returnArray = [NSArray arrayWithObjects:images,videos, nil];
    
    return returnArray ;
}


@end
