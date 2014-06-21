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
//    CLLocationManager *manager = [[CLLocationManager alloc] init];
//    [manager requestAlwaysAuthorization];
    [[jumpsMapView.subviews objectAtIndex:1] removeFromSuperview];
    jumpsMapView.delegate = self;
    jumpsMapView.showsUserLocation = YES;
    // init pins
    [self initPins];
    
    //    [jumpsMapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    // Set font
    [lblReportTime setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15]];
    [lblReportTitle setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:17]];
    [lblReportUser setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15]];
    [lblReportDetail setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:17]];
    [lblMessage setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:13]];
    
    // Init parent view

    // Init report view
    reportView.center = self.view.center;
    reportView.backgroundColor = [UIColor whiteColor];
    // rounded corner
    reportView.layer.cornerRadius =  8.f;
    reportView.layer.masksToBounds = YES;
    
    [txtReportDetail setDelegate:self];
    [txtUserName setDelegate:self];
    [txtReportDetail setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15]];
    [txtUserName setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15]];
    [[btnShare titleLabel] setFont:[UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15]];
    
    sharedAnnotation = [[TrafficAnnotation alloc] init];
    imageTakeAPhoto = @"";
    imageTaken = [[UIImage alloc] init];
    currentViewReportImage = @"";
    sharedAnnotation.reportImage = @"";
    userId = 0;
    userName = @"Anonymous";
    // Get user name and user id from database
    NSString* data = [Jumer readStringFromFile:[Jumer USER_PATH]];
    if ([data isEqualToString:@""]) {
        [Jumer writeStringToFile:[Jumer parseUserToJSONObject:userId therUserName:userName] theFileName:[Jumer USER_PATH]];
    }else{
        NSDictionary* dict = [Jumer parseJSONObject:data];
        if (dict!=nil) {
            userName = [Jumer toOriginalString:[dict objectForKey:@"userName"]];
            sharedAnnotation.title = userName;
            userId = [[dict objectForKey:@"userId"] intValue];
            sharedAnnotation.userId = userId;
        }
    }
    
    // Init dict contain annotations
    annotationsArray = [[NSMutableArray alloc] init];
    
    // Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBAction

- (void)changeMapType{
    if (jumpsMapView.mapType == MKMapTypeStandard){
        jumpsMapView.mapType = MKMapTypeSatellite;
    } else if (jumpsMapView.mapType == MKMapTypeSatellite){
        jumpsMapView.mapType = MKMapTypeHybrid;
    } else if (jumpsMapView.mapType == MKMapTypeHybrid){
        jumpsMapView.mapType = MKMapTypeStandard;
    }
}

- (IBAction)zoomsIn:(id)sender {
    [self zoomsMapIn:2.0002];
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
    //    [jumpsMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    //    jumpsMapView.showsUserLocation = NO;
    //    [self zoomsMapIn:15001];
    //    [jumpsMapView setCenterCoordinate:jumpsMapView.userLocation.location.coordinate animated:YES];
    MKCoordinateRegion mapRegion;
    mapRegion.center = jumpsMapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.001, 0.001);
    [jumpsMapView setRegion:mapRegion animated: YES];
}

- (IBAction)reporting:(id)sender {
    [self showGrid];
}

- (IBAction)viewReportImage:(id)sender{
    if (isViewReport == YES) {
        btnCloseReportImage.hidden = NO;
        reportView.hidden = YES;
        parrentView.alpha = 1;
        [parrentView setImage:[Jumer imageFromURL:currentViewReportImage]];
    }else{
        // Hide key board
        
        // Take a photo
        lblMessage.hidden = YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentModalViewController:picker animated:YES];
        }else{
            lblMessage.hidden = NO;
            lblMessage.text = @"Device has no camera!";
        }
    }
}

- (IBAction)closeReportImage:(id)sender{
    parrentView.alpha = 0.5;
    parrentView.image = nil;
    reportView.hidden = NO;
    btnCloseReportImage.hidden = YES;
}

