//
//  SSHTTPManager.h
//  Sensor
//
//  Created by xiaodongdan on 2017/10/23.
//  Copyright © 2017年 xiaodongdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SSAPI.h"

static NSString *HTTPRequestTypeGet = @"GET";
static NSString *HTTPRequestTypePost = @"POST";

typedef void(^SSSuccessBlock)(NSURLSessionDataTask *operation, NSDictionary *responseDic);
typedef void(^SSFailureBlock)(NSURLSessionDataTask *operation, NSError *error);

@interface SSHTTPManager : NSObject

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)APIDataWithURL:(NSString *)url requestType:(NSString *)type data:(NSDictionary *)data success:(SSSuccessBlock)success failure:(SSFailureBlock)failure;

@end
