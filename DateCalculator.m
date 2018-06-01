//
//  DateFormatter.m
//
//  Created by King on 18/12/2017.
//  Copyright © 2017年 King All rights reserved.
//

#import "DateCalculator.h"

NSString *const DefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";

NSString *const ModifyDateNumberKey = @"number";
NSString *const ModifyDateTypeKey = @"key";

NSString *const WeekDateStringKey = @"weekDayString";
NSString *const WeekDateShortStringKey = @"weekDayString_short";

NSString *const MonthDateStringKey = @"monthDayString";
NSString *const MonthDateShortStringKey = @"monthDayString_short";

NSString *const DateStringKey = @"dateString";
NSString *const DateLongStringKey = @"dateString_long";
NSString *const DateShortStringKey = @"dateString_short";

NSString *const IsTodayKey = @"isToday";
NSString *const IsTomorrowKey = @"isTomorrow";
NSString *const IsOverdueKey = @"isOverdue";
NSString *const IsYesterdayKey = @"isYesterday";
NSString *const IsFutureKey = @"isFuture";

NSString *const YearKey = @"year";
NSString *const MonthKey = @"month";
NSString *const DayKey = @"day";
NSString *const HourKey = @"hour";
NSString *const MinuteKey = @"minute";
NSString *const SecondKey = @"second";

NSString *const BetweenYearKey = @"betweenYear";
NSString *const BetweenMonthKey = @"betweenMonth";
NSString *const BetweenDayKey = @"betweenDay";
NSString *const BetweenHourKey = @"betweenHour";
NSString *const BetweenMinuteKey = @"betweenMinute";
NSString *const BetweenSecondKey = @"betweenSecond";

@implementation DateCalculator {
    
    DFCompareType compareType;
    NSDate *currentDate, *betweenDate;
    NSInteger year, month, day, hour, minute, second;
    NSString *format;
    NSDateFormatter *formatter, *defaultFormatter;
    NSMutableArray *relatedDateArray;
    NSMutableSet *relatedDateSet;
    NSMutableArray *modifyDateArray; //Storage Past/Next modify action
    BOOL isShortFormat, isLongFormat;
    
    NSCalendar *calendar;
    
}

#pragma mark - Initial Setting --------------

- (id)init {
    
    if(self = [super init]){
        self.clear();
    }

    return self;
}

+ (DateCalculator *)calculateDate:(void (^)(DateCalculator *))block{
    DateCalculator * dateFormatter = [[DateCalculator alloc] init];
    block(dateFormatter);
    return dateFormatter;
}

#pragma mark - Increase readability ---------

- (DateCalculator * )with {
    return self;
}

- (DateCalculator * )and {
    return self;
}

- (DateCalculator * )display {
    return self;
}

- (DateCalculator * )check {
    return self;
}

- (DateCalculator * )orNot {
    return self;
}

- (DateCalculator * )from {
    return self;
}

- (DateCalculator * )about {
    return self;
}

- (DateCalculator * )set {
    return self;
}

#pragma mark - Date Format Type --------------

- (DateCalculator * )isOverdue {
    compareType = DFCompareOverDue;
    return self;
}

- (DateCalculator * )isYesterday {
    compareType = DFCompareYesterday;
    return self;
}

- (DateCalculator * )isToday {
    compareType = DFCompareToday;
    return self;
}

- (DateCalculator * )isTomorrow {
    compareType = DFCompareTomorrow;
    return self;
}

- (DateCalculator * )isFuture {
    compareType = DFCompareFuture;
    return self;
}

#pragma mark - Data Setting ---------------

- (DateCalculator * (^)(NSDate *))currentDate {
    return ^(NSDate * date) {
        currentDate = (date)?:currentDate;
        [relatedDateArray addObject:currentDate];
        return self;
    };
}

- (DateCalculator * (^)(NSDate *))betweenDate {
    return ^(NSDate * date) {
        betweenDate = (date)?:betweenDate;
        [relatedDateArray addObject:betweenDate];
        return self;
    };
}

- (DateCalculator * )isShortFormat {
    isShortFormat = YES;
    isLongFormat = NO;
    return self;
}

- (DateCalculator * )isLongFormat {
    isLongFormat = YES;
    isShortFormat = NO;
    return self;
}

- (DateCalculator * (^)(NSInteger))year {
    return ^(NSInteger y) {
        year = (y >= 0)?y:year;
        return self;
    };
}

