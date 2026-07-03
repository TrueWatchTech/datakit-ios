//  Copyright 2024 Shanghai Guance Information Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTFile.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/21.
//

#import "FTFile.h"
@interface FTFile()

@end
@implementation FTFile
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if(self){
        _url = url;
        _name = [url lastPathComponent];
        [self removeNamePrefixAndSeparator];
    }
    return self;
}
- (NSDate *)modifiedAt{
    NSError *error;
    NSDate *date = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.url.path error:&error] fileCreationDate];
    return date;
}
- (void)append:(NSData *)data{
    NSError *error;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:self.url error:&error];
    if (@available(macOS 10.15, iOS 13.0, *)) {
        __autoreleasing NSError *error = nil;
        [fileHandle seekToEndReturningOffset:nil error:&error];
        [fileHandle writeData:data error:&error];
        [fileHandle closeAndReturnError:&error];
    } else {
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
    }
}
- (void)write:(NSData *)data{
    NSError *error;
    [data writeToURL:self.url options:NSDataWritingAtomic error:&error];
}
- (NSInputStream *)stream{
    NSInputStream *stream = [NSInputStream inputStreamWithURL:self.url];
    return stream;
}
- (long long)size{
    NSError *error;
    long long size = [[[NSFileManager defaultManager] attributesOfItemAtPath:self.url.path error:&error] fileSize];
    return size;
}
- (void)deleteFile{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:self.url error:&error];
}
-(NSDate *)fileCreationDate{
    if(!_fileCreationDate){
        NSTimeInterval time = self.name?[self.name doubleValue]/1000:0;
        _fileCreationDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    }
    return _fileCreationDate;
}
- (void)removeNamePrefixAndSeparator{
    if (!self.name) {
        return;
    }
    NSString *separator = @"_";
    NSRange lastSeparatorRange = [self.name rangeOfString:separator options:NSBackwardsSearch];
    if (lastSeparatorRange.location != NSNotFound) {
        NSString *pureName = [self.name substringFromIndex:lastSeparatorRange.location + 1];
        if (pureName.length > 0 ) {
            self.name = pureName;
        }
    }
}
@end

#endif
