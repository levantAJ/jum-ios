//
//  Jumer.m
//  jumps
//
//  Created by AJ on 4/11/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "Jumer.h"

@implementation Jumer

#pragma API



+ (NSString*)HOST{
    return @"http://localhost:8080/";
}

+ (NSString *)API_SHARE_REPORT{
    return [NSString stringWithFormat:@"%@ReportMarker", [self HOST]];
//    return @"http://jumps.sirlevantai.cloudbees.net/ReportMarker";
}

+ (NSString *)API_GET_REPORTS{
    return [NSString stringWithFormat:@"%@GetReports", [self HOST]];
//    return @"http://jumps.sirlevantai.cloudbees.net/GetReports";
}

+ (NSString*)DATE_FORMAT{
    return @"";
}

+ (NSString *)USER_PATH{
    return @"jumer.aj";
}

+ (NSString *)FONT_CHAMPAGNE_LIMOUSINES{
    return @"Champagne & Limousines";
}

+ (NSString *)FONT_VILLA{
    return @"Villa";
}

+ (NSString *)FONT_LOVE_IS_COMPLICATED_AGAIN{
    return @"Love Is Complicated Again";
}

+ (NSDateComponents*)diffDates:(NSDate*)dateA anotherDate:(NSDate*)dateB{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dateA toDate:dateB options:0];
    
    NSLog(@"Difference in date components: %i/%i/%i/%i/%i/%i", components.second, components.minute, components.hour, components.day, components.month, components.year);
    return components;
}

+ (NSDate*) parseStringToDate:(NSString*)dateString{
    NSArray *foo = [dateString componentsSeparatedByString:@"|"];
    if([foo count]==6){
        NSDate* result;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setSecond:[[foo objectAtIndex:5] intValue]];
        [comps setMinute:[[foo objectAtIndex:4] intValue]];
        [comps setHour:[[foo objectAtIndex:3] intValue]];
        [comps setDay:[[foo objectAtIndex:2] intValue]];
        [comps setMonth:[[foo objectAtIndex:1] intValue]];
        [comps setYear:[[foo objectAtIndex:0] intValue]];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        result = [gregorian dateFromComponents:comps];
        return result;
    }
    return  [NSDate date];
}

+ (NSString*) getCurrentDateString{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];

    return [NSString stringWithFormat:@"%d|%d|%d|%d|%d|%d", [components year], [components month], [components day], [components hour], [components minute], [components second]];
}

+ (NSDictionary*)parseJSONObject:(NSString*)jsonString{
    NSError* error = nil;
    NSData *jsonData =  [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *deserializedDictionary = nil;
    if (jsonObject !=nil && error==nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            deserializedDictionary = (NSDictionary *)jsonObject;
        }
    }
    return deserializedDictionary;
}

+ (NSString*)replaceStringForJSON:(NSString*)input{
    NSLog(@"%@", [input stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]);
    return [input stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
}

+ (NSString*)toOriginalString:(NSString*)input{
    return [input stringByReplacingOccurrencesOfString:@"\'" withString:@"'"];
}

+ (NSString*)parseUserToJSONObject:(int)userId therUserName:(NSString*)userName{
    return [NSString stringWithFormat:@"{\"userId\":\"%d\", \"userName\":\"%@\"}", userId, [self replaceStringForJSON:userName]];
}

+ (NSString*)parseAnnotationToJSONObject:(TrafficAnnotation*)annotation{
//    NSDictionary *jsonDictionary = @{@"userId": [NSNumber numberWithInt: annotation.userId], @"userName":annotation.title, @"latitude": [NSNumber numberWithFloat: annotation.coordinate.latitude], @"longitude":[NSNumber numberWithFloat: annotation.coordinate.longitude], @"detail":annotation.reportDetail, @"time":annotation.reportTime, @"image":annotation.reportImage, @"type":annotation.reportType};
    return [NSString stringWithFormat:@"{'userId':'%d', 'userName':'%@', 'latitude':'%f', 'longitude':'%f', 'detail':'%@', 'image':'%@', 'time':'%@', 'type':'%@'}", annotation.userId, [Jumer replaceStringForJSON:annotation.title], annotation.coordinate.latitude, annotation.coordinate.longitude, [Jumer replaceStringForJSON:annotation.reportDetail], [Jumer replaceStringForJSON:annotation.reportImage], annotation.reportTime, annotation.reportType];
}

+ (NSString*)parseSquareMapToJSONObject:(CLLocationCoordinate2D)northEast theSouthWest:(CLLocationCoordinate2D)southWest theType:(NSString *)type{
    return [NSString stringWithFormat:@"{\"northEastLatitude\":\"%f\", \"northEastLongitude\":\"%f\", \"southWestLatitude\":\"%f\", \"southWestLongitude\":\"%f\", \"type\":\"%@\"}", northEast.latitude, northEast.longitude, southWest.latitude, southWest.longitude, type];
}

+(NSDictionary *)postDataToUrl:(NSString*)urlString theJson:(NSString*)jsonString {
    NSData* responseData = nil;
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    responseData = [NSMutableData data] ;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSData *req=[NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];
    [request setHTTPBody:req];
    NSURLResponse* response;
    NSError* error = nil;
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *deserializedDictionary = nil;
    if (jsonObject !=nil && error==nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]){
            deserializedDictionary = (NSDictionary *)jsonObject;
        }
    }
    
    NSLog(@"the final output is:%@", responseString);
    
    return deserializedDictionary;
}

#pragma Scale image
+ (UIImage *)scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)scaleImage:(UIImage*)image scaledToPecent:(float)percent {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * percent)
                         orientation:(image.imageOrientation)];
}

+(UIImage*)imageFromURL:(NSString*)path{
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    return img;
}

#pragma WRITE - READ FILE
+ (void)writeStringToFile:(NSString*)stringData theFileName:(NSString*)fileName {
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[stringData dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

+ (NSString*)readStringFromFile:(NSString*)fileName {
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    // The main act...
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
}

@end
