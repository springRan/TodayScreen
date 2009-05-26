//
//  WidgetClockDate.h
//  TodayScreen
//
//  Created by Mac Pro on 5/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WidgetClockDate : UIViewController {
	IBOutlet UILabel *timeLabel;	
	IBOutlet UILabel *dateLabel;	
    NSTimer *myTicker;  
}

 
- (void)runTimer;  
- (void)showActivity; 

@end