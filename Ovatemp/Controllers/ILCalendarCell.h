//
//  ILCalendarCell.h
//  Ovatemp
//
//  Created by Daniel Lozano on 3/23/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <TelerikUI/TelerikUI.h>

typedef enum {
    CalendarDayTypePeriod,
    CalendarDayTypeFertile,
    CalendarDayTypeNotFertile,
    CalendarDayTypeNone
} CalendarDayType;

@interface ILCalendarCell : TKCalendarDayCell

@property (nonatomic) CalendarDayType dayType;

@end
