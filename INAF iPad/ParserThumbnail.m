//
//  ParserThumbnail.m
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ParserThumbnail.h"

@interface ParserThumbnail ()
{
    NSXMLParser * parser;
    NSString * imPath;
}

@end

@implementation ParserThumbnail


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
  //  NSLog(@"elemento1 %@",elementName);
    
    if([elementName isEqualToString:@"img"]){
        
        //   NSLog(@"elemento2");
        
        imPath=[attributeDict valueForKey:@"src"];
        
        //  NSLog(@"%@",imPath);
    }
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //  NSLog(@"character %@",string);
}

-(NSString *)parse:(NSString *)text
{
  //  NSLog(@"inizio");
    
    NSData* data =[text dataUsingEncoding:NSUTF8StringEncoding];
    
    parser = [[NSXMLParser alloc] initWithData:data ];
    
    parser.delegate = self;
    
    [parser parse];
    
    //NSLog(@"%@",imPath);
    
    return  imPath;
}

@end
