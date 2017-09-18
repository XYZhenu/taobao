//
//  XYZHttp.h
//  qunyao
//
//  Created by xieyan on 16/4/12.
//  Copyright © 2016年 xieyan. All rights reserved.
//
#define XYZNet [XYZHttp instance]
static NSString* _Nonnull Text_Netfailed = @"网络异常，请稍候再试";

@interface XYZHttp : XYNetwork
+(_Nonnull instancetype)instance;
/**POST网络请求--上传下载*/
-(NSURLSessionDataTask* _Nullable)POSTUrl:( NSString* _Nonnull)url
        Parma:(NSDictionary* _Nullable)parma BodyParma:(id _Nullable)bodyParma HeaderParma:(NSDictionary* _Nullable)headerParma
uploadProgress:(nullable void (^)(NSProgress *_Nullable uploadProgress)) uploadProgressBlock
downloadProgress:(nullable void (^)(NSProgress *_Nullable downloadProgress)) downloadProgressBlock
      success:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, id _Nonnull responseObject, NSInteger code, NSString* _Nullable info))success
      failure:(void (^ _Nullable)(NSURLSessionDataTask *_Nullable task, NSError * _Nullable error))failure
    hudInView:(UIView* _Nullable)view;

+(NSMutableDictionary* _Nonnull)defaultHeader;
+(NSString* _Nonnull)timestamp;

@end
