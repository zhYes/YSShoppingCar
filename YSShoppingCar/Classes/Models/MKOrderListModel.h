//
//  MKOrderListModel.h
//  发大财
//
//  Created by FDC-iOS on 17/1/9.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class MKGoodsModel;


@interface MKOrderListModel : NSObject

@property(nonatomic,copy)NSString * order_id; // 订单id
@property(nonatomic,copy)NSString * oagree_id;//合同id
@property(nonatomic,copy)NSString * user_id;//用户id
@property(nonatomic,copy)NSString * rec_type;//交易类型(支付参数)

@property(nonatomic,copy)NSString * total_count;//订单商品总数
@property(nonatomic,copy)NSString * total_amount;//订单商品总价
@property(nonatomic,copy)NSString * vend_id;//订单类型(页面显示0是自营)

@property(nonatomic,strong)NSArray * goods;//订单商品信息
@property(nonatomic,assign)BOOL groupSelected; // 组选中


@end
