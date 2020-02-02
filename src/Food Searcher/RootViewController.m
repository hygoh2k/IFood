#import "RootViewController.h"
#import "FoodDetailViewController.h"
#import "Food.h"
#import <sqlite3.h>
#import "SelectedFood.h"


@interface RootViewController ()

@end

@implementation RootViewController
{
    NSArray *_foods;
    NSMutableArray *_searchResults;
    NSArray *_tags;
    NSMutableDictionary *_tagsWithID;
    NSMutableDictionary *_matchedFoodTag;
    NSMutableDictionary *_currentDisplayCells;
    BOOL _startUpdate;
    
}

@synthesize tableViews;
@synthesize theFoods;


- (void)viewDidLoad
{
    [self foodList];
    [super viewDidLoad];
    [self startUpdatingCurrentLocation];
    
    _currentDisplayCells = [[NSMutableDictionary alloc] init];
    
    
    //    _foods = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    //	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Process cell
- (void) UpdateCellDescription: (Food*)poi currentCell:(UITableViewCell*)cell
{
    
    NSString *expression;
    
    if( [_matchedFoodTag objectForKey:[NSNumber numberWithInt:poi.POI_ID.integerValue]] != nil)
    {
        expression = (NSString*)[_matchedFoodTag objectForKey:[NSNumber numberWithInt:poi.POI_ID.integerValue]];
    }
    else
    {
        expression = poi.Description;
    }
    
    NSString *formatedValue = [self GenerateDistanceFromCurrentLocationExpression:poi];
    
    if(formatedValue.length == 0 )
    {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",expression]];
    }
    else
    {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"[%@] %@", formatedValue, expression]];
    }
    
    
    
}


- (void) UpdateCellDescriptionOld
{
    for( NSString *poi_id in [_currentDisplayCells allKeys])
    {
        UITableViewCell *cell = [_currentDisplayCells objectForKey:poi_id];
        
        for(Food* food in [self theFoods])
        {
            if( food.POI_ID == poi_id)
            {
                Food *found_poi = food;
                NSString *expression;
                
                if( [_matchedFoodTag objectForKey:[NSNumber numberWithInt:food.POI_ID.integerValue]] != nil)
                {
                    expression = (NSString*)[_matchedFoodTag objectForKey:[NSNumber numberWithInt:food.POI_ID.integerValue]];
                }
                else
                {
                    expression = food.Description;
                }
                
                NSString *formatedValue = [self GenerateDistanceFromCurrentLocationExpression:found_poi];
                
                if(formatedValue.length == 0 )
                {
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",expression]];
                }
                else
                {
                    [cell.detailTextLabel setText:[NSString stringWithFormat:@"[%@] %@", formatedValue, expression]];
                }
            }
        }
        
        
        
        
        
    }
}

#pragma mark - Calculating Location
- (NSString*)GenerateDistanceFromCurrentLocationExpression: (Food*) poi
{
    NSString* distanceExpression = nil;
    
    double calculatedDistance = [self CalculateDistanceFromCurrentLocation:poi];
    
    
    if( calculatedDistance == -1)
    {
        distanceExpression = [[NSString alloc]init];
    }
    else if( calculatedDistance>1000.0)
    {
        distanceExpression = [NSString stringWithFormat:@"%.2f KM", calculatedDistance/1000];
    }
    else
    {
        distanceExpression = [NSString stringWithFormat:@"%.0f Meter", calculatedDistance];
    }
    
    return distanceExpression;
}


- (double)CalculateDistanceFromCurrentLocation: (Food*) poi
{
    double distance = -1.0f;
    
    if (_startUpdate == YES)
    {
        CLLocation *currentLocation = [_locationManager location];
        CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:poi.Latitude.doubleValue longitude:poi.Longitude.doubleValue];
        distance = [currentLocation distanceFromLocation:targetLocation];
    }
    
    return distance;
}

