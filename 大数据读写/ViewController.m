//
//  ViewController.m
//  大数据读写
//
//  Created by 铁血-mac on 2017/12/15.
//  Copyright © 2017年 tiexue. All rights reserved.
//

#import "ViewController.h"
#include "utf.h"

@interface ViewController ()<NSStreamDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger timeInt = 1514435616;
    float dig = timeInt/pow(10, 12);
    if (dig>1&&dig<10) {
        timeInt = timeInt/1000;
    }else if (timeInt/pow(10, 9)!=10){
        NSLog(@"未知");
    };
    NSLog(@"%ld",timeInt);
    return;
    NSInteger nowTime = time(NULL);
    NSLog(@"%ld",nowTime);
    
    NSDate  *conformTimesp=[NSDate dateWithTimeIntervalSince1970:1514435616];
    
    NSCalendar *gregorian = [[ NSCalendar alloc ] initWithCalendarIdentifier : NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:conformTimesp toDate:[NSDate date] options: 0 ];
   
    NSInteger years = [components year];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger min = [components minute];
    NSInteger sec = [components second];
    NSLog(@"year:%ld,months:%ld,days:%ld,hours:%ld,mins:%ld,sec:%ld",years,months,days,hours,min,sec);
    return;
    NSLog(@"start");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"8888" ofType:@"txt"];
//    NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:0x80000632 error:nil];
//    NSLog(@"%@",str);
//    return;
//    NSInputStream *inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
//    inputStream.delegate = self;
//    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [inputStream open];
//
//    return;
    //
    readNBytes(path.UTF8String, 3);
    return;
    FILE *pfile = fopen(path.UTF8String, "rb");
    if (pfile == NULL) {
        NSLog(@"fasle");
        return;
    }
    fseek(pfile, 0, SEEK_END);
    long len = ftell(pfile);
    fseek(pfile, 0, SEEK_CUR);
    char new[2];
    //
    long offset = 0;
    long lengh = len;
    do {
        fseek(pfile, offset, SEEK_SET);
        offset++;
        fgets(new, 2, pfile);
        printf("%s\n",new);
        NSLog(@"%ld",lengh);
    } while (lengh--);
    
    return;

//    NSLog(@"start");
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"59429" ofType:@"txt"];
//    NSFileHandle *fileHadle = [NSFileHandle fileHandleForReadingAtPath:path];
//    NSUInteger length = [fileHadle availableData].length;
//    NSLog(@"%lu",(unsigned long)length);
//    NSUInteger offset = 0;
//    NSMutableArray *sepArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:0], nil];
//    [fileHadle seekToFileOffset:offset];
//    //
//    NSData *nextData = [[NSData alloc] initWithBytes:"\n" length:1];
//    NSData *newData  = nil;
//    do {
//        [fileHadle readDataOfLength:1];
////        if ([data isEqualToData:nextData]) {
////            NSNumber *number = [sepArr lastObject];
////            [fileHadle seekToFileOffset:[number integerValue]];
////            NSData *strdata =  [fileHadle readDataOfLength:offset-[number integerValue]];
////            NSString *string = [[NSString alloc] initWithData:strdata encoding:NSUTF8StringEncoding];
////            [sepArr addObject:[NSNumber numberWithInteger:offset+1]];
////        }
//        offset++;
//        [fileHadle seekToFileOffset:offset];
////        data = nil;
//    } while (length--);
//    NSLog(@"over");
//    //
//    [fileHadle closeFile];
}
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventNone: {
            //
            break;
        }
        case NSStreamEventOpenCompleted: {
            //
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            //
            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:0], nil];
            //
            uint8_t buf[1];
            long len = [(NSInputStream *)aStream read:buf maxLength:1];  // 读取数据
            if (len) {
                if (buf[0] == '\n') {
                    NSNumber *number = [mutArr lastObject];
                    NSLog(@"%s",buf);
                }

            }
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            //
            break;
        }
        case NSStreamEventErrorOccurred: {
            //
            break;
        }
        case NSStreamEventEndEncountered: {
            //
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSDefaultRunLoopMode];
            aStream = nil;
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