- (IBAction)shareReport:(id)sender{
    @try {
        lblMessage.hidden = YES;
        sharedAnnotation.title = userName;
        sharedAnnotation.coordinate = [[[jumpsMapView userLocation] location] coordinate];
        sharedAnnotation.reportDetail = txtReportDetail.text;
        sharedAnnotation.title = [txtUserName.text isEqualToString:@""]?userName : txtUserName.text;
        sharedAnnotation.userId = userId;
        
        sharedAnnotation.reportImage = imageTakeAPhoto;
        sharedAnnotation.reportTime = [Jumer getCurrentDateString];
        NSDictionary *result = [Jumer postDataToUrl:[Jumer API_SHARE_REPORT] theJson:[Jumer parseAnnotationToJSONObject:sharedAnnotation]];
        if ([[result objectForKey:@"jumer"] isEqualToString:@"true"]) {
            sharedAnnotation.userId = [[NSString stringWithFormat:@"%@", [result objectForKey:@"userId"]] intValue];
            userName = sharedAnnotation.title;
            sharedAnnotation.annotationId = [[NSString stringWithFormat:@"%@", [result objectForKey:@"userId"]] intValue];
            parrentView.hidden = YES;
            reportView.hidden = YES;
            // Add into dict
            if(![annotationsArray containsObject:[NSNumber numberWithInt:sharedAnnotation.annotationId]]){
                [annotationsArray addObject:[NSNumber numberWithInt:sharedAnnotation.annotationId]];
            }
            
            [self addPinToMap:sharedAnnotation];
            [Jumer writeStringToFile:[Jumer parseUserToJSONObject:sharedAnnotation.userId therUserName:sharedAnnotation.title] theFileName:[Jumer USER_PATH]];
            // Clear text
            txtReportDetail.text = @"";
            // Hide keyboard
            [txtUserName resignFirstResponder];
            [txtReportDetail resignFirstResponder];
            
            // Show current location
            MKCoordinateRegion mapRegion;
            mapRegion.center = jumpsMapView.userLocation.coordinate;
            mapRegion.span = MKCoordinateSpanMake(0.001, 0.001);
            [jumpsMapView setRegion:mapRegion animated: YES];
        }else{
            lblMessage.hidden = NO;
            [lblMessage setText:@"Share failed!"];
        }
    }
    @catch (NSException *exception) {
        lblMessage.hidden = NO;
        [lblMessage setText:@"Can't connect to server!"];
        NSLog(@"%@", exception);
    }
}

- (IBAction)annotationViewClick:(id) sender {
    //    NSLog(@"clicked");
    UIButton *button = (UIButton*)sender;
    [self showReported:button.property];
}

#pragma Show reporting

- (void)showGrid {
    parrentView.hidden = YES;
    reportView.hidden = YES;
    NSInteger numberOfOptions = 12;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"accident"]] title:@"accident"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"traffic jams"]] title:@"traffic jams"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"police"]] title:@"police"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"cheat gas"]] title:@"cheat gas"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"constructor"]] title:@"constructor"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"rain"]] title:@"rain"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"fire"]] title:@"fire"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"robber"]] title:@"robber"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"lost"]] title:@"lost"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"meteorite"]] title:@"meteorite"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"help"]] title:@"help"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:[pins objectForKey:@"map type"]] title:@"map type"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.itemFont = [UIFont fontWithName:[Jumer FONT_LOVE_IS_COMPLICATED_AGAIN] size:15];
    av.title = @"JUMPS";
    av.bounces = NO;
    av.itemTextColor = [UIColor blackColor];
    av.backgroundColor = [UIColor whiteColor];
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    isViewReport = NO;
    NSString *pinKey;
    switch (itemIndex) {
        case 0: // accident
            sharedAnnotation.reportType = @"accident";
            pinKey = @"pin_accident";
            break;
        case 1: // traffic jams
            sharedAnnotation.reportType = @"traffic jams";
            pinKey = @"pin_jam";
            break;
        case 2: // police
            sharedAnnotation.reportType = @"police";
            pinKey = @"pin_police";
            break;
        case 3: // cheat gas
            sharedAnnotation.reportType = @"cheat gas";
            pinKey = @"pin_cheat gas";
            break;
        case 4: // constructor
            sharedAnnotation.reportType = @"constructor";
            pinKey = @"pin_constructor";
            break;
        case 5: // rain
            sharedAnnotation.reportType = @"rain";
            pinKey = @"pin_rain";
            break;
        case 6: //fire
            sharedAnnotation.reportType = @"fire";
            pinKey = @"pin_fire";
            break;
        case 7:// routing
            sharedAnnotation.reportType = @"robber";
            pinKey = @"pin_robber";
            break;
        case 8: // camera
            sharedAnnotation.reportType = @"lost";
            pinKey = @"pin_lost";
            break;
        case 9: // meteorite
            sharedAnnotation.reportType = @"meteorite";
            pinKey = @"pin_meteorite";
            break;
            break;
        case 10: // help
            sharedAnnotation.reportType = @"help";
            pinKey = @"pin_help";
            break;
        case 11:// change map type
            [self changeMapType];
        default:
            break;
    }
    if(itemIndex != 11){
        [self showReportMarker];
    }
}

