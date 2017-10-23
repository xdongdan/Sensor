//
//  SSHTTPManager.m
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import "SSHTTPManager.h"

@implementation SSHTTPManager

__strong static SSHTTPManager *sharedObject;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (NSURLSessionDataTask *)APIDataWithURL:(NSString *)url requestType:(NSString *)type data:(NSDictionary *)data success:(SSSuccessBlock)success failure:(SSFailureBlock)failure {
    return [self dataWithURL:appendURL(kApiHost, url) requestType:type data:data body:nil constructingBodyWithBlock:nil success:success failure:failure];
}

/**
 *  支持上传文件
 *
 *  @param url     请求的url
 *  @param type    请求类型
 *  @param data    数据
 *  @param block   appendPartWithFileURL:name:error
 *  @param success 成功的回调
 *  @param failure 失败的回调
 *
 *  @return 返回值为AFHTTPRequestOperation
 *
 *  @author 肖冬丹
 *  @version 1.0
 */
- (NSURLSessionDataTask *)dataWithURL:(NSString *)url requestType:(NSString *)type data:(NSDictionary *)data body:(NSData *)body constructingBodyWithBlock:(void (^)(id <AFMultipartFormData>fromData))block success:(SSSuccessBlock)success failure:(SSFailureBlock)failure {
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    
    if (body) {
        [requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSMutableURLRequest *request = nil;
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:url parameters:data constructingBodyWithBlock:block error:nil];
        
    } else {
        request = [requestSerializer requestWithMethod:type URLString:url parameters:data error:nil];
    }
    
    if (body) {
        [request setHTTPBody:body];
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData]; // 忽略本地缓存
    
    NSURLSessionDataTask *sessionTask =  [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            // TODO showError
            failure(sessionTask, error);
        } else {
            success(sessionTask, responseObject);
            NSString * codeString = responseObject[@"code"];
            int code =[codeString intValue];
//            if(code ==40005){
//                UINavigationController *navc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//                LoginViewController *loginVC = [[LoginViewController alloc] init];
//                [navc presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
//            }
        }
    }];
    [sessionTask resume];
    return sessionTask;
}

NSString * appendURL(NSString *host, NSString *url) {
    return [host stringByAppendingString:url];
}

@end