void readNBytes(char *fileName, int n)
{
    //
    FILE *fp = fopen(fileName, "r");
    unsigned char *buf = (unsigned char*)malloc(sizeof(unsigned char)*n);
    //
    if(fp == NULL)
    {
        printf("open file [%s] failed.\n", fileName);
        return;
    }
    //
    fread(buf, sizeof(unsigned char), n, fp);
    
    //
    unsigned int code = 0x80000632;
    BOOL checked = NO;
    NSString *str = @"gbk";
    //
    if (buf[0] == 0xFF && buf[1] ==  0xFE) {
        code = 10;
        str = @"UTF-16LE";
        checked = true;
    } else if (buf[0] ==  0xFE && buf[1] ==0xFF) {
        str = @"UTF-16BE";
        code = 0x90000100;
        checked = true;
    } else if (buf[0] == 0xEF && buf[1] == 0xBB&& buf[2] == 0xBF) {
        str = @"UTF-8";
        code = 4;
        checked = true;
    }
    fseek(fp, 0, SEEK_SET);
    //
    unsigned char *newbuf = (unsigned char*)malloc(sizeof(unsigned char)*1);
    if (!checked) {
        
        while (fread(newbuf, sizeof(unsigned char), 1, fp)) {
            if (newbuf[0] >= 0xF0)
                break;
            if (0x80 <= newbuf[0] && newbuf[0] <= 0xBF) // 单独出现BF以下的，也算是GBK
                break;
            if (0xC0 <= newbuf[0] && newbuf[0] <= 0xDF) {
                fread(newbuf, sizeof(unsigned char), 1, fp);
                if (0x80 <= newbuf[0] && newbuf[0] <= 0xBF) // 双字节 (0xC0 - 0xDF)
                    // (0x80 - 0xBF),也可能在GB编码内
                    continue;
                else
                    break;
            } else if (0xE0 <= newbuf[0] && newbuf[0] <= 0xEF) {// 也有可能出错，但是几率较小
                fread(newbuf, sizeof(unsigned char), 1, fp);
                if (0x80 <= newbuf[0] && newbuf[0] <= 0xBF) {
                    fread(newbuf, sizeof(unsigned char), 1, fp);
                    if (0x80 <= newbuf[0] && newbuf[0] <= 0xBF) {
                        str = @"UTF-8";
                        code = 4;
                        break;
                    } else
                        break;
                } else
                    break;
            }
        }
    }
    //
    buf = nil;
    newbuf = nil;
    free(buf);
    free(newbuf);
    
    //
//    fseek(fp, 0, SEEK_END);
//    long lens = ftell(fp);
//    unsigned char *allbuf = (unsigned char*)malloc(sizeof(unsigned char)*1024*15);
//    fseek(fp, 0, SEEK_SET);
//    fread(allbuf, sizeof(unsigned char), 1, fp);
//    NSString *contentStr = [[NSString alloc] initWithCString:allbuf encoding:code];
    //
//    NSString *contentStr = [[NSString alloc] initWithContentsOfFile:[NSString stringWithUTF8String:fileName] encoding:NSUnicodeStringEncoding error:nil];
//
//    NSLog(@"%@",contentStr);
//    NSLog(@"%u",code);
//    NSLog(@"%@",str);
    //
//    return;
    fseek(fp, 0, SEEK_END);
    long len = ftell(fp);
    long lenth = len;
    //
    fseek(fp, 0, SEEK_SET);
    //换行位置(第几个字符)
    NSMutableArray *mutArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithUnsignedInteger:0], nil];
    //
    NSUInteger nowLoc = 0;
    unsigned char *changeChar = (unsigned char*)malloc(sizeof(unsigned char));
    while (--lenth){
        fread(changeChar, sizeof(unsigned char), 1, fp);
        nowLoc++;
        if (changeChar[0] == '\n') {
            [mutArr addObject:[NSNumber numberWithUnsignedInteger:nowLoc]];
        }
//        printf(changeChar);
    } ;
    if (![mutArr containsObject:[NSNumber numberWithUnsignedInteger:len]]) {
        [mutArr addObject:[NSNumber numberWithUnsignedInteger:len]];
    }
    //
    NSLog(@"%@",[mutArr subarrayWithRange:NSMakeRange(0, 10)]);
