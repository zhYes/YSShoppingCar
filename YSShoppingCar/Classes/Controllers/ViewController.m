//
//  ViewController.m
//  YSShoppingCar
//
//  Created by FDC-iOS on 17/2/22.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "ViewController.h"
#import "MKShopCarController.h"
#import "MKOrderListModel.h"
#import "MJExtension.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *_nmArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBase];
    [self setData];
}



- (void)setBase {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
    [btn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(shopCarClick) forControlEvents:UIControlEventTouchUpInside];
}

// 1.获取数据
- (void)setData {
    NSString*pathStr = [[NSBundle mainBundle] pathForResource:@"YSDota" ofType:nil];
    NSData* data = [NSData dataWithContentsOfFile:pathStr];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //    NSLog(@"json%@",json);
    _nmArray = [NSMutableArray array];
    NSArray * array = json[@"orders_list"];
    for (NSDictionary* list in array) {
        
        MKOrderListModel* obj = [MKOrderListModel mj_objectWithKeyValues:list];
        [_nmArray addObject:obj];
    }
}
// 2.传递数据
- (void)shopCarClick {
    MKShopCarController * shop = [MKShopCarController new];
    shop.modelList = _nmArray;
    [self.navigationController pushViewController:shop animated:YES];
}




@end
