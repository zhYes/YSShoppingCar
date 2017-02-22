//
//  MKShopCarController.m
//  发大财
//
//  Created by FDC-iOS on 17/2/18.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKShopCarController.h"
#import "MKHeaderFooterView.h"
#import "MKShopCarCell.h"
#import "MKOrderListModel.h"
#import "MKGoodsModel.h"




@interface MKShopCarController () <UITableViewDelegate,UITableViewDataSource,shopCarCellDelegate,headerViewDelegate>

@property (nonatomic,strong)NSMutableDictionary *dic;

@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation MKShopCarController {
    float _totalNum;  // 合计价格
    MKHeaderFooterView *_headerView; // 组头view
    UITableView * _tableView;
    UILabel *_hejiLabel;
    
}


/// 懒加载indexpath字典
- (NSMutableDictionary *)dic {
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBase];
    [self setTableList];
    [self setAllpayView];
}

// 设置表格
- (void)setTableList {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UINib * nib = [UINib nibWithNibName:@"MKShopCarCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"shop"];
    _tableView.rowHeight = 110;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
}

// 基础设置
- (void)setBase {
    
    self.title = @"购物车";
    
}

// 要支付的总价
- (void)setAllpayView {
    CGRect  viewFrame = CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49);
    UIView * allPayView = [[UIView alloc] initWithFrame:viewFrame];
    allPayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:allPayView];
    CGRect hejiFrame0 = CGRectMake(38, 17, 0, 0);
    UILabel * hejiLabel0 = [[UILabel alloc] initWithFrame:hejiFrame0];
    hejiLabel0.text = @"合计: ";
    [hejiLabel0 sizeToFit];
    [allPayView addSubview:hejiLabel0];
    CGRect hejiFrame = CGRectMake(85, 17, 200, 20);
    _hejiLabel = [[UILabel alloc] initWithFrame:hejiFrame];
    _hejiLabel.textColor = [UIColor redColor];
    _hejiLabel.text = @"¥0.00";
//    [_hejiLabel sizeToFit];
    [allPayView addSubview:_hejiLabel];
    
    CGRect btnFrame = CGRectMake(kScreenWidth - 120, 0, 120, 49);
    UIButton * payBtn = [[UIButton alloc] initWithFrame:btnFrame];
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    [payBtn setBackgroundColor:[UIColor redColor]];
    [allPayView addSubview:payBtn];
}

//左拉抽屉(删除和修改按钮)
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        MKOrderListModel*listModel = _modelList[indexPath.section];
        
        NSMutableArray*goodsModel = (NSMutableArray*)listModel.goods;
        
        /// 如果删除的是带勾选的则计算一次数值
        MKGoodsModel*goodModel = (MKGoodsModel*)goodsModel[indexPath.row];
        if (goodModel.isSelected) {
            float shop_price = goodModel.shop_price;               //价格
            float goods_number = goodModel.goods_number;   // 数量
            _totalNum -= shop_price * goods_number;
            _hejiLabel.text = [NSString stringWithFormat:@"%.2f",_totalNum];
        }
        
        [goodsModel  removeObjectAtIndex:indexPath.row];    // 删除操作放到最后
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (goodsModel.count == 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:_modelList];
//            [temp arraywitharray:_modelList];
//            temp = _modelList;
            [temp removeObjectAtIndex:indexPath.section];
            _modelList = temp;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [tableView reloadData];
        });
    }];
    
    // 修改资料按钮
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
    }];
    
    editRowAction.backgroundColor = [UIColor blueColor];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, editRowAction];
}

// 组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

// header | 组名
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    _headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MKShopCarHeader"];
    
    if (_headerView == nil) {
        
        _headerView = [[MKHeaderFooterView alloc] init];
        _headerView.headerDelegate = self;
    }
    
    MKOrderListModel*listModel = _modelList[section];
    
    _headerView.tag = section;
    _headerView.headerBtn.selected = listModel.groupSelected;
    
    return _headerView;
}


#pragma mark - 代理方法组头header的选中状态
- (void)headerSelectedBtnClick:(NSInteger)section {
    //    NSLog(@"%zd",section);
    MKOrderListModel*listModel = _modelList[section];
    listModel.groupSelected = !listModel.groupSelected;
    
    // 判断如果点击 | header选中
    if (listModel.groupSelected) {
        
        for (MKGoodsModel* goodsModel in listModel.goods) {
            
            if (!goodsModel.isSelected) {                                       //下面不是选中状态的cell 将价格加入到总价当中
                float shop_price = goodsModel.shop_price;               //价格
                float goods_number = goodsModel.goods_number;   // 数量
                _totalNum += shop_price * goods_number;
                goodsModel.isSelected = YES;
            }
            
        }
    } else {  // 取消header选中 所有都取消
        for (MKGoodsModel* goodsModel in listModel.goods) {
            goodsModel.isSelected = NO;
            float shop_price = goodsModel.shop_price;               //价格
            float goods_number = goodsModel.goods_number;   // 数量
            _totalNum -= shop_price * goods_number;
        }
    }
//    NSLog(@"总价格为: %.2f",_totalNum);
    _hejiLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalNum - 1 + 1];
    [_tableView reloadData];
}

// 数据源 | 几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _modelList.count;
}

// 数据源 | 每组几个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MKOrderListModel * tempModle = (MKOrderListModel*)_modelList[section];
    return tempModle.goods.count;
}

// cell显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     MKShopCarCell*shopCell = [tableView dequeueReusableCellWithIdentifier:@"shop"];
    shopCell.shopDelegate = self;
    //去出对应组的对应商品信息
    shopCell.goodsModel = ((MKOrderListModel*)_modelList[indexPath.section]).goods[indexPath.row];
    
    // 给cell做标记
    shopCell.tag = (long)indexPath.section *100 + (long)indexPath.row;
//    if (_modelList.count != self.dic.count) {
    
        NSString * cellTag = [NSString stringWithFormat:@"%zd",shopCell.tag];
        NSDictionary* _tempDic = @{
                     cellTag:indexPath
                     };
        [self.dic addEntriesFromDictionary:_tempDic];
//    }


    return shopCell;
}

#pragma mark - cell上的代理方法获 | 取的价格
- (void)shopCellSelectedClick:(NSInteger)shopCellTag {
    
    //判断组的是否选中状态是否修改
    NSString * cellTagStr = [NSString stringWithFormat:@"%zd",shopCellTag];
    NSIndexPath *indexPath = self.dic[cellTagStr];
    MKOrderListModel * listModel = (MKOrderListModel*)_modelList[indexPath.section];
    
    //0.便利当前组cell上选中按钮的个数
    NSInteger seletedNum =0;
    for (MKGoodsModel* goodsModel in listModel.goods) {
        if (goodsModel.isSelected) {
            seletedNum += 1;
        }
        
        // 1.当前组的cell的个数 是否等于 勾选的总数
        if (((MKOrderListModel*)_modelList[indexPath.section]).goods.count == seletedNum) {
            listModel.groupSelected = YES;
        } else {
            listModel.groupSelected = NO;
        }
        [_tableView reloadData];
    }
    
    MKGoodsModel *goodsModel = ((MKOrderListModel*)_modelList[indexPath.section]).goods[indexPath.row];
    float shop_price = goodsModel.shop_price;
    float goods_number = goodsModel.goods_number;
    if (!goodsModel.isSelected) {
        _totalNum = _totalNum - shop_price*goods_number;
    }else {
        
        _totalNum = _totalNum + shop_price*goods_number;
    }
    _hejiLabel.text = [NSString stringWithFormat:@"¥%.2f",_totalNum -1 + 1];
}

@end


