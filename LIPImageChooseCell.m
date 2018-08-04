#include <notify.h>
#include "LIPImageChooseCell.h"

@implementation LIPImageChooseCell
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier*)arg3
{
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	if (self)
	{
		listController = [arg3 target];
		[arg3 setTarget:self];

		self.key = [[arg3 properties] valueForKey:@"key"];
		self.defaults = [[arg3 properties] valueForKey:@"defaults"];
		self.postNotification = [[arg3 properties] valueForKey:@"PostNotification"];
		self.usesJPEG = [[arg3 properties] valueForKey:@"usesJPEG"] ? [[[arg3 properties] valueForKey:@"usesJPEG"] boolValue] : NO;
		self.compressionRate = [[arg3 properties] valueForKey:@"compressionRate"] ? [[[arg3 properties] valueForKey:@"compressionRate"] floatValue] : 1.0;
	}
	return self;
}

-(void)didMoveToWindow
{
    [super didMoveToWindow];
    if (!previewImage)
    {
        NSDictionary* preferences = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.defaults]];
        UIImage* img = [UIImage imageWithData:preferences[self.key]];
		if (img)
		{
			CGFloat imgSize = self.frame.size.height - 10;
	        previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 15, 5, imgSize, imgSize)];
	        [previewImage setContentMode:UIViewContentModeScaleAspectFill];
	        [previewImage setClipsToBounds:YES];
	        previewImage.image = img;
	        [self addSubview:previewImage];
		}
    }
}

-(void)chooseImage
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [listController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = picker.view.frame;
	spinner.hidesWhenStopped = YES;
	[picker.view addSubview:spinner];
	[spinner startAnimating];

	NSData* data = self.usesJPEG ? UIImageJPEGRepresentation(image, self.compressionRate) : UIImagePNGRepresentation(image);
	NSString* prefsPath = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.defaults];
	NSMutableDictionary* preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsPath];
	if (!preferences)
	{
		preferences = [NSMutableDictionary new];
	}
	[preferences setValue:data forKey:self.key];
	[preferences writeToFile:prefsPath atomically:YES];
	notify_post([self.postNotification UTF8String]);
	previewImage.image = image;

	[listController dismissViewControllerAnimated:YES completion:^{
		[spinner stopAnimating];
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [listController dismissViewControllerAnimated:YES completion:nil];
}
@end
