//
//  main.m
//  WebSocketClient
//
//  Created by tongmuxu on 2018/5/15.
//  Copyright © 2018年 tongmuxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "NAChloride.h"
#import "Wallet.h"
#import "Seed.h"

#import "KeyStoreFile.h"
#import "KeyStore.h"

#import "ZXingObjC.h"

int main(int argc, char * argv[])
{
    //创建钱包和密钥
    NSString *secret = @"shExMjiMqza4DdMaSg3ra9vxWPZsQ";
    Seed * seed = [Seed alloc];
    Keypairs *keypairs = [seed deriveKeyPair:secret];
    Wallet *wallet = [[Wallet alloc]initWithKeypairs:keypairs private:secret];
    
    //创建KeyStoreFile
    KeyStoreFileModel *keyStoreFile = [KeyStore createLight:@"Key123456" wallet:wallet];
    
    //转换为Json
    NSLog(@"json:%@",[keyStoreFile toJSONString]);
    
    //从KeyStoreFile创建Wallet
    Wallet *decryptEthECKeyPair = [KeyStore decrypt:@"Key123456" wallerFile:keyStoreFile];
    
    //从Wallet中解析地址
    Keypairs *temp = [decryptEthECKeyPair keypairs] ;
    NSData *bytes = [[temp pub] BTCHash160];
    BTCAddress *btcAddress = [BTCPublicKeyAddress addressWithData:bytes];
    NSString *address = btcAddress.base58String;
    
    NSLog(@"address: %@", address);
    NSLog(@"PrivateKey:%@",[decryptEthECKeyPair secret]);

    //QRcode测试，使用ZXingObjc模块
    //编码部分 NSString 到 CGImageRef
    NSString* qrcodedata = [keyStoreFile toJSONString];
    CGImageRef image;
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* QRCodeResult = [writer encode:qrcodedata
                                  format:kBarcodeFormatQRCode
                                   width:800
                                  height:800
                                   error:&error];
    if (QRCodeResult)
    {
        image = CGImageRetain([[ZXImage imageWithMatrix:QRCodeResult] cgimage]);
        //This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    }
    else
    {
        NSString *errorMessage = [error localizedDescription];
        NSLog(@"QRCode生成失败，错误码%@",errorMessage);
    }
    
    //解码部分 CGImageRef 到 NSString
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:image];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    //输出结果
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *StringResult = [reader decode:bitmap
                                hints:hints
                                error:&error];
    NSLog(@"QRCode = %d，%@",StringResult.barcodeFormat,StringResult.text);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