#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation
{
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 1.0f; // we don't need to be any more accurate than 10m
        _locationManager.purpose = @"This may be used to obtain your current location";
    }
    
    [_locationManager startUpdatingLocation];
    _startUpdate = YES;
    
    //[self showCurrentLocationSpinner:YES];
}

- (void)stopUpdatingCurrentLocation
{
    [_locationManager stopUpdatingLocation];
    
    //[self showCurrentLocationSpinner:NO];
}

//- (void)locationManager: (CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocations:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 10)
    {
        return;
    }
    
    CLLocationCoordinate2D currentUserCoordinate = [newLocation coordinate];
    NSLog(@"[Info] Current Location: Latitude:%f Longitude:%f", currentUserCoordinate.latitude, currentUserCoordinate.longitude);
    
    
    for( NSString* poi_id in _currentDisplayCells.allKeys)
    {
        for(Food* poi in theFoods)
        {
            if(poi.POI_ID == poi_id)
            {
                [self UpdateCellDescription:poi currentCell:_currentDisplayCells[poi_id]];
                break;
            }
        }
    }

    
    //_currentUserCoordinate = [newLocation coordinate];
    //_selectedRow = 1;
    
    // update the current location cells detail label with these coords
    // UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"φ:%.4F, λ:%.4F", _currentUserCoordinate.latitude, _currentUserCoordinate.longitude];
    
    // after recieving a location, stop updating
    //[self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // stop updating
    [self stopUpdatingCurrentLocation];
    _startUpdate = NO;
    
    //refresh cell descroption
    //[self UpdateCellDescription];
    for( NSString* poi_id in _currentDisplayCells.allKeys)
    {
        for(Food* poi in theFoods)
        {
            if(poi.POI_ID == poi_id)
            {
                [self UpdateCellDescription:poi currentCell:_currentDisplayCells[poi_id]];
                break;
            }
        }
    }
    
    // since we got an error, set selected location to invalid location
    //_currentUserCoordinate = kCLLocationCoordinate2DInvalid;
    
    // show the error alert
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Error updating location";
    //alert.message = [error localizedDescription];
    alert.message = @"Please check your device";
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
    
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResults count];
    } else
    {
        return [self.theFoods count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	CGFloat detailSize = 80;
    
	return detailSize;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FoodCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        //cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
        Food *food = [_searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = food.POI_Name;
        
        
        //cell.detailTextLabel.text = food.Description;
        //display matched tag in description
        
        //        cell.detailTextLabel.text = (NSString*)[_matchedFoodTag objectForKey:[NSNumber numberWithInt:food.POI_ID.integerValue]];
        
        
        
        cell.imageView.image = [UIImage imageNamed:food.Thumb];
        [_currentDisplayCells setObject:cell forKey:food.POI_ID];
        //[self UpdateCellDescription];
        [self UpdateCellDescription:food currentCell:cell];
        
    } else {
        int rowCount = indexPath.row;
        
        Food *food = [self.theFoods objectAtIndex:rowCount];
        cell.textLabel.text = food.POI_Name;
        //cell.detailTextLabel.text = food.Description;
        cell.imageView.image = [UIImage imageNamed:food.Thumb];
        [_currentDisplayCells setObject:cell forKey:food.POI_ID];
        //[self UpdateCellDescription];
        [self UpdateCellDescription:food currentCell:cell];
    }
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSMutableDictionary *frequencyCount = [[NSMutableDictionary alloc] init];//variable that store the POI matched frequency,
    //the higher the frequency, the higher the ranking of this POI
    
    //filter the POI name that contains user input
    NSPredicate *resultPredicate = [NSPredicate
                                    //predicateWithFormat:@"SELF contains[cd] %@",
                                    predicateWithFormat:@"SELF.POI_Name contains[cd] %@",
                                    searchText];
    
    
    
    //filter by name
    NSArray *filterByName = [theFoods filteredArrayUsingPredicate:resultPredicate];
    
    //process the ranking of the POIs that matched with user input
    for(Food* foodPoi in filterByName)
    {
        NSNumber *poi = [NSNumber numberWithInt: [[foodPoi POI_ID] integerValue]];
        if( [frequencyCount objectForKey:poi] == nil)
        {
            [frequencyCount setObject:[NSNumber numberWithInt:1] forKey:poi];
        }
        else
        {
            //increase this POI ranking by 1
            int counter = [(NSNumber*)[frequencyCount objectForKey:poi] integerValue] + 1;
            [frequencyCount setObject:[NSNumber numberWithInt:counter] forKey:poi];
        }
        
    }
    
    //filter by tag
    NSArray *matchedPOI = [self SearchPOI:searchText];
    
    //process the ranking of the POIs tags that matched with user input
    for(NSNumber *poi in matchedPOI)
    {
        if( [frequencyCount objectForKey:poi] == nil)
        {
            [frequencyCount setObject:[NSNumber numberWithInt:1] forKey:poi];
        }
        else
        {
            //increase this POI ranking by 1
            int counter = [(NSNumber*)[frequencyCount objectForKey:poi] integerValue] + 1;
            [frequencyCount setObject:[NSNumber numberWithInt:counter] forKey:poi];
        }
    }
    
    
    //sorting the POI based on matching frequency
    NSArray* sortedPOI = [frequencyCount keysSortedByValueWithOptions:NSNumericSearch usingComparator:^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
        if (num1.integerValue<num2.integerValue) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    //    NSLog(@"test sorted value");
    //    for(NSNumber *number in sortedPOI)
    //    {
    //        NSLog(@"Found value: %@", number);
    //    }
    
    
    //convert info to result
    _searchResults = [[NSMutableArray alloc] init];
    
    for(NSNumber *poi in sortedPOI)
    {
        for(Food *food in theFoods)
        {
            if([food POI_ID].integerValue == poi.integerValue)
            {
                [_searchResults addObject:food];
                break;
            }
        }
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    [_currentDisplayCells removeAllObjects];//refresh all objects
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Testing - here is didSelectRowAtIndexPath");
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"Testing - Here is didSelectRowAtIndexPath - searchDisplayController");
        [self performSegueWithIdentifier: @"showFoodDetail" sender: self];
    }
    else
	{
        Food *food = [self.theFoods objectAtIndex:indexPath.row];
        
        NSLog(@"Testing - Here is didSelectRowAtIndexPath - searchDisplayController else");
        FoodDetailViewController *details = [[FoodDetailViewController alloc] init];
        details.foodName = food.POI_Name;
    }
    
}

//
//this method is to search for relevant POI based on what user typed in
//
-(NSArray *) SearchPOI:(NSString *)userinput;
{
    
    //matching user input with POI's name
    _matchedFoodTag = [[NSMutableDictionary alloc] init];
    NSArray *inputTokens = [userinput componentsSeparatedByString:@" "];//break user input into tokens, use space as delimiter
    NSMutableArray *matchedPOI = [[NSMutableArray alloc]init];//variable to store all matched POIs
    NSMutableArray *allMatchedTagID = [[NSMutableArray alloc] init];//variable to store all Tags that match user input
    
    NSArray *allTags = [_tagsWithID allKeys];
    
    //get the tags that match user input
    for(NSString *token in inputTokens)
    {
        NSArray *filteredTags = [allTags filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", token]];
        
        NSArray *matchedTagID = [_tagsWithID objectsForKeys:filteredTags notFoundMarker:[NSNull null]];
        
        for(int i=0; i<matchedTagID.count; i++)
        {
            NSNumber *tagID = [matchedTagID objectAtIndex:i];
            if( [allMatchedTagID containsObject:tagID] == NO)
            {
                [allMatchedTagID addObject:tagID];
            }
        }
    }
    
    
    //get POIs that contain the tags that matched earlier
    for( int i=0; i<allMatchedTagID.count; i++)
    {
        NSNumber* tagID = [allMatchedTagID objectAtIndex:i];
        
        NSString *sqlCmd = [NSString stringWithFormat: @"SELECT * FROM  POI_TagMap WHERE TagID = %@", [allMatchedTagID objectAtIndex:i]];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sqlCmd cStringUsingEncoding:NSASCIIStringEncoding], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }
        else
        {
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                
                NSString *poi_id_col = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
                //NSString *tag_id_col = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
                
                int poi_id = [poi_id_col integerValue];
                
                [matchedPOI addObject:[NSNumber numberWithInt:poi_id]];
                
                //generate tag's expression, it will be displayed on cell
                
                NSMutableString* tagExpression = [_matchedFoodTag objectForKey:[NSNumber numberWithInt:poi_id]];
                if( tagExpression == nil)
                {
                    tagExpression = [[NSMutableString alloc] init];
                    [_matchedFoodTag setObject:tagExpression forKey:[NSNumber numberWithInt:poi_id]];
                }
                [tagExpression appendFormat:@"%@ ", [[_tagsWithID allKeysForObject:tagID] objectAtIndex:0]];
                
            }
        }
    }
    
    return [NSArray arrayWithArray:matchedPOI ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Testing - here is prepareForSegue");
    if ([segue.identifier isEqualToString:@"showFoodDetail"]) {
        FoodDetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        if ([self.searchDisplayController isActive]) {
            NSLog(@"Testing - here is prepareForSegue - searchDisplayContrller");
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destViewController.foodName = [_searchResults objectAtIndex:indexPath.row];
            
            Food *food = [_searchResults objectAtIndex:indexPath.row];
            SelectedFood *selectedFood = [SelectedFood selectedFood];
            
            NSLog(@"Testing - Here is didSelectRowAtIndexPath - searchDisplayController else");
            
            selectedFood.POI_ID = food.POI_ID;
            selectedFood.POI_Name = food.POI_Name;
            selectedFood.Latitude = food.Latitude;
            selectedFood.Longitude = food.Longitude;
            selectedFood.Description = food.Description;
            selectedFood.Thumb = food.Thumb;
            selectedFood.Picture = food.Picture;
            
        }
        else
        {
            NSLog(@"Testing - here is prepareForSegue - else");
            indexPath = [self.tableViews indexPathForSelectedRow];
            
            Food *food = [self.theFoods objectAtIndex:indexPath.row];
            SelectedFood *selectedFood = [SelectedFood selectedFood];
            
            NSLog(@"Testing - Here is didSelectRowAtIndexPath - searchDisplayController else");
            
            selectedFood.POI_ID = food.POI_ID;
            selectedFood.POI_Name = food.POI_Name;
            selectedFood.Latitude = food.Latitude;
            selectedFood.Longitude = food.Longitude;
            selectedFood.Description = food.Description;
            selectedFood.Thumb = food.Thumb;
            selectedFood.Picture = food.Picture;
        }
    }
    
}

