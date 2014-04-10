//
//  ViewController.m
//  jumps
//
//  Created by AJ on 4/7/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize coordinate;

- (void)viewDidLoad{
    [super viewDidLoad];
    jumpsMapView.delegate = self;
    jumpsMapView.showsUserLocation = YES;
    // init pins
    [self initPins];
    userName = @"Anonymous";
    [self makeReportingView];
    viewingReport = NO;
    
}

-(void)makeReportingView{
    parentsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    parentsView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    parentsView.opaque = NO;
    parentsView.clipsToBounds = YES;

    reportDetailView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 230, 350)];
    reportDetailView.center = self.view.center;
    reportDetailView.backgroundColor = [UIColor whiteColor];
    // rounded corner
    reportDetailView.layer.cornerRadius =  8.f;
    reportDetailView.layer.masksToBounds = YES;
    
    //title
    titleReported = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportDetailView addSubview:titleReported];
    
    // time
    timeReported = [[UILabel alloc] init];
    [reportDetailView addSubview:timeReported];
    
    // user
    userReported = [[UILabel alloc] init];
    [reportDetailView addSubview:userReported];
    
    // detail
    detailReported = [[UILabel alloc] init];
    [reportDetailView addSubview:detailReported];
    
    // Image reported
    imageReported = [[UIImageView alloc] init];
    [reportDetailView addSubview:imageReported];
    
    [parentsView addSubview:reportDetailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    jumpsMapView.centerCoordinate = userLocation.location.coordinate;
}

- (IBAction)changeMapType:(id)sender {
    if (jumpsMapView.mapType == MKMapTypeStandard)
        jumpsMapView.mapType = MKMapTypeSatellite;
    else
        jumpsMapView.mapType = MKMapTypeStandard;
}

- (IBAction)zoomsIn:(id)sender {
    [jumpsMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=jumpsMapView.region.center;
    
    span.latitudeDelta=jumpsMapView.region.span.latitudeDelta /2.0002;
    span.longitudeDelta=jumpsMapView.region.span.longitudeDelta /2.0002;
    region.span=span;
    [jumpsMapView setRegion:region animated:TRUE];
}

- (IBAction)zoomsOut:(id)sender {
    [jumpsMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=jumpsMapView.region.center;
    span.latitudeDelta=jumpsMapView.region.span.latitudeDelta *2;
    span.longitudeDelta=jumpsMapView.region.span.longitudeDelta *2;
    region.span=span;
    [jumpsMapView setRegion:region animated:TRUE];
}

- (IBAction)currentLocation:(id)sender {
    [jumpsMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (IBAction)reporting:(id)sender {
    [self showGrid];
}

#pragma Show reporting
- (void)showGrid {
    NSInteger numberOfOptions = 12;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"accident"]] title:@"accident"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"traffic jams"]] title:@"traffic jams"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"police"]] title:@"police"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"cheat gas"]] title:@"cheat gas"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"constructor"]] title:@"constructor"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"rain"]] title:@"rain"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"fire"]] title:@"fire"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"routing"]] title:@"routing"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"camera"]] title:@"camera"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"chatchit"]] title:@"chat chit"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"help"]] title:@"help"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"meteorite"]] title:@"meteorite"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //av.itemFont =[UIFont fontWithName:@"04b_19" size:15];
    av.title = @"JUMPS";
    av.bounces = NO;
    av.itemTextColor = [UIColor blackColor];
    av.backgroundColor = [UIColor whiteColor];
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    switch (itemIndex) {
        case 0: // accident
            [self addPinToMap :[pins objectForKey:@"pin_accident"] thePinType:@"accident"];
            break;
        case 1: // traffic jams
            [self addPinToMap :[pins objectForKey:@"pin_jam"] thePinType:@"traffic jams"];
            break;
        case 2: // police
            [self addPinToMap :[pins objectForKey:@"pin_police"] thePinType:@"police"];
            break;
        case 3: // cheat gas
            [self addPinToMap :[pins objectForKey:@"pin_gas"] thePinType:@"cheat gas"];
            break;
        case 4: // constructor
            [self addPinToMap :[pins objectForKey:@"pin_constructor"] thePinType:@"constructor"];
            break;
        case 5: // rain
            [self addPinToMap :[pins objectForKey:@"pin_rain"] thePinType:@"rain"];
            break;
        case 6: //fire
            [self addPinToMap :[pins objectForKey:@"pin_fire"] thePinType:@"fire"];
            break;
        case 7:// routing
            [self addPinToMap :[pins objectForKey:@"pin_routing"] thePinType:@"routing"];
            break;
        case 8: // camera
            [self addPinToMap :[pins objectForKey:@"pin_camera"] thePinType:@"camera"];
            break;
        case 9: // chat chit
            
            break;
        case 10: // help
            [self addPinToMap :[pins objectForKey:@"pin_help"] thePinType:@"help"];
            break;
        case 11://        meteorite
            [self addPinToMap :[pins objectForKey:@"pin_meteorite"] thePinType:@"meteorite"];
            break;
        default:
            break;
    }
}

