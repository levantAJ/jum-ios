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
#include "Jumer.h"

CLLocationCoordinate2D currentLocation;
NSDictionary * pins;
NSMutableArray * annotationsArray;
NSString *currentPin;
NSString *userName;
int userId;
NSString *currentAddress;
NSString *currentViewReportImage;
NSString *imageTakeAPhoto;
UIImage *imageTaken;
BOOL isViewReport;
TrafficAnnotation *sharedAnnotation;

@interface ViewController : UIViewController <MKMapViewDelegate, RNGridMenuDelegate, MKAnnotation, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet MKMapView *jumpsMapView;
    IBOutlet UIButton *zoomIn;
    IBOutlet UIButton *zoomOut;
    IBOutlet UIButton *mapType;
    IBOutlet UIButton *report;
    IBOutlet UIButton *current;
    IBOutlet UIImageView *parrentView;
    IBOutlet UIScrollView *reportView;
    
    IBOutlet UIImageView *imgReportType;
    IBOutlet UIButton *btnReportImage;
    IBOutlet UILabel *lblReportTitle;
    IBOutlet UILabel *lblReportTime;
    IBOutlet UILabel *lblReportUser;
    IBOutlet UILabel *lblReportDetail;
    
    IBOutlet UIButton *btnCloseReportImage;
    
    IBOutlet UITextField* txtUserName;
    IBOutlet UITextField* txtReportDetail;
    IBOutlet UIButton* btnShare;
    IBOutlet UILabel *lblMessage;
}


- (IBAction)zoomsIn:(id)sender;
- (IBAction)zoomsOut:(id)sender;
- (IBAction)currentLocation:(id)sender;
- (IBAction)reporting:(id)sender;
- (IBAction)viewReportImage:(id)sender;
- (IBAction)closeReportImage:(id)sender;
- (IBAction)shareReport:(id)sender;

@end
