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
//  FTUIImageResource.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/14.
//

#import "FTUIImageResource.h"
#import "UIImage+FTSRIdentifier.h"
#import "UIColor+FTSRIdentifier.h"
@interface FTUIImageResource(){
    CGColorRef _tintCGColor;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *tintColorIdentifier;

@end
@implementation FTUIImageResource
@synthesize mimeType;

-(instancetype)initWithImage:(UIImage *)image tintColor:(UIColor *)tintColor{
    return [self initWithImage:image tintColor:tintColor traitCollection:nil];
}
-(instancetype)initWithImage:(UIImage *)image tintColor:(nullable UIColor *)tintColor traitCollection:(nullable UITraitCollection *)traitCollection{
    self = [super init];
    if(self){
        _image = image;
        UIColor *resolvedTintColor = [tintColor ftsr_resolvedColorWithTraitCollection:traitCollection];
        if (resolvedTintColor.CGColor) {
            _tintCGColor = CGColorRetain(resolvedTintColor.CGColor);
            _tintColorIdentifier = resolvedTintColor.srIdentifier;
        }
    }
    return self;
}
- (void)dealloc{
    if (_tintCGColor) {
        CGColorRelease(_tintCGColor);
    }
}
-(NSString *)mimeType{
    return @"image/png";
}
-(NSData *)calculateData{
    UIColor *tintColor = _tintCGColor ? [UIColor colorWithCGColor:_tintCGColor] : nil;
    if (@available(iOS 13.0, *)) {
        if(self.image.isSymbolImage && tintColor){
            return [[self.image imageWithTintColor:tintColor] ft_pngDataWithTintColor:nil];
        }
    }
    return [self.image ft_pngDataWithTintColor:tintColor];
}
-(NSString *)calculateIdentifier{
    NSString *identifier = [self.image srIdentifier];
    if(self.tintColorIdentifier.length>0){
        identifier = [identifier stringByAppendingString:self.tintColorIdentifier];
    }
    return identifier;
}

@end

#endif
