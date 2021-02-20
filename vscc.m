#import "vscc.h"

#define SETTINGS_CHANGED "com.randy420.volumestepprefs.settingschanged"
#define PREFS @"/var/mobile/Library/Preferences/com.randy420.volumestepprefs.plist"

@implementation vscc
- (UIImage *)iconGlyph {
	return [UIImage imageNamed:@"icon" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
}

- (UIColor *)selectedColor {
	return [UIColor colorWithRed:(68.0/255.0) green:(220.0/255.0) blue:(75.0/255.0) alpha:1.0];
}

- (bool)isSelected {
	NSMutableDictionary *Dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFS]];

	return [(NSNumber *)[Dict objectForKey:@"VSStepEnabled"] boolValue];
}

- (void)setSelected:(bool)selected {
	_selected = selected;
	[super refreshState];
	NSMutableDictionary *Dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:PREFS]];
	[Dict setValue:[NSNumber numberWithBool:_selected] forKey:@"VSStepEnabled"];
	[Dict writeToFile:PREFS atomically:YES];
	[self post];
}

-(void)post {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR(SETTINGS_CHANGED), NULL, NULL, TRUE);
}
@end
