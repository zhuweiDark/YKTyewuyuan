
//
//  NSStringEX.m
//  BaiduVideo-iPad
//
//  Created by lihai on 12-8-17.
//  Copyright (c) 2012年 Baidu.com. All rights reserved.
//

#import "NSStringEX.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@implementation NSString (path)

+ (NSString *) HomePath
{
	return NSHomeDirectory();
}

+ (NSString *) TempPath
{	
	NSString *path = [NSTemporaryDirectory() stringByStandardizingPath];
	return path;
}

+ (NSString *) DocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (NSString *)LibPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libarariesDirectory = [paths objectAtIndex:0];
	return libarariesDirectory;
}
+ (NSString *) AppPath
{
	return [NSString stringWithFormat:@"%@/BaiduVideo-iPad.app", NSHomeDirectory()];
}

+ (BOOL)RemovePath:(NSString *)path
{
	if (path == nil) 	return NO;
	NSFileManager * FM = [NSFileManager defaultManager];	
	
	return [FM removeItemAtPath: path error: NULL];;
}


- (NSString *)bvDateString{
    static NSDateFormatter * inFormatter = nil;
    static NSDateFormatter * outFormatter = nil;
    if (inFormatter == nil)
    {
        inFormatter = [[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (outFormatter == nil)
    {
        outFormatter = [[NSDateFormatter alloc] init];
        [outFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString * dateString =[outFormatter stringFromDate:
                            [inFormatter dateFromString:self]];
    return dateString;
}

+ (NSString *)normalDateString{
    static NSDateFormatter * inFormatter = nil;
    
    if (inFormatter == nil)
    {
        inFormatter = [[NSDateFormatter alloc] init];
        [inFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString * dateString =[inFormatter stringFromDate:[NSDate date]];
    
    return dateString; 
}

- (UIColor *)toUIColor{
    UIColor * color = nil;
    if ([self length] > 0) 
    {
        int hValue;
        sscanf([self cStringUsingEncoding:NSASCIIStringEncoding], "%x", &hValue);
        color = [UIColor colorWithHexValue:hValue];
    }
    return color;
}
+ (NSString *) spacesForFont:(UIFont *)f Width:(CGFloat)width
{
    // 计算空格数量
	NSString * space_string = @" ";
	CGSize space_size = [space_string sizeWithFont:f];
	
	int nSpaceNum = (width/space_size.width) + 1; 
    //int nSpaceNum = (width)/5 + 1;
	char* spaceArray = (char*)malloc(nSpaceNum);
	memset(spaceArray, 32, nSpaceNum);
	spaceArray[nSpaceNum-1] = 0;
	NSString* nsspaceArray = [NSString stringWithUTF8String:spaceArray];
	free(spaceArray);  
	return nsspaceArray;	
}

- (NSString *)md5Value
{
    const char* str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(str, strlen(str), result);
    
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}
    
	return ret;
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end




@implementation UIColor (HexValue)

+ (id)colorWithHexValue:(NSUInteger)hexValue alpha:(NSUInteger)alpha
{
    CGFloat r = ((hexValue & 0x00FF0000) >> 16) / 255.0;
    CGFloat g = ((hexValue & 0x0000FF00) >> 8) / 255.0;
    CGFloat b = (hexValue & 0x000000FF) / 255.0;
    CGFloat a = alpha / 255.0;
    
    return [self colorWithRed:r green:g blue:b alpha:a];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue
{
    return [self colorWithHexValue:hexValue alpha:255];
}

@end

@implementation NSString (splitString)

+ (NSArray *) splitString:(NSString *)string forWidth:(NSInteger)width useFont:(UIFont *)font
{
    assert(width > 0 && font != nil);
    if(nil == string){
        return nil;
    }
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSString* content = [[NSString alloc] initWithString:string];
    
startup:
    if([content length] > 0)
    {
        if([content sizeWithFont:font].width <= width)
        {
            [array addObject:content];
        }
        else 
        {
            for(int i = [content length] - 1; i >= 0; --i)
            {
                NSString* substr = [content substringToIndex:i];
                if([substr sizeWithFont:font].width <= width)
                {
                    NSInteger index = i;
                    //                    if(isalpha([content characterAtIndex:i])) // english char
                    //                    {
                    //                        while(index >= 0 && !isspace([content characterAtIndex:index])) //backward to whitespace
                    //                            --index;
                    //                        if(index == 0)
                    //                            index = 1; // 如果宽度过小,一个单词都不能容下,就一行一个字符
                    //                    }
                    
                    if(index != i)
                    {
                        NSString* line = [content substringToIndex:index];
                        [array addObject:line];
                    }else
                    {
                        [array addObject:substr];
                    }
                    
                    content = [NSString stringWithString:[content substringFromIndex:index]];
                    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    goto startup;
                }
            }
        }
    }
    
    return array;
}

@end


@implementation NSString (html)

-(NSString*)replaceHtmlSymbol
{
    NSString *str = [self stringByReplacingOccurrencesOfString:@"&#x22" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#x5C" withString:@"\\"];
    str = [str stringByReplacingOccurrencesOfString:@"&#x27" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&rt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    return str;
}

@end
@implementation NSString (Seriel)

+(NSString *) formatStr:(NSString *)src{
    //    if(src == nil
    //       || [src isEqual:[NSNull null]]
    //       || [src isEqualToString:@"NULL"]){
    //        src = nil;
    //    }
    return src;
}
+(NSString *) filterNull:(NSString *)src{
    if (src == nil) {
        return @"";
    }
    return src;
}
+(NSString *) formatNum:(NSString *)src{
    if ([src isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",src];
    }
    return src;
}

@end