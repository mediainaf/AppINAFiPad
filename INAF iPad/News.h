//
//  News.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>

@interface News : NSObject


@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * author ;
@property (nonatomic,strong) NSString * date ;
@property (nonatomic,strong) NSString * link ;

@property (nonatomic,strong) NSString * thumbnail ;
@property (nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray * videos;



@end
