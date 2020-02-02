

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
{
    NSMutableArray *theFoods;
    sqlite3 * db;
    CLLocationManager *_locationManager;
}
@property(nonatomic,retain) NSMutableArray *theFoods;
@property (nonatomic, strong) IBOutlet UITableView *tableViews;

-(NSMutableArray *) foodList;
-(NSMutableArray *) SearchPOI:(NSString *)userinput;


@end