-(NSMutableArray *) foodList{
    theFoods = [[NSMutableArray alloc] init];
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"POIDb.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured: %s", sqlite3_errmsg(db));
            
        }
        
        
        //loading POI table
        const char *sql = "SELECT * FROM  POI";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }else{
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                Food * food = [[Food alloc] init];
                food.POI_ID = [[NSString alloc] initWithUTF8String:
                               (char *)sqlite3_column_text(sqlStatement, 0)];
                food.POI_Name = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
                food.Latitude = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
                food.Longitude = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)];
                food.Description = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
                food.Thumb = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 5)];
                food.Picture = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 6)];
                
                [theFoods addObject:food];
            }
        }
        
        sql = "SELECT * FROM  POI_Tag";
        //loading POI tag from table
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }else{
            
            _tagsWithID = [[NSMutableDictionary alloc] init];
            
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                NSString *col0 = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
                NSString *col1 = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
                
                NSString *tagName = col1;
                int tagID = [col0 integerValue];
                [_tagsWithID setObject:[NSNumber numberWithInt:tagID] forKey:tagName];
                
            }
        }
        sqlite3_finalize(sqlStatement);
        
    }
    @catch (NSException *exception) {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
    }
    @finally {
        sqlite3_close(db);
        
        return theFoods;
    }
}


@end
