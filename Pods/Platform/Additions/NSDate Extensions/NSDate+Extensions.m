/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej
 */

#import "NSDate+Extensions.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Utilities)

#pragma mark Creating Dates from Scratch

+ (NSDate *) dateWithMonth:(NSInteger)dMonth andDay:(NSInteger)dDay andYear:(NSInteger)dYear{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:dMonth];
	[comps setDay:dDay];
	[comps setYear:dYear];
	NSDate *genDate = [CURRENT_CALENDAR dateFromComponents:comps];
	
	return genDate;
}

+ (NSDate *) dateWithHour:(NSInteger)dHour andMinute:(NSInteger)dMinute andSecond:(NSInteger)dSecond{
	return [self dateWithMonth:1 andDay:1 andYear:1975 andHour:dHour andMinute:dMinute andSecond:dSecond];
}

+ (NSDate *) dateWithMonth:(NSInteger)dMonth andDay:(NSInteger)dDay andYear:(NSInteger)dYear andHour:(NSInteger)dHour andMinute:(NSInteger)dMinute andSecond:(NSInteger)dSecond{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMonth:dMonth];
	[comps setDay:dDay];
	[comps setYear:dYear];
	[comps setHour:dHour];
	[comps setMinute:dMinute];
	[comps setSecond:dSecond];
	NSDate *genDate = [CURRENT_CALENDAR dateFromComponents:comps];
	
	return genDate;
}

+ (NSDate *) dateWithDay:(NSDate *)day andTime:(NSDate *)time{
	return [self dateWithMonth:[day month] andDay:[day day] andYear:[day year] andHour:[time hour] andMinute:[time minute] andSecond:[time seconds]];
}

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

#pragma mark Time Ago In Words

- (NSString *)timeAgoInWordsIncludingSeconds:(BOOL)includeSeconds{
	NSTimeInterval intervalInSeconds = fabs([self timeIntervalSinceNow]);
	double intervalInMinutes = round(intervalInSeconds / 60.0);
	
	if (intervalInMinutes >= 0 && intervalInMinutes <= 1) {
		if (!includeSeconds) return intervalInMinutes <= 0 ? @"less than a minute" : @"1 minute";
		if (intervalInSeconds >= 0 && intervalInSeconds < 5) return [NSString stringWithFormat:@"less than %d seconds", 5];
		else if (intervalInSeconds >= 5 && intervalInSeconds < 10) return [NSString stringWithFormat:@"less than %d seconds", 10];
		else if (intervalInSeconds >= 10 && intervalInSeconds < 20) return [NSString stringWithFormat:@"less than %d seconds", 20];
		else if (intervalInSeconds >= 20 && intervalInSeconds < 40) return @"half a minute";
		else if (intervalInSeconds >= 40 && intervalInSeconds < 60) return @"less than a minute";
		else return @"1 minute";
	}
	else if (intervalInMinutes >= 2 && intervalInMinutes <= 44) return [NSString stringWithFormat:@"%.0f minutes", intervalInMinutes];
	else if (intervalInMinutes >= 45 && intervalInMinutes <= 89) return @"about 1 hour";
	else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439) return [NSString stringWithFormat:@"about %.0f hours", round(intervalInMinutes/60.0)];
	else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879) return @"1 day";
	else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199) return [NSString stringWithFormat:@"%.0f days", round(intervalInMinutes/1440.0)];
	else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399) return @"about 1 month";
	else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599) return [NSString stringWithFormat:@"%.0f months", round(intervalInMinutes/43200.0)];
	else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199) return @"about 1 year";
	else return [NSString stringWithFormat:@"over %.0f years", round(intervalInMinutes / 525600.0)];
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) &&
			([components1 day] == [components2 day]));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 week] != [components2 week]) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:aDate];
	return ([components1 month] == [components2 month]) && ([self isSameYearAsDate:aDate]);
}

- (BOOL) isThisMonth
{
	return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isNextMonth
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 month] == ([components2 month] + 1));
}

- (BOOL) isLastMonth
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 month] == ([components2 month] - 1));
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return ([components1 year] == [components2 year]);
}

- (BOOL) isThisYear
{
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self earlierDate:aDate] == self);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self laterDate:aDate] == self);
}

- (BOOL) isInFuture{
	return ([self isLaterThanDate:[NSDate date]]);
}