//    for (int i=0;i<mutArr.count;i++) {
//        if (i==0) {
//            continue;
//        }
//        NSUInteger loction = [mutArr[i] unsignedIntegerValue]-1;
//        NSUInteger lastLoction = [mutArr[i-1] unsignedIntegerValue];
//        fseek(fp, lastLoction, SEEK_SET);
//        unsigned char *comtent = (unsigned char*)malloc(sizeof(unsigned char)*(loction-lastLoction));
//        fread(comtent, sizeof(unsigned char), loction-lastLoction, fp);
//        NSString *str = [NSString stringWithCString:comtent encoding:code];
//        NSLog(@"%@",str);
//        printf(comtent);
//
//    }
    fseek(fp, 0, SEEK_SET);
//    NSLog(@"%lu", sizeof(char));
    unsigned char *firstChar  = (unsigned char*)malloc(sizeof(unsigned char)*14*2);
    unsigned char *secondChar = (unsigned char*)malloc(sizeof(unsigned char)*12);
    unsigned char *thirdChar = (unsigned char*)malloc(sizeof(unsigned char)*12);
    fread(firstChar, 2, 14, fp);
    fseek(fp, 18, SEEK_SET);
    fread(secondChar, sizeof(unsigned char), 6, fp);
    fread(thirdChar, sizeof(unsigned char), 12, fp);
    NSLog(@"%s -- %s -- %s",firstChar,secondChar,thirdChar);
    unsigned char all[100];
    strcat(all, firstChar);
    strcat(all, secondChar);
    strcat(all, thirdChar);
    
    NSString *strsss = [NSString stringWithCString:firstChar encoding:code];
    NSLog(@"sss:%@",strsss);
    
//    NSData *data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithUTF8String:fileName]];
    
    
    
    
//    test
//    fseek(fp, 0, SEEK_SET);
////    unsigned char *comtents = (unsigned char*)malloc(sizeof(unsigned char)*32);
//    char line[1024];
//    //
//    while(fgets(line,1024,fp)!=NULL)//逐行读取
//    {
//        NSLog(@"%ld", ftell(fp));
//        printf("%s", line);
//        NSString *news = [NSString stringWithCString:line encoding:code];
//        NSLog(@"%@",news);
//        break;
//    }
    //
//    fread(comtents, sizeof(unsigned char),32, fp);
//    NSString *news = [NSString stringWithCString:comtents encoding:code];
//    NSLog(@"%@",news);
    fclose(fp);
    
    
}

+ (NSString*)getDateFormDateline:(NSString*)dataline{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *conformTimesp=[NSDate dateWithTimeIntervalSince1970:[dataline integerValue]];
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:conformTimesp];
    NSDate   *localeDate =[conformTimesp dateByAddingTimeInterval:interval];
    
    //
    NSDate   *today = [[NSDate alloc] init];
    NSString *todayAllString = [formatter stringFromDate:today];
    //
    NSString * todayString = [todayAllString substringWithRange:NSMakeRange(5, 5)];
    
    NSString * dateString = [[localeDate description] substringWithRange:NSMakeRange(5, 5)];
    
    if ([dateString isEqualToString:todayString])
    {
        return [[localeDate description] substringWithRange:NSMakeRange(11, 5)];
    }
    return [[localeDate description]substringWithRange:NSMakeRange(5, 5)];
}
+ (NSString *)getDateForChatFormDateline:(NSString *)dataline{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate  *conformTimesp=[NSDate dateWithTimeIntervalSince1970:[dataline integerValue]];
    NSTimeZone *zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:conformTimesp];
    NSDate   *localeDate =[conformTimesp dateByAddingTimeInterval:interval];
    //
    NSDate   *today = [[NSDate alloc] init];
    NSString *todayAllString = [formatter stringFromDate:today];
    //
    NSString * todayString = [todayAllString substringWithRange:NSMakeRange(5, 5)];
    
    NSString * dateString = [[localeDate description] substringWithRange:NSMakeRange(5, 5)];
    
    if ([dateString isEqualToString:todayString])
    {
        return [[localeDate description] substringWithRange:NSMakeRange(11, 5)];
    }
    return [[localeDate description]substringWithRange:NSMakeRange(0, 16)];
    
}
@end
