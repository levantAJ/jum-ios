//
//  Jumer.h
//  jumps
//
//  Created by AJ on 4/11/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrafficAnnotation.h"

@interface Jumer : NSObject

+ (NSString*)DATE_FORMAT;
+ (NSString*)API_SHARE_REPORT;
+ (NSString*)API_GET_REPORTS;
+ (NSString *)FONT_CHAMPAGNE_LIMOUSINES;
+ (NSString *)FONT_VILLA;
+ (NSString *)FONT_LOVE_IS_COMPLICATED_AGAIN;
+ (NSString *)USER_PATH;


+ (NSDictionary*)postDataToUrl:(NSString*)urlString theJson:(NSString*)jsonString;
+ (UIImage*)scaleImage:(UIImage*)image scaledToPecent:(float)percent;
+ (UIImage*)scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageFromURL:(NSString*)path;
+ (NSString*)parseAnnotationToJSONObject:(TrafficAnnotation*)annotation;
+ (NSString*)getCurrentDateString;
+ (NSDate*) parseStringToDate:(NSString*)dateString;
+ (NSDateComponents*)diffDates:(NSDate*)dateA anotherDate:(NSDate*)dateB;
+ (NSString*)replaceStringForJSON:(NSString*)input;
+ (NSString*)toOriginalString:(NSString*)input;
+ (void)writeStringToFile:(NSString*)stringData theFileName:(NSString*)fileName;
+ (NSString*)readStringFromFile:(NSString*)fileName;
+ (NSDictionary*)parseJSONObject:(NSString*)jsonString;
+ (NSString*)parseUserToJSONObject:(int)userId therUserName:(NSString*)userName;
+ (NSString*)parseSquareMapToJSONObject:(CLLocationCoordinate2D)northEast theSouthWest:(CLLocationCoordinate2D)southWest theType:(NSString*)type;
@end
