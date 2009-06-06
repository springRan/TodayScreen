//
//  UserDefaults.m
//  TodayScreen
//
//  Created by Shravan Reddy on 5/25/09.
//  Copyright 2009 Stanford University. All rights reserved.
//

#import "UserDefaults.h"


@implementation UserDefaults

#define WIDGET_WEATHER_ZIP_CODE_CONSTANT @"zipCode"

#define WIDGET_CLOCK_TIME_FORMAT_CONSTANT @"timeFormat"
#define WIDGET_CLOCK_DATE_FORMAT_CONSTANT @"dateFormat"

#define WIDGET_RSS_ARRAY_CONSTANT @"rssArray"
#define WIDGET_RSS_FEED_CONSTANT @"rssFeed"
#define WIDGET_RSS_NUM_FEEDS_CONSTANT @"rssNumFeeds"

#define WIDGET_APPLAUNCHER_ARRAY_CONSTANT @"appArray"
#define WIDGET_APPLAUNCHER_NUM_ROWS_CONSTANT @"appNumRows"

#define WIDGET_CONTACTS_ARRAY_CONSTANT @ "contactsArray"

/*
 (position---app) matches
 (bgimage)
 (style)
 ---------------------------------------------------------
 weather - zipcode
 timedate - time format, date format
 rss - rss url, # of feeds
 applauncher- (arrary:name,url,image), # of rows
 contact - (array:name, mode), # of rows
 */

/*-(void)loadUserPrefs { 
 [NSUserDefaults resetStandardUserDefaults];
 userDefaults = [NSUserDefaults standardUserDefaults];
 NSInteger numSides = [userDefaults integerForKey:@"numberOfSides"];
 [self initWithNumberOfSides:numSides minimumNumberOfSides:3 maximumNumberOfSides:10];
 self.drawDashed = [userDefaults boolForKey:@"drawDashed"];
 }
 
 -(void)saveUserPrefs {
 userDefaults = [NSUserDefaults standardUserDefaults];
 [userDefaults setInteger:[self numberOfSides] forKey:@"numberOfSides"];
 [userDefaults setBool:drawDashed forKey: @"drawDashed"];
 
 [userDefaults synchronize];
 }*/

/*
 * Methods to load user preferences
 */

-(id) init {
	if(self = [super init]) {
		[NSUserDefaults resetStandardUserDefaults];
		userDefaults = [NSUserDefaults standardUserDefaults];
	}
	return self;
}

-(NSMutableArray*)getWidgetsArrayFromPrefs {
	NSMutableArray* widgetsNameArray = [userDefaults objectForKey:@"widgetsNameArray"];
	
	return widgetsNameArray;
}

-(void)loadWeatherWidgetFromPrefs:(NSString*)widgetName widget:(WidgetWeather*)weatherWidget {
	//[NSUserDefaults resetStandardUserDefaults];
	//userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* zipCode = [userDefaults objectForKey:[widgetName stringByAppendingString: WIDGET_WEATHER_ZIP_CODE_CONSTANT]];
	
	[weatherWidget setZipCode:zipCode];
}

-(void)loadClockWidgetFromPrefs:(NSString*)widgetName widget:(WidgetClockDate*)clockWidget {
	//[NSUserDefaults resetStandardUserDefaults];
	//userDefaults = [NSUserDefaults standardUserDefaults];
	NSString* timeFormat = [userDefaults objectForKey:[widgetName stringByAppendingString: WIDGET_CLOCK_TIME_FORMAT_CONSTANT]];
	//NSString* dateFormat = [userDefaults objectForKey:[widgetName stringByAppendingString: WIDGET_CLOCK_DATE_FORMAT_CONSTANT]];
	NSLog(@"TIME FORMAT: %@", timeFormat);
	[clockWidget setTimeFormat:timeFormat];
	[clockWidget reloadClock];
	//[clockWidget setDateFormat:dateFormat];
}

-(void)loadRSSWidgetFromPrefs:(NSString*)widgetName widget:(WidgetRSS*)rssWidget {
	//[NSUserDefaults resetStandardUserDefaults];
	//userDefaults = [NSUserDefaults standardUserDefaults];
	//NSMutableArray* rssArray = [userDefaults objectForKey:[widgetName stringByAppendingString:WIDGET_RSS_ARRAY_CONSTANT]];
	
	NSString* rssFeed = [userDefaults objectForKey:[widgetName stringByAppendingString:WIDGET_RSS_FEED_CONSTANT]];
	NSInteger numFeeds = [userDefaults integerForKey:[widgetName stringByAppendingString:WIDGET_RSS_NUM_FEEDS_CONSTANT]];
	
	//[rssWidget setSingleRSSArray:rssArray];
	[rssWidget setRssFeed:rssFeed];
	[rssWidget setNUM_OF_FEEDS:numFeeds];
	[rssWidget reloadRSS];
}

