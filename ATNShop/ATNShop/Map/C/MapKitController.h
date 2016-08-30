//
//  MapKitController.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/7.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class POIAnnotation;
@interface MapKitController : UIViewController

@property (nonatomic, copy) void(^ChangePOIAnnotation)(POIAnnotation *);
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@end