#pragma Add pin
// Just call one time in viewDidLoad function
-(void)initPins {
    pins = [[NSDictionary alloc] init];
    pins = @{@"accident":@"accident.png",
             @"pin_accident":@"pin_accident.png",
             @"lost":@"lost.png",
             @"pin_lost":@"pin_lost.png",
             @"constructor":@"constructor.png",
             @"pin_constructor":@"pin_constructor.png",
             @"fire":@"fire.png",
             @"pin_fire":@"pin_fire.png",
             @"cheat gas":@"gas.png",
             @"pin_cheat gas":@"pin_gas.png",
             @"help":@"help.png",
             @"pin_help":@"pin_help.png",
             @"traffic jams":@"jam.png",
             @"pin_traffic jams":@"pin_jam.png",
             @"meteorite":@"meteorite.png",
             @"pin_meteorite":@"pin_meteorite.png",
             @"police":@"police.png",
             @"pin_police":@"pin_police.png",
             @"rain":@"rain.png",
             @"pin_rain":@"pin_rain.png",
             @"robber":@"robber.png",
             @"pin_robber":@"pin_robber.png",
             @"map type":@"satellite.png",
             @"anonymous":@"anonymous.png",
             @"information":@"information.png",
             @"clip":@"clip.png"};
}

- (void)addPinToMap:(TrafficAnnotation*)annotation{
    CLLocation * location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    [self getAddressFromLatLon:location theAnnotation:annotation];
    [jumpsMapView addAnnotation:annotation];
}

#pragma MKMapView

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //    jumpsMapView.centerCoordinate = userLocation.location.coordinate;
    //    [self zoomsMapIn:15001];
    MKCoordinateRegion mapRegion;
    mapRegion.center = jumpsMapView.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.001, 0.001);
    [jumpsMapView setRegion:mapRegion animated: YES];
}

//- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(TrafficAnnotation*)annotation {
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
    
    annotationView.image = [UIImage imageNamed:[pins objectForKey: [NSString stringWithFormat:@"pin_%@", annotation.reportType]]];
    
    CGSize size = CGSizeMake(37, 37);
    
    UIImageView *leftIconView = [[UIImageView alloc] initWithImage:[Jumer scaleImage:[UIImage imageNamed:[pins objectForKey:@"anonymous"]] scaledToSize:size]];
    annotationView.leftCalloutAccessoryView = leftIconView;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[Jumer scaleImage:[UIImage imageNamed:[pins objectForKey:@"information"]] scaledToSize:size] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 27, 27);
    
    rightButton.property = annotation;
    [rightButton addTarget:self action:@selector(annotationViewClick:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES; // show title
    return annotationView;
}

// Move map
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(getReports)
                                   userInfo:nil
                                    repeats:NO];
//    [self getReports];
    //    [jumpsMapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
}

