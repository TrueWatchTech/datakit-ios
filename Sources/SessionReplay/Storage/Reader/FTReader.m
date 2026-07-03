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
//  FTReader.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/26.
//

#import "FTReader.h"
#import "FTTLV.h"
@implementation FTBatch
-(instancetype)initWithFile:(id<FTReadableFile>)file datas:(NSArray<FTTLV*> *)datas{
    self = [super init];
    if(self){
        _file = file;
        _tlvDatas = datas;
    }
    return self;
}
- (NSArray *)events{
    NSMutableArray *arrays = [[NSMutableArray alloc]init];
    for (FTTLV *tlv in self.tlvDatas) {
        [arrays addObject:tlv.value];
    }
    return arrays;
}
- (NSData *)serialize{
    NSMutableData *data = [[NSMutableData alloc]init];
    for (FTTLV *tlv in self.tlvDatas) {
        [data appendData:[tlv serialize]];
    }
    return data;
}
@end

#endif
