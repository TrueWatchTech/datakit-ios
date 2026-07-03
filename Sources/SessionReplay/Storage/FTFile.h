//
//  FTFile.h
//  SessionReplay
//
//  Created by hulilei on 2024/6/21.
//
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FTFileProtocol <NSObject>
@property (nonatomic, strong) NSURL *url;
- (NSDate *)modifiedAt;
@end

@protocol  FTReadableFile <NSObject>
@property (nonatomic, copy) NSString *name;
- (NSInputStream *)stream;
- (void)deleteFile;
@end

@protocol FTWritableFile <NSObject>
@property (nonatomic, copy) NSString *name;

- (long long)size;
- (void)append:(NSData *)data;

@end

@interface FTFile : NSObject<FTReadableFile,FTWritableFile>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *fileCreationDate;
-(instancetype)initWithUrl:(NSURL *)url;
- (void)write:(NSData *)data;
@end

NS_ASSUME_NONNULL_END

#endif
