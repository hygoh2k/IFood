

#import "VBAnnotation.h"

@implementation VBAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

-(id)initWithPosition:(CLLocationCoordinate2D)coords
{
    if(self = [super init])
    {
        self.coordinate = coords;
    }
    return self;
}
@end
