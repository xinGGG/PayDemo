//
//  ViewController.m
//  支付包demo
//
//  Created by xing on 15/7/26.
//  Copyright (c) 2015年 ljx. All rights reserved.
//

#import "ViewController.h"
#import "AlixLibService.h"
#import "AlixPayOrder.h"
#import "DataSigner.h"
#import "PartnerConfig.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buy];
}
- (void)buy {

    
    //首先导入 SystemConfiguration.framework 和 CFNetwork.framework
    
    // 1.生成订单信息
    // 订单信息 == order == [order description]
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.productName = @"商品名称";
    order.productDescription = @"商品详情";
    order.partner = PartnerID;              //宏定义里面设置申请账户的信息
    order.seller = SellerID;                //宏定义里面设置申请账户的信息
    //商品价格
    order.amount = @"1.00";
    
    // 2.签名加密
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    // 签名信息 == signedString
    NSString *signedString = [signer signString:[order description]];
    
    // 3.利用订单信息、签名信息、签名类型生成一个订单字符串
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             [order description], signedString, @"RSA"];
    
    // 4.打开客户端,进行支付(商品名称,商品价格,商户信息)
    [AlixLibService payOrder:orderString AndScheme:@"tuangou" seletor:@selector(getResult:) target:self];
    //AndScheme:查看回调客户端的信息。
    //需要手动添加 教程 http://git.devzeng.com/blog/ios-url-scheme.html
    //查看当前客户端的Scheme。在当前客户端的info.plist里面CFBundleURLSchemes
    
    // 5.通过AppDelegate.m 接受支付宝客户端的支付结果
}

///网页版回调
- (void)getResult:(NSString *)result
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
