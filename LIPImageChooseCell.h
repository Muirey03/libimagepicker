#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>

@interface UIImage(lIP)
+(id)imageAtPath:(id)arg1;
@end

@interface LIPImageChooseCell : PSTableCell <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIViewController* listController;
    UIImageView* previewImage;
}
@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* defaults;
@property (nonatomic, retain) NSString* postNotification;
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(id)arg3;
-(void)chooseImage;
@end
