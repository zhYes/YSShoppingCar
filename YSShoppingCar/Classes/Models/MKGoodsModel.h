//
//  MKGoodsModel.h
//  发大财
//
//  Created by FDC-iOS on 17/1/9.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKGoodsModel : NSObject
@property(nonatomic,copy)NSString * goods_thumb; //商品图片
@property(nonatomic,copy)NSString * goods_id;//商品id
@property(nonatomic,assign)float  shop_price;//商品单价(订单中心)
@property(nonatomic,assign)float  goods_price;//商品单价(订单详情)
@property(nonatomic,assign)float  goods_number;//商品数量
@property(nonatomic,copy)NSString * goods_amount;//商品总价(订单中心)
@property(nonatomic,assign)float subtotal;//商品总价(订单详情)
@property(nonatomic,copy)NSString * goods_name;//商品名称
@property(nonatomic,copy)NSString * vend_name;//厂商名称
@property(nonatomic,copy)NSString * vend_id;//订单类型
@property(nonatomic,copy)NSString * choose_num;//面料编号

@property(nonatomic,assign)BOOL isSelected;
@end