- (DateCalculator * (^)(NSInteger))month {
    return ^(NSInteger m) {
        month = (m >= 0)?m:month;
        return self;
    };
}

- (DateCalculator * (^)(NSInteger))day {
    return ^(NSInteger d) {
        day = (d >= 0)?d:day;
        return self;
    };
}

- (DateCalculator * (^)(NSInteger))hour {
    return ^(NSInteger h) {
        hour = (h >= 0)?h:hour;
        return self;
    };
}

- (DateCalculator * (^)(NSInteger))minute {
    return ^(NSInteger m) {
        minute = (m >= 0)?m:minute;
        return self;
    };
}

- (DateCalculator * (^)(NSInteger))second {
    return ^(NSInteger s) {
        second = (s >= 0)?s:second;
        return self;
    };
}

- (DateCalculator * (^)(NSString *))format {
    return ^(NSString * f) {
        format = f;
        return self;
    };
}

- (DateCalculator * (^)(NSDateFormatter *))formatter {
    return ^(NSDateFormatter * f) {
        formatter = f;
        return self;
    };
}

- (DateCalculator * (^)(NSDateFormatter *))defaultFormatter {
    return ^(NSDateFormatter * f) {
        defaultFormatter = f;
        return self;
    };
}

//- (DateFormatter * (^)(NSDate *date, ...))about {
//    return ^(NSDate *date, ...) {
//        
//        [relatedDateArray removeAllObjects];
//        
//        va_list args;
//        va_start(args, date);
//        if(date){
//            NSDate *relatedDate;
//            while((relatedDate = va_arg(args, NSDate *))){
//                [relatedDateArray addObject:relatedDate];
//            }
//        }
//        va_end(args);
//        
//        return self;
//    };
//}

#pragma mark - Modify ------------------------

- (DateCalculator * (^)(void))modify {
    return ^(void) {
        
        [relatedDateArray enumerateObjectsUsingBlock:^(NSDate *date, NSUInteger idx, BOOL * _Nonnull stop) {

            //gather date components from date
            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
            
            NSInteger tempYear = (year >= 0)?year:dateComponents.year;
            NSInteger tempMonth = (month >= 0)?month:dateComponents.month;
            NSInteger tempDay = (day >= 0)?day:dateComponents.day;
            NSInteger tempHour = (hour >= 0)?hour:dateComponents.hour;
            NSInteger tempMinute = (minute >= 0)?minute:dateComponents.minute;
            NSInteger tempSecond = (second >= 0)?second:dateComponents.second;
            
            for (NSDictionary *dict in modifyDateArray) {
                switch ((DFObject)[dict[ModifyDateTypeKey] intValue]) {
                    case DFYear:
                        tempYear += [dict[ModifyDateNumberKey] intValue];
                        break;
                    case DFMonth:
                        tempMonth += [dict[ModifyDateNumberKey] intValue];
                        break;
                    case DFDay:
                        tempDay += [dict[ModifyDateNumberKey] intValue];
                        break;
                    case DFHour:
                        tempHour += [dict[ModifyDateNumberKey] intValue];
                        break;
                    case DFMinute:
                        tempMinute += [dict[ModifyDateNumberKey] intValue];
                        break;
                    case DFSecond:
                        tempSecond += [dict[ModifyDateNumberKey] intValue];
                        break;
                }
            }

            //set date components
            [dateComponents setYear:tempYear];
            [dateComponents setMonth:tempMonth];
            [dateComponents setDay:tempDay];
            [dateComponents setHour:tempHour];
            [dateComponents setMinute:tempMinute];
            [dateComponents setSecond:tempSecond];

            if(date == currentDate){
                currentDate = [calendar dateFromComponents:dateComponents];
            }else{
                betweenDate = [calendar dateFromComponents:dateComponents];
            }
            
        }];
        
        year = -1;
        month = -1;
        day = -1;
        hour = -1;
        minute = -1;
        second = -1;
        [modifyDateArray removeAllObjects];
        [relatedDateArray removeAllObjects];
        
        return self;
    };
}

- (DateCalculator * (^)(NSInteger number, DFObject object))next {
    return ^(NSInteger number, DFObject object) {
        [modifyDateArray addObject:@{ModifyDateNumberKey:@(number), ModifyDateTypeKey:@(object)}];
        return self;
    };
}

