//
//  ViewController.m
//  capture-sample
//
//  Created by ae06710 on 2/28/15.
//  Copyright (c) 2015 ae06710. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)captureWithHierarchy:(UIButton *)sender {
    for (int i=0; i < 11; i++) {
        [ViewController screenCaptureWithStore:false CallHierarchy:YES];
        [NSThread sleepForTimeInterval:0.1];
    };
}

- (IBAction)captureWithRender:(UIButton *)sender {
    for (int i=0; i < 11; i++) {
        [ViewController screenCaptureWithStore:false CallHierarchy:NO];
        [NSThread sleepForTimeInterval:0.1];
    };
}

+ (void)screenCaptureWithStore:(BOOL)store CallHierarchy:(BOOL)hierarchy {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIImage *capture;
    UIGraphicsBeginImageContextWithOptions(window.frame.size , NO , 1.0 );

    if (hierarchy) {
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        NSLog(@"Call drawViewHierarchyInRect");
    } else {
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        NSLog(@"Call renderInContext");
    }

    capture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (store) {
        NSString *filePath;
        if (hierarchy) {
            filePath = [ViewController filepathWithPrefix:@"Hierarchy"];
        } else {
            filePath = [ViewController filepathWithPrefix:@"Render"];
        }
        [UIImagePNGRepresentation(capture) writeToFile:filePath atomically:YES];
        NSLog(@"Store %@", filePath);
    }
}

+ (NSString *)timestamp {
    NSDateFormatter *formatter = NSDateFormatter.alloc.init;
    NSCalendar *calendar;
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setCalendar:calendar];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:NSDate.date];
}

+ (NSString *)filepathWithPrefix:(NSString *)prefix {
    NSString *filePath =
        [NSString stringWithFormat:@"%@/%@-%@.png",
            NSTemporaryDirectory(),
            prefix,
            [ViewController timestamp]
        ];
    return filePath;
}

@end
