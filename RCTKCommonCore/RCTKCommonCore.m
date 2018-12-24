//
//  RCTKCommonCore.m
//  RCTKCommonCore
//
//  Created by NathanTu on 2018/12/20.
//  Copyright © 2018年 NathanTudc. All rights reserved.
//

#import "RCTKCommonCore.h"
#import "RCTKCommonHeader.h"
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#elif __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#endif
#import <LocalAuthentication/LocalAuthentication.h>
#define KCommonCode @"code"
#define KCommonMessage @"message"
#define KCommonSuccess @"success"
@interface RCTKCommonCore()<RCTBridgeModule>
@end
@implementation RCTKCommonCore
RCT_EXPORT_MODULE();
/**
 调用本地生物认证(指纹、人脸)
 
 @param NSString App 弹窗描述文字
 @return 回调 Array[{code,mesage}]
 */
RCT_EXPORT_METHOD(biologicalRecognition:(NSString *)title callback:(RCTResponseSenderBlock)callback){
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            NSString *localizedReason = title;
            if (!title) {
                if (@available(iOS 11.0, *)) {
                    if (context.biometryType == LABiometryTypeFaceID){
                        localizedReason = @"Face ID登录";
                    }else
                        localizedReason = @"指纹登录";
                }
            }
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    callback(@[@{KCommonCode:@(KFRSuccess),KCommonMessage:KCommonSuccess}]);
                    return;
                }
                callback(@[@{KCommonCode:@(error.code),KCommonMessage:error.description}]);
            }];
        }
        if (error) {
            callback(@[@{KCommonCode:@(error.code),KCommonMessage:error.description}]);
        }
        return;
    }
    callback(@[@{KCommonCode:@(KFRError),KCommonMessage:RCTKFingerprintRecognitionDescriptionError}]);
}

@end
