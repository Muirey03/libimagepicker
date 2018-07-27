# libimagepicker
### How to implement:
- Search and install **the latest libimagepicker** from Cydia.
- Copy **/usr/lib/libimagepicker.dylib** from either your iOS device or from this repository to your **$THEOS/lib** folder.
- Add `TWEAKNAMEPREFS_LIBRARIES = imagepicker` to your Pref's Makefile.
- Add `TWEAKNAME_LIBRARIES = imagepicker` to your Tweak's Makefile if needed.
- Download libimagepicker.h from this repository and place it in your **$THEOS/include** folder.

### Adding libimagepicker into your tweak's prefs bundle:

##### Images must be stored in a different plist to any other settings in your tweak!

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
		</dict>
```