#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "libimagepicker.h"

UIImage *LIPParseImage(NSData *imageDataFromPrefs)
{
    return [UIImage imageWithData:imageDataFromPrefs];
}

// vim:ft=objc
