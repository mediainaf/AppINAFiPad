//
//  ParserThumbnail.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserThumbnail : NSObject <NSXMLParserDelegate>

- (NSString *) parse : (NSString * ) text;

@end
