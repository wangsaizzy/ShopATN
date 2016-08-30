//
//  POIAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "POIAnnotation.h"

@interface POIAnnotation ()

@property (nonatomic, readwrite, strong) AMapPOI *poi;

@end

@implementation POIAnnotation
@synthesize poi = _poi;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    if ([self.poi.province isEqualToString:@"北京市"]) {
        
        return [NSString stringWithFormat:@"%@%@%@",  self.poi.city, self.poi.district, self.poi.address];
    } else if ([self.poi.province isEqualToString:@"天津市"]) {
        
        return [NSString stringWithFormat:@"%@%@%@",  self.poi.city, self.poi.district, self.poi.address];
    } else if ([self.poi.province isEqualToString:@"重庆市"]) {
        
        return [NSString stringWithFormat:@"%@%@%@",  self.poi.city, self.poi.district, self.poi.address];
    } else if ([self.poi.province isEqualToString:@"重庆市"]) {
        
        return [NSString stringWithFormat:@"%@%@%@",  self.poi.city, self.poi.district, self.poi.address];
    } else {
        
        return [NSString stringWithFormat:@"%@%@%@%@", self.poi.province, self.poi.city, self.poi.district, self.poi.address];
    }
    
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

- (NSString *)adcode {
    
    return self.poi.adcode;
}

- (NSString *)district {
    
    return self.poi.district;
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}

@end
