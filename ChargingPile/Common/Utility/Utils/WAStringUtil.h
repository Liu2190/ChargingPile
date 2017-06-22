/*!
 (NSString*)getWAString:(NSString*)aString;
 (BOOL)compareCString:(char*)aCstr1 Cstr2:(char*)aCstr2;
 (BOOL)compareStringIfOrderedSame:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (BOOL)compareStringIfOrderedAscending:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (BOOL)compareStringIfOrderedSameCaseInsensitive:(NSString *)aStr1 Str2:(NSString *)aStr2;
 (NSString*)uppercaseWAString:(NSString *)aStr;
 (NSString*)lowercaseWAString:(NSString *)aStr;
 (NSString*)capitalizedWAString:(NSString *)aStr;
 (NSString *)calculateStringAndCutoutString :(NSString *)aTextString 
 (NSUInteger )calculateStringLength :(NSString *)aTextString;
 (NSString*)getStringToIndex:(NSInteger)aIndex fromString:(NSString *)aFromString;
 (NSString*)getStringFromIndex:(NSInteger)aIndex fromString:(NSString *)aFromString;
 (NSString*)getStringFromIndex:(NSInteger)aIndex1 Index2:(NSInteger)aIndex2 fromString:(NSString *)aFromString;
 (NSString*)insertString:(NSInteger)aIndex  digString:(NSString *)aDigstring 
 (NSString *)md5ToString:(NSString *)aFromString;
 (NSString *)md5ToData:(NSData *)aData;
 (NSString *)dateToString:(NSData *)aData;
 (NSData *)stringToData:(NSString *)aFromString;
 (Byte *)dataToByte:(NSData *)aData;
 (NSString *)EncodeUTF8Str:(NSString *)aEnCodeStr;
 (NSString *) EncodeGB2312Str:(NSString *) aEnCodeStr;
 (Byte *)string16ToByte:(NSString *)aFromString;
 (NSMutableArray *)removeObjectAtIndex:(unsigned) aIndex fromString:(NSArray *)aFromString;
 (BOOL) validateURL:(NSString *)aURl;
 (CGFloat) getWidthOfString:(NSString *)aString withFont:(UIFont *)aFont;
 (NSString *)getSubStringOfString:(NSString *)aString  
(NSMutableString *)filteNumber:(NSString *) number;
(NSMutableArray*)divideString:(NSString*)aString 