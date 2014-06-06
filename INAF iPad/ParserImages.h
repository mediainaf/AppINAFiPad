//
//  ParserImages.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserImages : NSObject <NSXMLParserDelegate>

- (NSMutableArray *) parseText : (NSString * ) text;

@end
