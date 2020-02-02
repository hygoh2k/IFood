
#import <Foundation/Foundation.h>

@interface Food : NSObject{
    NSString *POI_ID;
    NSString *POI_Name;
    NSString *Latitude;
    NSString *Longitude;
    NSString *Description;
    NSString *Thumb;
    NSString *Picture;
    
}

@property(nonatomic,copy) NSString *POI_ID;
@property(nonatomic,copy) NSString *POI_Name;
@property(nonatomic,copy) NSString *Latitude;
@property(nonatomic,copy) NSString *Longitude;
@property(nonatomic,copy) NSString *Description;
@property(nonatomic,copy) NSString *Thumb;
@property(nonatomic,copy) NSString *Picture;

@end