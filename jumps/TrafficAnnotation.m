//
//  TrafficAnnotation.m
//  jumps
//
//  Created by AJ on 4/9/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "TrafficAnnotation.h"

@implementation TrafficAnnotation

@synthesize coordinate, title, subtitle, reportDetail, reportImage, reportTime, reportType;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    coordinate = coord;
    return self;
}

- (id)initWithTitle:(NSString *)tit andCoordinate:(CLLocationCoordinate2D)coord {
	title = tit;
	coordinate = coord;
	return self;
}

- (id)initWithReport:(NSString *)tit andCoordinate:(CLLocationCoordinate2D)coord andDetail:(NSString*)detail andImage:(NSString*)image andTime:(NSString*)time andType:(NSString*)type{
	title = tit;
	coordinate = coord;
    reportDetail = detail;
    reportImage = image;
    reportTime = time;
    reportType = type;
	return self;
}

-(NSString *)title
{
    return title;
}

-(NSString *)subtitle
{
    return subtitle;
}

-(NSString *)reportType
{
    return reportType;
}

-(NSString *)reportTime
{
    return reportTime;
}

-(NSString *)reportImage
{
    return reportImage;
}

-(NSString *)reportDetail
{
    return reportDetail;
}

@end
