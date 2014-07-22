//
//  App.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 22/07/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

@property ( nonatomic,strong) NSString * ID;
@property ( nonatomic,strong) NSString * name;
@property ( nonatomic,strong) NSString * authors ;
@property ( nonatomic,strong) NSString * desciption ;
@property ( nonatomic,strong) NSString * iconUrl;
@property ( nonatomic,strong) NSString * infoURL;
@property ( nonatomic,strong) NSString * androidURL;
@property ( nonatomic,strong) NSString * iosURL;


@end
