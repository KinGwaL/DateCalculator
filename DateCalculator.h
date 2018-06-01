//
//  DateFormatter.h
//
//  Created by King on 18/12/2017.
//  Copyright © 2017年 King All rights reserved.
//

/*Example
 
    NSDictionary* value = formatter.about.currentDate(nil).day(21).next(1, DFHour).modify().
    and.betweenDate(nil).year(2018).past(2,DFDay).modify().
    check.currentDate(nil).isTomorrow.orNot.with.basicDetails();

 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DFCompareType) {
    DFCompareOverDue = 0,
    DFCompareYesterday = 1,
    DFCompareToday = 2,
    DFCompareTomorrow = 3,
    DFCompareFuture = 4
};

typedef NS_ENUM(NSInteger, DFObject) {
    DFYear = 0,
    DFMonth = 1,
    DFDay = 2,
    DFHour = 3,
    DFMinute = 4,
    DFSecond = 5
};

@interface DateCalculator : NSObject 

#pragma mark - Initial Setting --------------
+ (DateCalculator *)calculateDate:(void (^)(DateCalculator *))block;

#pragma mark - Increase readability ---------
- (DateCalculator * )check;
- (DateCalculator * )orNot;
- (DateCalculator * )with;
- (DateCalculator * )and;
- (DateCalculator * )display;
- (DateCalculator * )from;
- (DateCalculator * )about;
- (DateCalculator * )set;

#pragma mark - Date Format Type --------------
- (DateCalculator * )isOverdue;
- (DateCalculator * )isYesterday;
- (DateCalculator * )isToday;
- (DateCalculator * )isTomorrow;
- (DateCalculator * )isFuture;

#pragma mark - Data Setting ------------------
///currentDate(nil) == [NSDate date]
- (DateCalculator * (^)(NSDate *))currentDate;
///betweenDate(nil) == [NSDate date]
- (DateCalculator * (^)(NSDate *))betweenDate;

//Current Date by default
- (DateCalculator * (^)(NSInteger))year;
- (DateCalculator * (^)(NSInteger))month;
- (DateCalculator * (^)(NSInteger))day;
- (DateCalculator * (^)(NSInteger))hour;
- (DateCalculator * (^)(NSInteger))minute;
- (DateCalculator * (^)(NSInteger))second;

///Default is yyyy-MM-dd HH:mm:ss
- (DateCalculator * (^)(NSString *))format;
- (DateCalculator * (^)(NSDateFormatter *))formatter;
- (DateCalculator * (^)(NSDateFormatter *))defaultFormatter;

//- (DateFormatter * (^)(NSDate *date, ...))about;

///E.g. Sunday -> Sun / October -> Oct
- (DateCalculator * )isShortFormat;
///E.g October / Sunday
- (DateCalculator * )isLongFormat;

#pragma mark - Modify ------------------------
///Modify the date immediately
- (DateCalculator * (^)(void))modify;
///E.g. next(1, DFHour)
- (DateCalculator * (^)(NSInteger number, DFObject object))next;
///E.g. past(2,DFDay)
- (DateCalculator * (^)(NSInteger number, DFObject object))past;

#pragma mark - Output ------------------------
//CurrentDate compare with BetweenDate only

///Return value follow DFCompareType, default is DFCompareOverDue
- (BOOL (^)(void)) booleanValue;
- (NSDate * (^)(void))dateValue;
///Default is date string, isShortFormat/isLongFormat will affect the result
- (NSString * (^)(void))stringValue;
    
//- (NSArray * (^)(void))dateArray; // currentDate + betweenDate
//- (NSArray * (^)(void))stringArray; // currentDate + betweenDate

- (NSDictionary * (^)(void))basicDetails;
- (NSDictionary * (^)(void))fullDetails;

#pragma mark - Function ----------------------
- (DateCalculator * (^)(void))clear;

#pragma mark - Normal Function ---------------
- (NSDictionary *)getDayDictionaryWithDate:(NSDate *)date;
- (NSDictionary *)getWeekStringDictionaryWithDate:(NSDate *)date;
-(NSDictionary *)getMonthStringDictionaryWithDate:(NSDate *)date;
/// Check to see if the current time is between the two arbitrary times, ignoring the date portion:
- (BOOL)currentTimeIsBetweenTimeWithTimeString1:(NSString *)timeString1 withTimeString2:(NSString *)timeString2;

@end
