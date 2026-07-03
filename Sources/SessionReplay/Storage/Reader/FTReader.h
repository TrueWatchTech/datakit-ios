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
//  FTReader.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FTTLV;
@protocol FTReadableFile;

@interface FTBatch : NSObject
@property (nonatomic, strong) NSArray<FTTLV*> *tlvDatas;
@property (nonatomic, strong) id<FTReadableFile> file;
-(instancetype)initWithFile:(id<FTReadableFile>)file datas:(NSArray<FTTLV*> *)datas;
- (NSArray *)events;
- (NSData *)serialize;
@end
@protocol FTReader <NSObject>
- (NSArray<id<FTReadableFile>>*)readFiles:(int)limit;
- (nullable FTBatch*)readBatch:(id<FTReadableFile>)file;
- (void)markBatchAsRead:(FTBatch*)batch;
   
@end

NS_ASSUME_NONNULL_END

#endif
