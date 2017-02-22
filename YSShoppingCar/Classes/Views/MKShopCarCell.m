//
//  MKShopCarCell.m
//  发大财
//
//  Created by FDC-iOS on 17/2/18.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKShopCarCell.h"
#import "MKGoodsModel.h"
#import "UIImageView+WebCache.h"

@implementation MKShopCarCell {
    
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet UILabel *fabricNameLabel;//面料编号: KIUHDO
    __weak IBOutlet UILabel *fabricNumLabel;//面料序号: 4
    __weak IBOutlet UILabel *fabricPriceLabel;//¥9.00
    __weak IBOutlet UILabel *fabricX1;// x 1.5
    __weak IBOutlet UIButton *fabricSelectedBtn;//布料选中状态按钮
}

- (IBAction)fabricSelectClick:(UIButton*)sender {
    _goodsModel.isSelected = !_goodsModel.isSelected;
    fabricSelectedBtn.selected = !fabricSelectedBtn.selected;
//    NSLog(@"%zd",self.tag);
    if ([self.shopDelegate respondsToSelector:@selector(shopCellSelectedClick:)]) {
        [self.shopDelegate shopCellSelectedClick:self.tag];
    }
}




- (void)setGoodsModel:(MKGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    fabricSelectedBtn.selected = _goodsModel.isSelected;
    NSString * baseurlStr = @"http://www.fdcfabric.com/"; // 图片地址的前缀
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",baseurlStr,goodsModel.goods_thumb];
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"wait"]];  // 设置图片
    
    fabricNameLabel.text = [NSString stringWithFormat:@"面料编号: %@",goodsModel.goods_name]; // 设置商品名称
    fabricNumLabel.text = [NSString stringWithFormat:@"面料序号: %@",goodsModel.choose_num];
    fabricPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.shop_price];// 设置商品价格
    fabricX1.text = [NSString stringWithFormat:@"x %.2f",goodsModel.goods_number]; // 这款商品的数量
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end




