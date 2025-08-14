//
//  FTSessionReplayConfig.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/7/4.
//  Copyright © 2024 TRUEWATCH. All rights reserved.
//

#import "FTSessionReplayConfig.h"
#import "FTSessionReplayConfig+Private.h"
#import "FTConstants.h"
#import "FTLog+Private.h"
NSString * const FTTextAndInputPrivacyLevelStringMap[] = {
    [FTTextAndInputPrivacyLevelMaskAll] = @"MaskAll",
    [FTTextAndInputPrivacyLevelMaskAllInputs] = @"MaskAllInputs",
    [FTTextAndInputPrivacyLevelMaskSensitiveInputs] = @"MaskSensitiveInputs",
};
NSString * const FTTouchPrivacyLevelStringMap[] = {
    [FTTouchPrivacyLevelHide] = @"Hide",
    [FTTouchPrivacyLevelShow] = @"Show",
};
NSString * const FTImagePrivacyLevelStringMap[] = {
    [FTImagePrivacyLevelMaskAll] = @"MaskAll",
    [FTImagePrivacyLevelMaskNone] = @"MaskNone",
    [FTImagePrivacyLevelMaskNonBundledOnly] = @"MaskNonBundledOnly",
};
@interface FTSessionReplayConfig()
@property (nonatomic, assign) BOOL fineGrainedMaskingSet;
@end
@implementation FTSessionReplayConfig
-(instancetype)init{
    self = [super init];
    if(self){
        _sampleRate = 100;
        _sessionReplayOnErrorSampleRate = 0;
        _imagePrivacy = FTImagePrivacyLevelMaskAll;
        _touchPrivacy = FTTouchPrivacyLevelHide;
        _textAndInputPrivacy = FTTextAndInputPrivacyLevelMaskAll;
        _privacy = FTSRPrivacyMask;
    }
    return self;
}
-(void)setAdditionalNodeRecorders:(NSArray<id<FTSRWireframesRecorder>> *)additionalNodeRecorders{
    _additionalNodeRecorders = additionalNodeRecorders;
}
-(void)setPrivacy:(FTSRPrivacy)privacy{
    _privacy = privacy;
    if(_fineGrainedMaskingSet == YES){
        return;
    }
    switch (privacy) {
        case FTSRPrivacyMask:
            _imagePrivacy = FTImagePrivacyLevelMaskAll;
            _touchPrivacy = FTTouchPrivacyLevelHide;
            _textAndInputPrivacy = FTTextAndInputPrivacyLevelMaskAll;
            break;
     
        case FTSRPrivacyAllow:
            _imagePrivacy = FTImagePrivacyLevelMaskNone;
            _touchPrivacy = FTTouchPrivacyLevelShow;
            _textAndInputPrivacy = FTTextAndInputPrivacyLevelMaskSensitiveInputs;
            break;
        case FTSRPrivacyMaskUserInput:
            _imagePrivacy = FTImagePrivacyLevelMaskNonBundledOnly;
            _touchPrivacy = FTTouchPrivacyLevelHide;
            _textAndInputPrivacy = FTTextAndInputPrivacyLevelMaskAllInputs;
            break;
    }
}
-(void)setTouchPrivacy:(FTTouchPrivacyLevel)touchPrivacy{
    _fineGrainedMaskingSet = YES;
    _touchPrivacy = touchPrivacy;
}
-(void)setTextAndInputPrivacy:(FTTextAndInputPrivacyLevel)textAndInputPrivacy{
    _fineGrainedMaskingSet = YES;
    _textAndInputPrivacy = textAndInputPrivacy;
}
-(void)setImagePrivacy:(FTImagePrivacyLevel)imagePrivacy{
    _fineGrainedMaskingSet = YES;
    _imagePrivacy = imagePrivacy;
}
- (id)copyWithZone:(nullable NSZone *)zone {
    FTSessionReplayConfig *config = [[[self class] allocWithZone:zone] init];
    config.sampleRate = self.sampleRate;
    config.sessionReplayOnErrorSampleRate = self.sessionReplayOnErrorSampleRate;
    config.touchPrivacy = self.touchPrivacy;
    config.imagePrivacy = self.imagePrivacy;
    config.textAndInputPrivacy = self.textAndInputPrivacy;
    config.additionalNodeRecorders = [self.additionalNodeRecorders copy];
    return config;
}
-(NSString *)debugDescription{
    return [NSString stringWithFormat:@"====== Config ======\n sampleRate:%d\n sessionReplayOnErrorSampleRate:%d\n textAndInputPrivacy:%@\n touchPrivacy:%@\n imagePrivacy:%@\n ================== ",self.sampleRate,self.sessionReplayOnErrorSampleRate,FTTextAndInputPrivacyLevelStringMap[self.textAndInputPrivacy],FTTouchPrivacyLevelStringMap[self.touchPrivacy],FTImagePrivacyLevelStringMap[self.imagePrivacy]];
}
#pragma mark remote
-(void)mergeWithRemoteConfigDict:(NSDictionary *)dict{
    @try {
        if (!dict || dict.count == 0) {
            return;
        }
        NSNumber *sampleRate = dict[FT_R_SR_SAMPLERATE];
        NSNumber *onErrorSampleRate = dict[FT_R_SR_ON_ERROR_SAMPLE_RATE];
        
        if (sampleRate != nil && [sampleRate isKindOfClass:NSNumber.class]) {
            self.sampleRate = [sampleRate doubleValue] * 100;
        }
        if (onErrorSampleRate != nil && [onErrorSampleRate isKindOfClass:NSNumber.class]) {
            self.sessionReplayOnErrorSampleRate = [onErrorSampleRate doubleValue] * 100;
        }
    } @catch (NSException *exception) {
        FTInnerLogError(@"exception: %@",exception);
    }
}
@end
