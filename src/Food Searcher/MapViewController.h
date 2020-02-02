
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SelectedFood.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    CLLocationManager *locationManager;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
