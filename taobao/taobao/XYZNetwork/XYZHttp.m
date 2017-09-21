//
//  XYZHttp.m
//  qunyao
//
//  Created by xieyan on 16/4/12.
//  Copyright © 2016年 xieyan. All rights reserved.
//  

#import "XYZHttp.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface XYZHttp ()
@end
@implementation XYZHttp
-(void)initSetting{
    [self setAcceptableContentTypes:[NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/javascript",@"multipart/form-data",nil] for:XYSerializerType_Json];
    [self setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",nil] for:XYSerializerType_Xml];
}
+(NSDictionary*)getCachedDic:(NSString*)cacheName{
    NSDictionary* dic = nil;
    if (cacheName) {
        NSString* cachepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@.json",cacheName]];
        dic = [NSDictionary dictionaryWithContentsOfFile:cachepath];
    }
    return dic;
}
+(void)setCachedDic:(NSDictionary*)dic name:(NSString*)cacheName{
    if (!dic || !cacheName) {
        return;
    }
    NSString* cachepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@.json",cacheName]];
    [dic writeToFile:cachepath atomically:YES];
}
+(NSMutableDictionary *)defaultHeader{
    NSMutableDictionary* dic = @{}.mutableCopy;
//    [dic setValue:kUserInfo.accessToken forKey:@"accessToken"];
//    [dic setValue:kUserInfo.deviceId forKey:@"deviceId"];
//    [dic setValue:kUserInfo.deviceName forKey:@"deviceName"];
//    [dic setValue:kUserInfo.deviceType forKey:@"deviceType"];
//    [dic setValue:[UIApplication sharedApplication].appVersion forKey:@"appVersion"];
    return dic;
}
+(NSString *)timestamp{
    NSDateFormatter * formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyyMMddHHmmss";
    return [formate stringFromDate:[NSDate date]];
}

- (NSMutableURLRequest*)getPOSTRequestUrl:( NSString* _Nonnull)url
                                    Parma:(NSDictionary* _Nullable)parma
                                BodyParma:(id _Nullable)bodyParma
                              HeaderParma:(NSDictionary* _Nullable)headerParma
                                    errot:(NSError**)error
{
    
    NSMutableURLRequest *request =nil;
    
    if ([bodyParma isKindOfClass:[UIImage class]]) {
        
        
        request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data = UIImageJPEGRepresentation(bodyParma, 1);
            CGFloat multiple =5*1024*1024/data.length;
            multiple = multiple>1 ? 1: multiple*multiple;
            data = UIImageJPEGRepresentation(bodyParma, multiple);
            [formData appendPartWithFileData:data name:@"image" fileName:headerParma[@"fileName"] mimeType:@"image/png"];
        } error:error];
        
    }else{
        request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:url relativeToURL:self.baseURL] absoluteString] parameters:parma error:error];
    }
    
    
    
    if ([bodyParma isKindOfClass:[NSDictionary class]] && [bodyParma count]>0) {
//        DDLogDebug(@"%@ \n%@",url,bodyParma);
        NSString* bodyJson = [bodyParma JSONString];
        request.HTTPBody = [bodyJson dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([bodyParma isKindOfClass:[NSData class]]){
        request.HTTPBody = bodyParma;
    }
    
    NSMutableDictionary* defaultHeader = [XYZHttp defaultHeader];
    [defaultHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [request setValue:obj forHTTPHeaderField:key];
    }];

    if ([bodyParma isKindOfClass:[UIImage class]]){
       
    }else{
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }
    if (headerParma) {
        [headerParma enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request setValue:obj forHTTPHeaderField:key];
        }];
    }

    return request;
}
/**POST网络请求--上传下载*/
-(NSURLSessionDataTask* _Nullable)POSTUrl:( NSString* _Nonnull)url
            Parma:(NSDictionary* _Nullable)parma
        BodyParma:(id _Nullable)bodyParma
      HeaderParma:(NSDictionary* _Nullable)headerParma
   uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
 downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
          success:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, id _Nonnull responseObject, NSInteger code, NSString* _Nullable info))success
          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
        hudInView:(UIView*)view
            cache:(NSString*)cacheName{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self getPOSTRequestUrl:url Parma:parma BodyParma:bodyParma HeaderParma:headerParma errot:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgressBlock
                        downloadProgress:downloadProgressBlock
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (view) {
                               [MBProgressHUD hideAllHUDsForView:view animated:YES];
                           }
                       }];
    [dataTask resume];
    return dataTask;
}
@end
