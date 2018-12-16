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
		self.usesGIF = [[arg3 properties] valueForKey:@"usesGIF"] ? [[[arg3 properties] valueForKey:@"usesGIF"] boolValue] : NO;
		self.compressionQuality = [[arg3 properties] valueForKey:@"compressionQuality"] ? [[[arg3 properties] valueForKey:@"compressionQuality"] floatValue] : 1.0;
		self.allowsVideos = [[arg3 properties] valueForKey:@"allowsVideos"] ? [[[arg3 properties] valueForKey:@"allowsVideos"] boolValue] : NO;
		self.videoPath = [[arg3 properties] valueForKey:@"videoPath"];
	}
	return self;
}

-(void)didMoveToWindow
{
    [super didMoveToWindow];
	
    if (!previewImage)
    {
		CGFloat imgSize = self.frame.size.height - 10;
		previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 15, 5, imgSize, imgSize)];
		[previewImage setContentMode:UIViewContentModeScaleAspectFill];
		[previewImage setClipsToBounds:YES];
		[self addSubview:previewImage];

		NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:self.key inDomain:self.defaults];
        UIImage* img = [UIImage imageWithData:data];
		if (img)
		{
	        previewImage.image = img;
		}
		else if (self.videoPath)
		{
			NSURL* fileURL = [NSURL fileURLWithPath:self.videoPath];
			//get image from video
			AVURLAsset* asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
			AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
			UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
			previewImage.image = image;
		}
    }
}

-(void)chooseImage
{
	UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

	if (self.allowsVideos)
	{
		picker.mediaTypes = @[(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie];
	}
	picker.delegate = self;
    [listController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = picker.view.frame;
	spinner.hidesWhenStopped = YES;
	[picker.view addSubview:spinner];
	[spinner startAnimating];

	NSURL* refURL = [info objectForKey:UIImagePickerControllerReferenceURL];
	if (refURL)
	{
		PHAsset* asset = [[PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil] lastObject];
		if (asset)
		{
			if (asset.isVideo)
			{
				//user chose a video
				[[PHImageManager defaultManager] requestExportSessionForVideo:asset options:nil exportPreset:AVAssetExportPresetHighestQuality resultHandler:^(AVAssetExportSession* exportSession, NSDictionary* info) {
					NSURL* fileURL = [NSURL fileURLWithPath:self.videoPath];
					exportSession.outputURL = fileURL;
					if ([[self.videoPath lowercaseString] hasSuffix:@".mov"])
					{
						exportSession.outputFileType = AVFileTypeQuickTimeMovie;
					}
					else
					{
						exportSession.outputFileType = AVFileTypeMPEG4;
					}
					[exportSession exportAsynchronouslyWithCompletionHandler:^{
						//get image from video
						AVURLAsset* asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
						AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
						UIImage* image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
						previewImage.image = image;
					}];
				}];
				[[NSUserDefaults standardUserDefaults] setObject:nil forKey:self.key inDomain:self.defaults];
				notify_post([self.postNotification UTF8String]);
			}
			else
			{
				//delete video
				if (self.videoPath)
				{
					[[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
				}

				//user chose an image
				[[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable data, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
				{
					if (data)
					{
						UIImage* image = [UIImage imageWithData:data];

						if (self.usesJPEG)
						{
							data = UIImageJPEGRepresentation(image, self.compressionQuality);
						}
						else if (!self.usesGIF)
						{
							data = UIImagePNGRepresentation(image);
						}

						[[NSUserDefaults standardUserDefaults] setObject:data forKey:self.key inDomain:self.defaults];
						notify_post([self.postNotification UTF8String]);

						previewImage.image = image;
					}
				}];
			}

			[listController dismissViewControllerAnimated:YES completion:^{
				[spinner stopAnimating];
			}];
		}
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [listController dismissViewControllerAnimated:YES completion:nil];
}
@end