- (DateCalculator * (^)(NSInteger number, DFObject object))past {
    return ^(NSInteger number, DFObject object) {
        [modifyDateArray addObject:@{ModifyDateNumberKey:@(number*-1), ModifyDateTypeKey:@(object)}];
        return self;
    };
}

#pragma mark - Verification ------------------

#pragma mark - Output ------------------------

/// Check to see if the current time is between the two arbitrary times, ignoring the date portion:
- (BOOL)currentTimeIsBetweenTimeWithTimeString1:(NSString *)timeString1 withTimeString2:(NSString *)timeString2; {
    
    NSArray *timeArray = [timeString1 componentsSeparatedByString:@":"];
    int time1 = [timeArray[0] intValue]*60+[timeArray[1] intValue];
    
    timeArray = [timeString2 componentsSeparatedByString:@":"];
    int time2 = [timeArray[0] intValue]*60+[timeArray[1] intValue];
    
    formatter.dateFormat = format;
    timeArray = [[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@":"];
    int nowTime = ([timeArray[0] intValue] + 8)*60+[timeArray[1] intValue];
    
    return (nowTime >= time1 && nowTime <= time2);

}

///Day String Dictioanry
- (NSDictionary *)getDayDictionaryWithDate:(NSDate *)date {
    
    NSString *dateString = @"", *dateLongString = @"", *dateShortString = @"";
    [formatter setDateFormat:format];
    dateString = [formatter stringFromDate:date];
    
    formatter.dateStyle = kCFDateFormatterLongStyle;
    dateLongString = [formatter stringFromDate:date];
    
    formatter.dateStyle = kCFDateFormatterMediumStyle;
    dateShortString = [formatter stringFromDate:date];
    
    return @{DateStringKey:dateString, DateLongStringKey:dateLongString, DateShortStringKey:dateShortString};
}

///Week String Dictionary
-(NSDictionary *)getWeekStringDictionaryWithDate:(NSDate *)date {
    
    NSString *weekString = @"", *weekShortString = @"";

    formatter.dateFormat=@"EEEE";
    weekString = [[formatter stringFromDate:date] capitalizedString];
    formatter.dateFormat=@"EE";
    weekShortString = [[formatter stringFromDate:date] capitalizedString];
    
    return @{WeekDateShortStringKey:weekShortString,WeekDateStringKey:weekString};
    
}

///Month String Dictionary
-(NSDictionary *)getMonthStringDictionaryWithDate:(NSDate *)date {
    
    NSString *monthString = @"", *monthShortString = @"";
    
    formatter.dateFormat=@"MMMM";
    monthString = [[formatter stringFromDate:date] capitalizedString];
    formatter.dateFormat=@"MMM";
    monthShortString = [[formatter stringFromDate:date] capitalizedString];
    
    return @{MonthDateShortStringKey:monthShortString,MonthDateStringKey:monthString};
    
}
    
-(NSDictionary *)getDayStatusDictionary {
    
    //----- Between Date Components -----
    BOOL isToday = NO, isTomorrow = NO, isOverdue = NO, isYesterday = NO, isFuture = NO;
    
    NSDateComponents *betweenDateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:betweenDate];
    
    [betweenDateComponents setHour:0];
    [betweenDateComponents setMinute:0];
    [betweenDateComponents setSecond:0];
    [betweenDateComponents setDay:betweenDateComponents.day-1];
    NSDate*pastStartDate = [calendar dateFromComponents:betweenDateComponents];
    
    [betweenDateComponents setDay:betweenDateComponents.day+1];
    NSDate*startDate = [calendar dateFromComponents:betweenDateComponents];
    
    [betweenDateComponents setDay:betweenDateComponents.day+1];
    NSDate*endDate = [calendar dateFromComponents:betweenDateComponents];
    
    [betweenDateComponents setDay:betweenDateComponents.day+1];
    NSDate*nextEndDate = [calendar dateFromComponents:betweenDateComponents];
    //----- Between Date Components -----
    
    //----- Boolean Value Calculate -----
    if([betweenDate compare:currentDate] == NSOrderedDescending) {
        isOverdue = YES;
        if([startDate compare:currentDate] == NSOrderedDescending &&
           [pastStartDate compare:currentDate] == NSOrderedAscending) {
            isYesterday = YES;
        } else if([startDate compare:currentDate] == NSOrderedAscending) {
            isToday = YES;
        }
    } else if([betweenDate compare:currentDate] == NSOrderedAscending) {
        isFuture = YES;
        if([nextEndDate compare:currentDate] == NSOrderedDescending &&
           [endDate compare:currentDate] == NSOrderedAscending) {
            isTomorrow = YES;
        } else if([endDate compare:currentDate] == NSOrderedDescending) {
            isToday = YES;
        }
    }
    //----- Boolean Value Calculate -----
    
    return @{IsOverdueKey:@(isOverdue),IsYesterdayKey:@(isYesterday),
             IsTodayKey:@(isToday), IsTomorrowKey:@(isTomorrow), IsFutureKey:@(isFuture)
             };
}

