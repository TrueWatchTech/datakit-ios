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
//  FTDataStoreFileWriter.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/7/2.
//

#import "FTDataStoreFileWriter.h"
#import "FTFile.h"
#import "FTDataStore.h"
#import "FTTLV.h"
@interface FTDataStoreFileWriter()
@property (nonatomic, strong) FTFile *file;
@end
@implementation FTDataStoreFileWriter
-(instancetype)initWithFile:(FTFile *)file{
    self = [super init];
    if(self){
        _file = file;
    }
    return self;
}
- (void)write:(NSData *)data version:(FTDataStoreKeyVersion)version{
    NSData *typeData = [NSData dataWithBytes:&version length:sizeof(version)];
    FTTLV *versionTLV = [[FTTLV alloc]initWithType:DataStoreBlockTypeVersion value:typeData];
    FTTLV *dataTLV = [[FTTLV alloc]initWithType:DataStoreBlockTypeData value:data];
    NSMutableData *encoded = [[NSMutableData alloc]init];
    NSData *versionSerialize = [versionTLV serialize:sizeof(FTDataStoreKeyVersion)];
    if(versionSerialize){
        [encoded appendData:versionSerialize];
    }else{
        return;
    }
    NSData *dataSerialize = [dataTLV serialize];
    if(dataSerialize){
        [encoded appendData:dataSerialize];
    }else{
        return;
    }
    [self.file write:encoded];
}
@end

#endif