- (void)getAddressFromLatLon:(CLLocation*) location theAnnotation:(TrafficAnnotation*) annotation {
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

- (void)showReported:(TrafficAnnotation*)annotation{
    isViewReport = YES;
    parrentView.hidden = NO;
    reportView.hidden = NO;
    
    lblReportDetail.hidden = NO;
    lblReportUser.hidden = NO;
    
    txtReportDetail.hidden =YES;
    txtUserName.hidden = YES;
    btnShare.hidden =YES;
    lblMessage.hidden = YES;
    
    [lblReportDetail setText: [annotation.reportDetail isEqualToString:@""]?@"No details": [Jumer toOriginalString:annotation.reportDetail]];
    lblReportDetail.numberOfLines = 0;
    
    NSDate *date = [Jumer parseStringToDate:annotation.reportTime];
    NSDateComponents *components = [Jumer diffDates:date anotherDate:[NSDate date]];
    if (components.year > 0) {
        [lblReportTime setText:[NSString stringWithFormat:@"%i year%@ ago.", components.year, components.year>1?@"s":@""]];
    }else if (components.month > 0){
        [lblReportTime setText:[NSString stringWithFormat:@"%i month%@ ago.", components.month, components.month>1?@"s":@""]];
    }else if (components.day > 0){
        [lblReportTime setText:[NSString stringWithFormat:@"%i day%@ ago.", components.day, components.day>1?@"s":@""]];
    }else if (components.hour > 0){
        [lblReportTime setText:[NSString stringWithFormat:@"%i hour%@ ago.", components.hour, components.hour>1?@"s":@""]];
    }else if (components.minute > 0){
        [lblReportTime setText:[NSString stringWithFormat:@"%i minute%@ ago.", components.minute, components.minute>1?@"s":@""]];
    }else{
        [lblReportTime setText:[NSString stringWithFormat:@"Just now!"]];
    }
    
    lblReportTime.textAlignment = NSTextAlignmentLeft;
    [lblReportTitle setText:annotation.reportType];
    [lblReportUser setText:[NSString stringWithFormat:@"by: %@", [Jumer toOriginalString:annotation.title]]];
    [imgReportType setImage:[UIImage imageNamed:[pins objectForKey:annotation.reportType]]];
    if ([annotation.reportImage isEqualToString:@""]) {
        btnReportImage.enabled = NO;
    }else{
        btnReportImage.enabled = YES;
        currentViewReportImage = annotation.reportImage;
    }
}

- (void)showReportMarker{
    isViewReport = NO;
    parrentView.hidden = NO;
    reportView.hidden = NO;
    
    lblReportDetail.hidden = YES;
    lblReportUser.hidden = YES;
    
    txtReportDetail.hidden =NO;
    txtUserName.hidden = NO;
    btnShare.hidden = NO;
    lblMessage.hidden = YES;
    
    
    [lblReportTime setText:@"take a photo"];
    lblReportTime.textAlignment = NSTextAlignmentRight;
    [lblReportTitle setText:sharedAnnotation.reportType];
    [txtUserName setText:[userName isEqualToString:@"Anonymous"] ? @"":userName];
    [imgReportType setImage:[UIImage imageNamed:[pins objectForKey:sharedAnnotation.reportType]]];
    btnReportImage.enabled=YES;
}

- (void)getReports{
    @try {
        NSLog(@"Get reporting...");
        CLLocationCoordinate2D northEast, southWest;
        northEast = [jumpsMapView convertPoint:CGPointMake(jumpsMapView.frame.size.width, 0) toCoordinateFromView:jumpsMapView];
        southWest = [jumpsMapView convertPoint:CGPointMake(0, jumpsMapView.frame.size.height) toCoordinateFromView:jumpsMapView];

        NSDictionary *result = [Jumer postDataToUrl:[Jumer API_GET_REPORTS] theJson:[Jumer parseSquareMapToJSONObject:northEast theSouthWest:southWest theType:@"all"]];
        if (result != nil) {
            NSData *data = [result objectForKey:@"jumer"];
            for (NSDictionary *dataDict in data) {
                CLLocationCoordinate2D coord;
                coord.latitude = [[dataDict objectForKey:@"latitude"] floatValue];
                coord.longitude = [[dataDict objectForKey:@"longitude"] floatValue];
                TrafficAnnotation *annotation = [[TrafficAnnotation alloc] initWithCoordinate:coord];
                annotation.title = [dataDict objectForKey:@"userName"];
                annotation.reportDetail = [dataDict objectForKey:@"detail"];
                annotation.reportImage = [dataDict objectForKey:@"image"];
                annotation.annotationId = [[dataDict objectForKey:@"id"] intValue];
                annotation.userId = [[dataDict objectForKey:@"userId"] intValue];
                annotation.reportType = [dataDict objectForKey:@"type"];
                annotation.reportTime = [dataDict objectForKey:@"time"];
                if(![annotationsArray containsObject:[NSNumber numberWithInt:annotation.annotationId]]){
                    [annotationsArray addObject:[NSNumber numberWithInt:annotation.annotationId]];
//                    sharedAnnotation = annotation;
                    [self addPinToMap:annotation];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Load report failed!");
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (parrentView.hidden==NO && btnCloseReportImage.hidden==YES) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        if (location.x < reportView.center.x-reportView.bounds.size.width/2 || location.x > reportView.center.x+reportView.bounds.size.width/2 || location.y < reportView.center.y-reportView.bounds.size.height/2 || location.y > reportView.center.y + reportView.bounds.size.height/2) {
            parrentView.hidden = YES;
            reportView.hidden = YES;
            [txtReportDetail resignFirstResponder];
            [txtUserName resignFirstResponder];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [txtUserName resignFirstResponder];
    [txtReportDetail resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 140) ? NO : YES;
}

-(void)zoomsMapIn:(float)level{
    [jumpsMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    MKCoordinateRegion region;
    //Set Zoom level using Span
    MKCoordinateSpan span;
    region.center=jumpsMapView.region.center;
    
    span.latitudeDelta=jumpsMapView.region.span.latitudeDelta /level; // 2.0002
    span.longitudeDelta=jumpsMapView.region.span.longitudeDelta /level;
    region.span=span;
    [jumpsMapView setRegion:region animated:TRUE];
}

#pragma Take a photo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    imageTaken = image;
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    
    if (image != nil) {
        [lblReportTime setText:@"the photo ziped"];
    }else{
        [lblMessage setText:@"No photo snapped!"];
    }
    [self showReportMarker];
    
}

# pragma keyboard
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    reportView.center = CGPointMake(reportView.center.x, self.view.bounds.size.height-(keyboardBounds.size.height + reportView.bounds.size.height/2)-2);
    NSLog(@"Will show key board");
}

-(void) keyboardWillHide:(NSNotification *)note{
    reportView.center = self.view.center;
    NSLog(@"Will hide key board");
}

@end
