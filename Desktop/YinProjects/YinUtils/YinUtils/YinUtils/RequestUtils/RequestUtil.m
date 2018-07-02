//
//  RequestUtil.m
//  音
//
//  Created by 胡志辉 on 2018/5/22.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

#import "RequestUtil.h"
#import <AFNetworking.h>

#define outTime 20

@implementation RequestUtil

static RequestUtil *requestUtil = nil;

+(RequestUtil *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestUtil == nil) {
            requestUtil = [[RequestUtil alloc] init];
        }
    });
    return requestUtil;
}

- (void)getWithUrlString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    //创建网络请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil ,nil];
    //发送网络请求(请求方式为GET)
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableLeaves) error:nil];
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)postWithUrlString:(NSString *)urlString parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = outTime;
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            successBlock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
            NSLog(@"网络异常 - T_T%@", error);
        }
    }];
    
}

-(void)uploadWithUrlString:(NSString *)urlString parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)downloadWithUrlString:(NSString *)urlString paramters:(id)paramters progress:(ProgressBlock)progress success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    [downLoadTask resume];
}









@end
