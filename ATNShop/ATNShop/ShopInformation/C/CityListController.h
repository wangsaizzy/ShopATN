//
//  CityListController.h
//  ATNShopDemo
//
//  Created by 吴明飞 on 16/7/5.
//  Copyright © 2016年 吴明飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityModel;
@interface CityListController : UITableViewController

@property (nonatomic, copy) void(^changeCityName)(NSString *);
@property (nonatomic, copy) void(^changeCityId)(NSString *);
@end
