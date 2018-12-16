# libimagepicker
### How to implement:
- Search and install **the latest libimagepicker** from Cydia.
- Copy **/usr/lib/libimagepicker.dylib** from either your iOS device or from this repository to your **$THEOS/lib** folder.
- Add `TWEAKNAMEPREFS_LIBRARIES = imagepicker` to your Pref's Makefile.
- Add `TWEAKNAME_LIBRARIES = imagepicker` to your Tweak's Makefile if needed.
- Download libimagepicker.h from this repository and place it in your **$THEOS/include** folder.

### Adding libimagepicker into your tweak's prefs bundle:

Add a new dictionary in your preference's specifier plist like this:
```
		<dict>
			<key>cell</key>
			<string>PSLinkCell</string>
			<key>cellClass</key>
			<string>LIPImageChooseCell</string>
			<key>label</key>
			<string>CHOOSE IMAGE LABEL</string>
			<key>action</key>
			<string>chooseImage</string>
			<key>defaults</key>
			<string>YOUR PREFS PLIST IDENTIFIER</string>
			<key>key</key>
			<string>SAVE KEY</string>
			<key>PostNotification</key>
			<string>NOTIFICATION TO POST (OPTIONAL)</string>
			<key>usesJPEG</key>
			<false/> <!-- Whether to use JPEG compression, defaults to false -->
			<key>compressionQuality</key>
			<real>DESIRED COMPRESSION QUALITY</real> <!-- The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality). -->
			<key>usesGIF</key> <!-- defaults to false - set this to true to write gif data instead of png data when a gif is chosen (overriden by usesJPEG) -->
			<true/>
			<key>allowsVideos</key> <!-- allow videos to be chosen as well as images - if this is true, a videoPath key must also be specified -->
			<true/>
			<key>videoPath</key>
			<string>PATH TO STORE VIDEO AT</string>
		</dict>
```

#### Example:
```
		<dict>
			<key>cell</key>
			<string>PSLinkCell</string>
			<key>cellClass</key>
			<string>LIPImageChooseCell</string>
			<key>label</key>
			<string>Choose image</string>
			<key>action</key>
			<string>chooseImage</string>
			<key>defaults</key>
			<string>com.muirey03.liptestimages</string>
			<key>key</key>
			<string>backgroundImage</string>
			<key>usesJPEG</key>
			<true/>
			<key>compressionQuality</key>
			<real>0.8</real>
		</dict>
```

### Accessing images from your Tweak.xm:

#### IF YOU HAVE allowsVideos ENABLED, SKIP TO "Accessing Videos from your Tweak.xm"

Images are stored in your defaults plist as NSData. You can access this data in exactly the same way you would with any other value stored in a plist. Once you've got the image as data, you can convert it to a UIImage either by using `[UIImage imageWithData:data]` or by using `LIPParseImage(data)`.

#### Example:
```
	NSString* const imagesDomain = @"com.muirey03.liptestimages";
	NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage" inDomain:imagesDomain];
	UIImage* bgImage = [UIImage imageWithData:data];
```

### Accessing Videos from your Tweak.xm:

When the `allowsVideos` key is set to true, both videos and images can be chosen. In order to check which has been chosen by the user in your Tweak.xm, you simply need to check for the existence of videoPath.

#### Example:
```
	NSString* const imagesDomain = @"com.muirey03.liptestimages";
	NSString* const videoPath = @"/var/mobile/Library/liptest.mp4";

	if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath])
	{
		//user chose a video
		NSURL* videoURL = [NSURL fileURLWithPath:videoPath];
		AVPlayer* player = [AVPlayer playerWithURL:videoURL];
	}
	else
	{
		//user chose a image/gif
		NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundImage" inDomain:imagesDomain];
		UIImage* bgImage = [UIImage imageWithData:data];
	}
```
