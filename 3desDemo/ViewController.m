//
//  ViewController.m
//  3desDemo
//
//  Created by 德益富 on 15/10/15.
//  Copyright © 2015年 Dyf. All rights reserved.
//  亲们，欢迎star或者关注我的微博:smomn

#import "ViewController.h"
#import "NSString+hash.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)encodeData:(id)sender {
    NSString *encodeStr=[NSString encrypt3DES:@"1122334455667788" withKey:@"AABBCCDDEEFFGG"];
    NSLog(@"encodeStr->%@",encodeStr);
    //92CAB09AB1C3EFE1
}

- (IBAction)decodeData:(id)sender {
    NSString *decodeStr=[NSString decrypt3DES:@"92CAB09AB1C3EFE1" withKey:@"AABBCCDDEEFFGG"];
    NSLog(@"decodeStr->%@",decodeStr);
    //1122334455667788
}

@end
