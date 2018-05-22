//
//  RequestUtil.h
//  音
//
//  Created by 胡志辉 on 2018/5/22.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary *data);
typedef void(^FailureBlock)(NSError *error);
typedef void(^ProgressBlock)(NSProgress *progress);

@interface UploadParam : NSObject
/*图片二进制数据*/
@property (nonatomic,strong) NSData *data;
/*服务器对应的参数名称*/
@property (nonatomic , copy) NSString *name;
/*文件名称*/
@property (nonatomic , copy) NSString *fileName;
/*文件mime类型*/
@property (nonatomic , copy) NSString *mimeType;

@end


@interface RequestUtil : NSObject

/**
 *func 单例
 */
+(RequestUtil *)shared;

/**
 *func get请求方法
 *
 *  @param urlString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param successBlock    请求成功的回调
 *  @param failureBlick    请求失败的回调
 */
-(void)getWithUrlString:(NSString *)urlString
             parameters:(id)parameters
                success:(SuccessBlock)successBlock
                  failure:(FailureBlock)failureBlick;


/**
 *func post请求方法
 *
 *  @param urlString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param successBlock    请求成功的回调
 *  @param failureBlock    请求失败的回调
 */
-(void)postWithUrlString:(NSString *)urlString
              parameters:(id)parameters
                 success:(SuccessBlock)successBlock
                 failure:(FailureBlock)failureBlock;

/**
 *func 上传文件方法
 *
 *@param urlString 请求的网址字符串
 *@param parameters 请求参数
 *@param uploadParams 请求的文件参数
 *@param successBlock 成功回调
 *@param failureBlock 成功回调
 */
-(void)uploadWithUrlString:(NSString *)urlString
                parameters:(id)parameters
               uploadParam:(NSArray<UploadParam*>*)uploadParams
                   success:(SuccessBlock)successBlock
                   failure:(FailureBlock)failureBlock;
/**
 *func 下载方法
 *
 * @param urlString 请求的网址字符串
 * @param paramters 请求的参数
 * @param progress  进度条
 * @param successBlock 成功回调
 * @param failureBlock 失败回调
 */
-(void)downloadWithUrlString:(NSString *)urlString
                   paramters:(id)paramters
                    progress:(ProgressBlock)progress
                     success:(SuccessBlock)successBlock
                     failure:(FailureBlock)failureBlock;

@end
