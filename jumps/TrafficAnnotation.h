//
//  TrafficAnnotation.h
//  jumps
//
//  Created by AJ on 4/9/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface TrafficAnnotation : NSObject <MKAnnotation>{
    NSString *title;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *reportType;
@property (nonatomic, copy) NSString *reportImage;
@property (nonatomic, copy) NSString *reportDetail;
@property (nonatomic, copy) NSString *reportTime;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithTitle:(NSString *)tit andCoordinate:(CLLocationCoordinate2D)coord;
- (id)initWithReport:(NSString *)tit andCoordinate:(CLLocationCoordinate2D)coord andDetail:(NSString*)detail andImage:(NSString*)image andTime:(NSString*)time andType:(NSString*)type;
@end
