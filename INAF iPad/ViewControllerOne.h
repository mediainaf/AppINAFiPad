//
//  ViewControllerOne.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.

// Copyright (c) 2014 Nicolò Parmiggiani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <UIKit/UIKit.h>

@interface ViewControllerOne : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UIImageView *logoInaf;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *sfondoInfo;
@property (strong, nonatomic) IBOutlet UITextView *testoInfo;
@property (strong, nonatomic) IBOutlet UIImageView *separator;

@end