- (BOOL) isInPast{
	return ([self isEarlierThanDate:[NSDate date]]);
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingMonths: (NSUInteger) dMonths
{
    NSDateComponents *addMonths = [[NSDateComponents alloc] init];
    [addMonths setMonth:dMonths];
    
    return [CURRENT_CALENDAR dateByAddingComponents:addMonths toDate:self options:0];
}

- (NSDate *) dateBySubtractingMonths: (NSUInteger) dMonths
{
    NSDateComponents *subtractMonths = [[NSDateComponents alloc] init];
    [subtractMonths setMonth:-dMonths];
    
    return [CURRENT_CALENDAR dateByAddingComponents:subtractMonths toDate:self options:0];
}

- (NSDate *) dateByAddingDays: (NSUInteger) dDays
{
    NSDateComponents *addDays = [[NSDateComponents alloc] init];
    [addDays setDay:dDays];
    
    return [CURRENT_CALENDAR dateByAddingComponents:addDays toDate:self options:0];
}

- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays
{
    NSDateComponents *subtractDays = [[NSDateComponents alloc] init];
    [subtractDays setDay:-dDays];
    
    return [CURRENT_CALENDAR dateByAddingComponents:subtractDays toDate:self options:0];
}

- (NSDate *) dateByAddingHours: (NSUInteger) dHours
{
    NSDateComponents *addHours = [[NSDateComponents alloc] init];
    [addHours setHour:dHours];
    
    return [CURRENT_CALENDAR dateByAddingComponents:addHours toDate:self options:0];
}

- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours
{
    NSDateComponents *subtractHours = [[NSDateComponents alloc] init];
    [subtractHours setHour:-dHours];
    
    return [CURRENT_CALENDAR dateByAddingComponents:subtractHours toDate:self options:0];
}

- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes
{
    NSDateComponents *addMins = [[NSDateComponents alloc] init];
    [addMins setMinute:dMinutes];
    
    return [CURRENT_CALENDAR dateByAddingComponents:addMins toDate:self options:0];
}

- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes
{
    NSDateComponents *subtractMins = [[NSDateComponents alloc] init];
    [subtractMins setMinute:-dMinutes];
    
    return [CURRENT_CALENDAR dateByAddingComponents:subtractMins toDate:self options:0];
}

- (NSDate *) normalizedDateWithoutTime
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [components setHour:12];
    [components setMinute:0];
    [components setSecond:0];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtEndOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:23];
	[components setMinute:59];
	[components setSecond:59];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtStartOfMonth
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
	
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtEndOfMonth
{
	NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    
    return [[CURRENT_CALENDAR dateByAddingComponents:components toDate:[self dateAtStartOfMonth] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *) dateAtStartOfYear
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtBeginningOfWeek
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setWeekday:1];
	[components setDay:NSUndefinedDateComponent];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtEndOfWeek
{
	NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:1];
    
    return [[CURRENT_CALENDAR dateByAddingComponents:components toDate:[self dateAtBeginningOfWeek] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *) nextDay
{
	return [self dateByAddingDays:1];
}

- (NSDate *) previousDay
{
	return [self dateBySubtractingDays:1];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) monthsAfterDate: (NSDate *) aDate
{
    NSInteger startMonth = [CURRENT_CALENDAR ordinalityOfUnit:NSMonthCalendarUnit inUnit: NSEraCalendarUnit forDate:aDate];
    NSInteger endMonth = [CURRENT_CALENDAR ordinalityOfUnit:NSMonthCalendarUnit inUnit: NSEraCalendarUnit forDate:self];
    return (endMonth - startMonth);
}

- (NSInteger) monthsBeforeDate: (NSDate *) aDate
{
    NSInteger startMonth = [CURRENT_CALENDAR ordinalityOfUnit:NSMonthCalendarUnit inUnit: NSEraCalendarUnit forDate:self];
    NSInteger endMonth = [CURRENT_CALENDAR ordinalityOfUnit:NSMonthCalendarUnit inUnit: NSEraCalendarUnit forDate:aDate];
    return (endMonth - startMonth);
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return [components hour];
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:self];
	return [components hour];
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSMinuteCalendarUnit fromDate:self];
	return [components minute];
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSSecondCalendarUnit fromDate:self];
	return [components second];
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSDayCalendarUnit fromDate:self];
	return [components day];
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSMonthCalendarUnit fromDate:self];
	return [components month];
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekCalendarUnit fromDate:self];
	return [components week];
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
	return [components weekday];
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayOrdinalCalendarUnit fromDate:self];
	return [components weekdayOrdinal];
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	return [components year];
}
@end
