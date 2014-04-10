//
//  ViewController.h
//  jumps
//
//  Created by AJ on 4/7/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "RNGridMenu.h"
#import "TrafficAnnotation.h"
#import "UIButton+Property.h"

CLLocationCoordinate2D currentLocation;
NSDictionary * pins;
NSString *currentPin;
NSString *userName;
NSString *currentAddress;

// View reporting
UIScrollView *reportDetailView;
UIView *parentsView;
BOOL viewingReport;
UIButton* titleReported;
UIImageView* imageReported;
UILabel* detailReported;
UILabel* timeReported;
UILabel* userReported;
UIImageView *imageReportType;
UILabel *labelReportType;


@interface ViewController : UIViewController <MKMapViewDelegate, RNGridMenuDelegate, MKAnnotation, NSXMLParserDelegate>
{
    IBOutlet MKMapView *jumpsMapView;
    IBOutlet UIButton *zoomIn;
    IBOutlet UIButton *zoomOut;
    IBOutlet UIButton *mapType;
    IBOutlet UIButton *report;
}

- (IBAction)changeMapType:(id)sender;
- (IBAction)zoomsIn:(id)sender;
- (IBAction)zoomsOut:(id)sender;
- (IBAction)currentLocation:(id)sender;
- (IBAction)reporting:(id)sender;

@end
