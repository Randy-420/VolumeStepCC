#import "vscc.h"

#define SETTINGS_CHANGED "com.randy420.volumestepprefs.settingschanged"
#define PREFS CFSTR("com.randy420.volumestepprefs")
#define PLIST @"/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"

@implementation vscc
static BOOL GetBool(NSString *key, BOOL defaultValue) {
	Boolean exists;
	Boolean result = CFPreferencesGetAppBooleanValue((CFStringRef)key, CFSTR("com.randy420.volumestepprefs"), &exists);
	return exists ? result : defaultValue;
}

- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:(68.0/255.0) green:(220.0/255.0) blue:(75.0/255.0) alpha:1.0];
}

- (bool)isSelected {
	return GetBool(@"VSStepEnabled", NO);
}

- (void)setSelected:(bool)selected {
	[super refreshState];
	NSMutableDictionary *Dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:PLIST]];
	[Dict setValue:[NSNumber numberWithBool:selected] forKey:@"VSStepEnabled"];
	[Dict writeToFile:PLIST atomically:YES];
	CFPreferencesSetAppValue((CFStringRef)@"VSStepEnabled", (CFPropertyListRef)@(selected), PREFS);
	CFPreferencesAppSynchronize(PREFS);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR(SETTINGS_CHANGED), NULL, NULL, TRUE);
}
@end