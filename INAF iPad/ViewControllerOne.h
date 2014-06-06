//
//  ViewControllerOne.h
//  INAF iPad
//
//  Created by Nicolo' Parmiggiani on 26/05/14.
//  Copyright (c) 2014 Nicolo' Parmiggiani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerOne : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *sfondoView;
@property (strong, nonatomic) IBOutlet UIImageView *logoInaf;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
