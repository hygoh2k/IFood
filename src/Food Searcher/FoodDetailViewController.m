

#import "FoodDetailViewController.h"

@interface FoodDetailViewController ()

@end

@implementation FoodDetailViewController

@synthesize foodName;
@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize foodImage;
@synthesize mapBarButton;

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
    SelectedFood *selectedFood = [ SelectedFood selectedFood];
    
    titleLabel.text = selectedFood.POI_Name;
    descriptionLabel.text = selectedFood.Description;
    UIImage* tempImage = [UIImage imageNamed:selectedFood.Picture];
    self.foodImage.image = tempImage;
    
    NSLog(@"from detail page from SelectedFood %@", selectedFood.POI_Name);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setDescriptionLabel:nil];
    [self setFoodImage:nil];
    [self setMapBarButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
