//
//  SSL_SecIdentity.m
//  httpsDemo1
//
//  Created by Uzai on 15/11/18.
//  Copyright © 2015年 uzai. All rights reserved.
//

#import "SSL_SecIdentity.h"

@implementation SSL_SecIdentity
+(SecIdentityRef)secIdentity{
    static SecIdentityRef identity = NULL;
    if (identity == nil) {
        SecTrustRef trust = NULL;
        //绑定证书，证书放在Resources文件夹中
        NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"uzai.com" ofType:@"p12"]];//证书文件名和文件类型
        [[self class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data];
        CFRelease(trust);
    }
    return identity;
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("123"); //证书密码
    const void *keys[] =  { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys,values, 1,NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    //securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    CFDataRef dataref = (__bridge CFDataRef)inPKCS12Data;
    securityError = SecPKCS12Import(dataref,optionsDictionary,&items);
    CFRelease(optionsDictionary);
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
        
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

@end
