

#import "SelectedFood.h"

@implementation SelectedFood

@synthesize POI_ID;
@synthesize POI_Name;
@synthesize Latitude;
@synthesize Longitude;
@synthesize Description;
@synthesize Thumb;
@synthesize Picture;

#pragma mark Singleton Methods

+ (id)selectedFood
{
    static SelectedFood * selectedFood = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        selectedFood = [[self alloc]init];
    });
    return selectedFood;
}

- (id)init
{
    if(self = [super init])
    {
        POI_ID = [[NSString alloc] initWithString:@"Default Property Value"];
        POI_Name = [[NSString alloc] initWithString:@"Default Property Value"];
        Latitude = [[NSString alloc] initWithString:@"Default Property Value"];
        Longitude = [[NSString alloc] initWithString:@"Default Property Value"];
        Description = [[NSString alloc] initWithString:@"Default Property Value"];
        Thumb = [[NSString alloc] initWithString:@"Default Property Value"];
        Picture = [[NSString alloc] initWithString:@"Default Property Value"];
    }
    return self;
}

- (void)dealloc
{
    
}


@end