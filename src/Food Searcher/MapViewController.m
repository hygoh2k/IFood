

#import "MapViewController.h"
#import "VBAnnotation.h"

#define SPAN_VALUE 0.01f;

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SelectedFood *selectedFood = [SelectedFood selectedFood];
    
    double latitude = [selectedFood.Latitude doubleValue];
    double longitude = [selectedFood.Longitude doubleValue];
    
    [self.mapView.delegate self];
    [self.mapView setShowsUserLocation:YES];
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D center;
   
    center.latitude = latitude;
    center.longitude = longitude;

    MKCoordinateSpan span;
    span.latitudeDelta = SPAN_VALUE;
    span.longitudeDelta = SPAN_VALUE;
    
    region.center = center;
    region.span = span;

    [mapView setRegion:region animated:YES ];
    
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    VBAnnotation *ann = [[VBAnnotation alloc]initWithPosition:location];
    ann.title = selectedFood.POI_Name;
    ann.subtitle = selectedFood.Description;
    
    [self.mapView addAnnotation:ann];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    double latitude = 0.0;
    double longitude = 0.0;
    int degrees = userLocation.coordinate.latitude;
    double decimal = fabs(userLocation.coordinate.latitude - degrees);
    latitude = decimal;
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                     degrees, minutes, seconds];
    //latLabel.text = lat;
    degrees = userLocation.coordinate.longitude;
    decimal = fabs(userLocation.coordinate.longitude - degrees);
    longitude = decimal;
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                       degrees, minutes, seconds];
    //longLabel.text = longt;
    
    NSLog(@"latitide:%@ longitude:%@", lat, longt);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    double latitude = 0.0;
    double longitude = 0.0;
    int degrees = newLocation.coordinate.latitude;
    double decimal = fabs(newLocation.coordinate.latitude - degrees);
    latitude = decimal;
    int minutes = decimal * 60;
    double seconds = decimal * 3600 - minutes * 60;
    NSString *lat = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                     degrees, minutes, seconds];
    //latLabel.text = lat;
    degrees = newLocation.coordinate.longitude;
    decimal = fabs(newLocation.coordinate.longitude - degrees);
    longitude = decimal;
    minutes = decimal * 60;
    seconds = decimal * 3600 - minutes * 60;
    NSString *longt = [NSString stringWithFormat:@"%d° %d' %1.4f\"",
                       degrees, minutes, seconds];
    //longLabel.text = longt;
    
    NSLog(@"latitide:%@ longitude:%@", lat, longt);
}


/*
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}
@end
