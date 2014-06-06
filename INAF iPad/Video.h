//
//  Video.h
//  INAF1
//
//  Created by Nicolo' Parmiggiani on 23/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject


@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * summary;
@property (nonatomic,strong) NSString * thumbnail;
@property (nonatomic,strong) NSString * author ;
@property (nonatomic,strong) NSString * data ;
@property (nonatomic,strong) NSString * link ;
@property (nonatomic,strong) NSString * numberOfLike ;
@property (nonatomic,strong) NSString * numberOfView ;
@property (nonatomic,strong) NSString * videoToken;


@end