#pragma Add pin
// Just call one time in viewDidLoad function
-(void)initPins {
    pins = [[NSDictionary alloc] init];
    pins = @{@"accident":@"accident.png",
             @"pin_accident":@"pin_accident.png",
             @"camera":@"camera.png",
             @"pin_camera":@"pin_camera.png",
             @"constructor":@"constructor.png",
             @"pin_constructor":@"pin_constructor.png",
             @"fire":@"fire.png",
             @"pin_fire":@"pin_fire.png",
             @"cheat gas":@"gas.png",
             @"pin_gas":@"pin_gas.png",
             @"help":@"help.png",
             @"pin_help":@"pin_help.png",
             @"traffic jams":@"jam.png",
             @"pin_jam":@"pin_jam.png",
             @"meteorite":@"meteorite.png",
             @"pin_meteorite":@"pin_meteorite.png",
             @"police":@"police.png",
             @"pin_police":@"pin_police.png",
             @"rain":@"rain.png",
             @"pin_rain":@"pin_rain.png",
             @"routing":@"routing.png",
             @"pin_routing":@"pin_routing.png",
             @"chatchit":@"chatchit.png",
             @"anonymous":@"anonymous.png",
             @"information":@"information.png"};
}

- (void)addPinToMap:(NSString*) pinImage thePinType:(NSString*)pinType {
    currentLocation = [[[jumpsMapView userLocation] location] coordinate];
//    TrafficAnnotation * annotation = [[TrafficAnnotation alloc] initWithTitle:userName andCoordinate:currentLocation];
    TrafficAnnotation* annotation = [[TrafficAnnotation alloc] initWithReport:userName andCoordinate:currentLocation andDetail:@"This is test repoting..." andImage:@"http://t2.gstatic.com/images?q=tbn:ANd9GcToJO1MrE8oftjQYa0tsE1xLggTd3CDmPY4yq5p7vPViQoFNvHGxw" andTime:@"time" andType:pinType];
    annotation.title = userName;
    CLLocation * location = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    [self getAddressFromLatLon:location theAnnotation:annotation];
    [jumpsMapView addAnnotation:annotation];
    currentPin = pinImage;
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"Here we go...";
        return nil;
    }
    static NSString *AnnotationViewID = @"annotationViewID";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[jumpsMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.image = [UIImage imageNamed:currentPin];
    annotationView.canShowCallout = YES; // show title
    
    CGSize size = CGSizeMake(37, 37);
    
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[self scaleImage:[UIImage imageNamed:[pins objectForKey:@"anonymous"]] scaledToSize:size]];
    annotationView.leftCalloutAccessoryView = leftIconView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[self scaleImage:[UIImage imageNamed:[pins objectForKey:@"information"]] scaledToSize:size] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 27, 27);
    
    rightButton.property = annotation;
    [rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    annotationView.annotation = annotation;
    return annotationView;
}

- (IBAction) annotationViewClick:(id) sender {
//    NSLog(@"clicked");
    UIButton *button = (UIButton*)sender;
    [self showReported:button.property];
}

- (UIImage *)scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)scaleImage:(UIImage*)image scaledToPecent:(float)percent {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * percent)
                         orientation:(image.imageOrientation)];
}

-(void)getAddressFromLatLon:(CLLocation*) location theAnnotation:(TrafficAnnotation*) annotation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
//             currentAddress = [NSString stringWithFormat:@"%@ , %@ , %@",[placemark thoroughfare],[placemark locality],[placemark administrativeArea]];
             currentAddress = [NSString stringWithFormat:@"%@, %@, %@",[placemark thoroughfare],[placemark locality], [placemark country]];
             annotation.subtitle = currentAddress;
             NSLog(@"The annotation address:%@", currentAddress);
         }
     }];
}