-(NSDictionary *)calculateBetweenDayWithCurrentDate:(NSDate *)currentDate betweenDate:(NSDate *)betweenDate {
    
    NSDateComponents* components = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:currentDate toDate:betweenDate options:0];
    
    return @{BetweenYearKey:@(components.year), BetweenMonthKey:@(components.month), BetweenDayKey:@(components.day),
             BetweenHourKey:@(components.hour), BetweenMinuteKey:@(components.minute), SecondKey:@(components.second)
             };
    
}
    
-(NSDictionary *)getDateDetailDictionaryWithDate:(NSDate *)date {
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    
    return @{YearKey:@(components.year), MonthKey:@(components.month), DayKey:@(components.day),
             HourKey:@(components.hour), MinuteKey:@(components.minute), SecondKey:@(components.second)
             };
}
    
-(NSDictionary *)getBasicDetailsDictionary {
    
    NSMutableDictionary *detailsDictionay = [NSMutableDictionary new];
    
    for(NSDictionary *dict in @[@{@"string":@"currentDate", @"date":currentDate},
                                @{@"string":@"betweenDate", @"date":betweenDate}]) {
        
        detailsDictionay[dict[@"string"]] = [NSMutableDictionary new];
        detailsDictionay[dict[@"string"]][@"date"] = dict[@"date"];
        [detailsDictionay[dict[@"string"]] addEntriesFromDictionary:[self getDayDictionaryWithDate:dict[@"date"]]];
  
        NSString *weekKey = (isShortFormat)?WeekDateShortStringKey:WeekDateStringKey;
        NSString *monthKey = (isShortFormat)?MonthDateShortStringKey:MonthDateStringKey;
        detailsDictionay[dict[@"string"]][weekKey] = [self getWeekStringDictionaryWithDate:dict[@"date"]][weekKey];
        detailsDictionay[dict[@"string"]][monthKey] = [self getMonthStringDictionaryWithDate:dict[@"date"]][monthKey];

    }
    
    NSDictionary *statusDictionary = [self getDayStatusDictionary];
    detailsDictionay[@"compare"] = [NSMutableDictionary new];
    
    switch (compareType) {
        default:
        case DFCompareOverDue: detailsDictionay[@"compare"][@"isOverdue"] = statusDictionary[IsOverdueKey]; break;
        case DFCompareYesterday: detailsDictionay[@"compare"][@"isYesterday"] = statusDictionary[IsYesterdayKey]; break;
        case DFCompareToday: detailsDictionay[@"compare"][@"isToday"] = statusDictionary[IsTodayKey]; break;
        case DFCompareTomorrow: detailsDictionay[@"compare"][@"isTomorrow"] = statusDictionary[IsTomorrowKey]; break;
        case DFCompareFuture: detailsDictionay[@"compare"][@"isFuture"] = statusDictionary[IsFutureKey]; break;
    }
    
    detailsDictionay[@"formatter"] = [NSMutableDictionary new];
    detailsDictionay[@"formatter"][@"format"] = format;
    detailsDictionay[@"isShortForm"] = @(isShortFormat);
    
    return detailsDictionay;
}
    
