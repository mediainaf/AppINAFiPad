//
//  ParserImages.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 27/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface ParserImages : NSObject <NSXMLParserDelegate>

- (NSMutableArray *) parseText : (NSString * ) text;

@end
