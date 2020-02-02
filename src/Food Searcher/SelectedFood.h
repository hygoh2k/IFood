

#import <Foundation/Foundation.h>

@interface SelectedFood : NSObject{
    NSString *POI_ID;
    NSString *POI_Name;
    NSString *Latitude;
    NSString *Longitude;
    NSString *Description;
    NSString *Thumb;
    NSString *Picture;
}

@property(nonatomic, retain) NSString *POI_ID;
@property(nonatomic, retain) NSString *POI_Name;
@property(nonatomic, retain) NSString *Latitude;
@property(nonatomic, retain) NSString *Longitude;
@property(nonatomic, retain) NSString *Description;
@property(nonatomic, retain) NSString *Thumb;
@property(nonatomic, retain) NSString *Picture;

+ (id)selectedFood;

@end