-(void)loadAppLauncherWidgetFromPrefs:(NSString*)widgetName widget:(WidgetAppLauncher*)appLauncherWidget {
	//[NSUserDefaults resetStandardUserDefaults];
	//userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray* appShortcuts = [userDefaults objectForKey:[widgetName stringByAppendingString:WIDGET_APPLAUNCHER_ARRAY_CONSTANT]];
	NSInteger numRows = [userDefaults integerForKey:[widgetName stringByAppendingString:WIDGET_APPLAUNCHER_NUM_ROWS_CONSTANT]];
	
	[appLauncherWidget setAppShortcuts:appShortcuts];
	[appLauncherWidget setNumRows:numRows];
}

-(void)loadContactWidgetFromPrefs:(NSString*)widgetName widget:(WidgetContact*)contactWidget {
	//[NSUserDefaults resetStandardUserDefaults];
	//userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray* contactsArray = [userDefaults objectForKey:[widgetName stringByAppendingString:WIDGET_CONTACTS_ARRAY_CONSTANT]];
	
	[contactWidget setContactsArray:contactsArray];
}

/*
 * Begin writing user prefs
 */
-(void)writeWidgetArrayPrefs:(NSArray*)widgetsArray {
	userDefaults = [NSUserDefaults standardUserDefaults];
	NSInteger i = 0;
	NSMutableArray* widgetsNameArray = [[NSMutableArray alloc] init];
	for(WidgetViewControllerSuperClass* widget in widgetsArray) {
		if([widget class] == [WidgetWeather class]) {
			[widgetsNameArray addObject:[@"weatherWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		} else if ([widget class] == [WidgetClockDate class]) {
			[widgetsNameArray addObject:[@"clockDateWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		} else if ([widget class] == [WidgetRSS class]) {
			[widgetsNameArray addObject:[@"rssWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		} else if ([widget class] == [WidgetAppLauncher class]) {
			[widgetsNameArray addObject:[@"appLauncherWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		} else if ([widget class] == [WidgetContact class]) {
			[widgetsNameArray addObject:[@"contactWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		} else if ([widget class] == [WidgetFlipClockDate class]) {
			[widgetsNameArray addObject:[@"flipClockDateWidget" stringByAppendingString:[NSString stringWithFormat:@"%d", i]]];
		}
		i++;
	}
	NSLog(@"Widgets Name Array: %@", widgetsNameArray);
	[userDefaults setObject:widgetsNameArray forKey:@"widgetsNameArray"];
	[userDefaults synchronize];
	[widgetsNameArray release];
}

-(void)writeWeatherWidgetPrefs:(NSString*)widgetName zipCode:(NSString*)zipCode {
	//userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:zipCode forKey:[widgetName stringByAppendingString: WIDGET_WEATHER_ZIP_CODE_CONSTANT]];
	//[userDefaults synchronize];
}

-(void)writeClockWidgetPrefs:(NSString*)widgetName timeFormat:(NSString*)timeFormat dateFormat:(NSString*)dateFormat {
	//userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:timeFormat forKey:[widgetName stringByAppendingString: WIDGET_CLOCK_TIME_FORMAT_CONSTANT]];
	[userDefaults setObject:dateFormat forKey:[widgetName stringByAppendingString: WIDGET_CLOCK_DATE_FORMAT_CONSTANT]];
	//[userDefaults synchronize];
}

//-(void)writeRSSWidgetPrefs:(NSString*)widgetName rssArray:(NSArray*)rssArray numFeeds:(NSInteger)numFeeds {
-(void)writeRSSWidgetPrefs:(NSString*)widgetName rssFeed:(NSString*)rssFeed numFeeds:(NSInteger)numFeeds {
	//userDefaults = [NSUserDefaults standardUserDefaults];
	//[userDefaults setObject:rssArray forKey:[widgetName stringByAppendingString: WIDGET_RSS_ARRAY_CONSTANT]];
	[userDefaults setObject:rssFeed forKey:[widgetName stringByAppendingString: WIDGET_RSS_FEED_CONSTANT]];
	[userDefaults setInteger:numFeeds forKey:[widgetName stringByAppendingString: WIDGET_RSS_NUM_FEEDS_CONSTANT]];
	//[userDefaults synchronize];
}

-(void)writeAppLauncherWidgetPrefs:(NSString*)widgetName appArray:(NSArray*)appShortcuts appNumRows:(NSInteger)appNumRows {
	//userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:appShortcuts forKey:[widgetName stringByAppendingString: WIDGET_APPLAUNCHER_ARRAY_CONSTANT]];
	[userDefaults setInteger:appNumRows forKey:[widgetName stringByAppendingString: WIDGET_APPLAUNCHER_NUM_ROWS_CONSTANT]];
	//[userDefaults synchronize];
}

-(void)writeContactWidgetPrefs:(NSString*)widgetName contacts:(NSArray*)contacts {
	//userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:contacts forKey:[widgetName stringByAppendingString: WIDGET_CONTACTS_ARRAY_CONSTANT]];
	//[userDefaults synchronize];
}

- (void) dealloc {
	[userDefaults release];
	[super dealloc];
}
@end
