#define ucfirst(s) ([s stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[s substringToIndex:1] capitalizedString]])