-(NSDictionary *)getFullDetailsDictionary {
    
    NSMutableDictionary *detailsDictionay = [NSMutableDictionary new];
    
    for(NSDictionary *dict in @[@{@"string":@"currentDate", @"date":currentDate},
                                @{@"string":@"betweenDate", @"date":betweenDate}]) {
        
        detailsDictionay[dict[@"string"]] = [NSMutableDictionary new];
        detailsDictionay[dict[@"string"]][@"date"] = dict[@"date"];
        [detailsDictionay[dict[@"string"]] addEntriesFromDictionary:[self getDayDictionaryWithDate:dict[@"date"]]];
        [detailsDictionay[dict[@"string"]] addEntriesFromDictionary:[self getWeekStringDictionaryWithDate:dict[@"date"]]];
        [detailsDictionay[dict[@"string"]] addEntriesFromDictionary:[self getMonthStringDictionaryWithDate:dict[@"date"]]];
        [detailsDictionay[dict[@"string"]] addEntriesFromDictionary:[self getDateDetailDictionaryWithDate:dict[@"date"]]];
        
    }
    
    detailsDictionay[@"compare"] = [NSMutableDictionary new];
    [detailsDictionay[@"compare"] addEntriesFromDictionary:[self getDayStatusDictionary]];
    [detailsDictionay[@"compare"] addEntriesFromDictionary:[self calculateBetweenDayWithCurrentDate:currentDate betweenDate:betweenDate]];
    
    for(NSDictionary *dict in @[@{@"string":@"formatter", @"formatter":formatter, @"format":format},
                                @{@"string":@"formatter_default", @"formatter":defaultFormatter, @"format":DefaultDateFormat}]) {
        
        NSDateFormatter *formatter_temp = dict[@"formatter"];
        detailsDictionay[dict[@"string"]] = [NSMutableDictionary new];
        detailsDictionay[dict[@"string"]][@"format"] = dict[@"format"];
        if (@available(iOS 10.0, *)) {
            detailsDictionay[dict[@"string"]][@"language"] = formatter_temp.locale.languageCode;
            detailsDictionay[dict[@"string"]][@"currency"] = formatter_temp.locale.currencyCode;
        }
        detailsDictionay[dict[@"string"]][@"timezone"] = formatter_temp.timeZone;
    }

    detailsDictionay[@"isShortForm"] = @(isShortFormat);
    
    return detailsDictionay;
}
    
- (BOOL (^)(void)) booleanValue {
    
    self.modify();
    return ^(void) {
        
        BOOL value = NO;
        NSDictionary *statusDictionary = [self getDayStatusDictionary];
        
        switch (compareType) {
            default:
            case DFCompareOverDue: value = statusDictionary[IsOverdueKey]; break;
            case DFCompareYesterday: value = statusDictionary[IsYesterdayKey]; break;
            case DFCompareToday: value = statusDictionary[IsTodayKey]; break;
            case DFCompareTomorrow: value = statusDictionary[IsTomorrowKey]; break;
            case DFCompareFuture: value = statusDictionary[IsFutureKey]; break;
        }
        
        self.clear();
        return value;
    };
    
}

- (NSString * (^)(void))stringValue {
    self.modify();
    return ^(void) {
        
        NSDictionary *currentDateDictionary = [self getDayDictionaryWithDate:currentDate];
        NSString *value = currentDateDictionary[(isShortFormat)?DateShortStringKey:(isLongFormat)?DateLongStringKey:DateStringKey];
        
        self.clear();
        return value;
    };
}

- (NSDate * (^)(void))dateValue {
    self.modify();
    return ^(void) {
        NSDate* value = currentDate;
        self.clear();
        return value;
    };
}

- (NSDictionary * (^)(void))basicDetails {
    self.modify();
    return ^(void) {
        NSDictionary* value = [self getBasicDetailsDictionary];
        self.clear();
        return value;
    };
}
    
- (NSDictionary * (^)(void))fullDetails {
    self.modify();
    return ^(void) {
        NSDictionary* value = [self getFullDetailsDictionary];
        self.clear();
        return value;
    };
}

#pragma mark - Clear ----------------------
- (DateCalculator * (^)(void))clear {
    return ^(void) {
        compareType = DFCompareOverDue;
        currentDate = [NSDate new];
        betweenDate = [NSDate new];
        
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
            calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        } else {
            calendar = [NSCalendar currentCalendar];
        }
        
        year = -1;
        month = -1;
        day = -1;
        hour = -1;
        minute = -1;
        second = -1;
        format = DefaultDateFormat;
        relatedDateArray = (relatedDateArray)?:[NSMutableArray new];
        [relatedDateArray removeAllObjects];
        modifyDateArray = (modifyDateArray)?:[NSMutableArray new];
        [modifyDateArray removeAllObjects];
        defaultFormatter = (defaultFormatter)?:[NSDateFormatter new];
        formatter = defaultFormatter;
        isShortFormat = NO;
        isLongFormat = NO;
        return self;
    };
}

@end