-(void)showReportAlert:(TrafficAnnotation*)annotation {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:annotation.reportType
                                                    message:annotation.reportDetail
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    UITextField *textField = [alert textFieldAtIndex:0];
//    textField.keyboardType = UIKeyboardTypeDefault;
//    textField.placeholder = @"Report reason...";
    
    UIImageView *tempImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20,20,50,50)];
    tempImageView.image=[UIImage imageNamed:[pins objectForKey:annotation.reportType]];
    [alert addSubview:tempImageView];
    
    [alert show];
}

-(void)showReported:(TrafficAnnotation*)annotation{
    viewingReport=YES;
    if ([self.view.subviews containsObject:parentsView]==YES) {
        parentsView.hidden = NO;
    }else{
        [self.view addSubview:parentsView];
    }
    
    // Set title
    [self clearSubViewReported];
    
    UIImage* image = [self scaleImage:[UIImage imageNamed:[pins objectForKey:annotation.reportType]] scaledToPecent:2];
    imageReportType = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, image.size.width, image.size.height)];
    [imageReportType setImage:image];
    
    labelReportType = [[UILabel alloc] initWithFrame:CGRectMake(image.size.width + 15, 15, 100, image.size.height)];
    [labelReportType setText:annotation.reportType];
    [labelReportType sizeToFit];
    
    [titleReported addSubview:labelReportType];
    [titleReported addSubview:imageReportType];
    
    // add time
    timeReported.frame = CGRectMake(10, 50, reportDetailView.bounds.size.width-20, 50);
    [timeReported setText:[NSString stringWithFormat:@"at: %@", annotation.reportTime]];
    timeReported.numberOfLines = 0;
    [timeReported sizeToFit];
    
    // add user
    userReported.frame = CGRectMake(10, 50 + timeReported.bounds.size.height, reportDetailView.bounds.size.width-20, 50);
    [userReported setText:[NSString stringWithFormat:@"by: %@", annotation.title]];
    userReported.numberOfLines = 0;
    [userReported sizeToFit];
    
    // add detail
    detailReported.frame = CGRectMake(10, 60 + userReported.bounds.size.height + timeReported.bounds.size.height, reportDetailView.bounds.size.width-20, 50);
    [detailReported setText:[annotation.reportDetail isEqualToString:@""] ? @"No detail" : annotation.reportDetail];
    detailReported.numberOfLines = 0;
    [detailReported sizeToFit];
    
    
    imageReported.frame = CGRectMake(10, 70 + detailReported.bounds.size.height + timeReported.bounds.size.height + userReported.bounds.size.height, reportDetailView.bounds.size.width-20, 400);
    if (![annotation.reportImage isEqual:@""]) {
        NSURL *url = [NSURL URLWithString:annotation.reportImage];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        imageReported.image = img;
    }else{
        imageReported.image = [pins objectForKey:@"anonymous"];
        
    }
    [imageReported sizeToFit];
    reportDetailView.contentSize = CGSizeMake((reportDetailView.bounds.size.width > imageReported.bounds.size.width)?reportDetailView.bounds.size.width : imageReported.bounds.size.width, 60 + detailReported.bounds.size.height + imageReported.bounds.size.height);
    
    [reportDetailView sizeToFit];
}

-(void)clearSubViewReported{
    NSArray *viewsToRemove = [titleReported subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    imageReportType = nil;
    imageReportType = nil;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (viewingReport==YES) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        if (location.x < reportDetailView.center.x-reportDetailView.bounds.size.width/2 || location.x > reportDetailView.center.x+reportDetailView.bounds.size.width/2 || location.y < reportDetailView.center.y-reportDetailView.bounds.size.height/2 || location.y > reportDetailView.center.y + reportDetailView.bounds.size.height/2) {
            parentsView.hidden = YES;
            viewingReport=NO;
        }
    }
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if(buttonIndex > 0) {
        UITextField *textField = [alert textFieldAtIndex:0];
        NSString *text = textField.text;
        if(text == nil) {
            return;
        } else {
            //do something with text
        }
    }
}


@end
