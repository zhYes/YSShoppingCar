//
//  MKHeaderFooterView.h
//  发大财
//
//  Created by FDC-iOS on 17/2/21.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol headerViewDelegate <NSObject>

- (void)headerSelectedBtnClick: (NSInteger)section;

@end

@interface MKHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong)UIButton *headerBtn;
@property (nonatomic,strong)UILabel *sectionLabel;

@property(nonatomic,weak)id <headerViewDelegate>headerDelegate;

@end


