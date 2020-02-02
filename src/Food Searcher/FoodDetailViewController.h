

#import <UIKit/UIKit.h>
#import "SelectedFood.h"

@interface FoodDetailViewController : UIViewController

@property (nonatomic, strong) NSString *foodName;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *foodImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mapBarButton;

@end
