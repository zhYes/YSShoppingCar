//
//  MKHeaderFooterView.m
//  发大财
//
//  Created by FDC-iOS on 17/2/21.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "MKHeaderFooterView.h"

@implementation MKHeaderFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGRect btnFrame = CGRectMake(20, 12, 20, 20);
        _headerBtn = [[UIButton alloc] initWithFrame:btnFrame];
        [_headerBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateNormal];
        [_headerBtn setImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
        [_headerBtn addTarget:self action:@selector(headerBtnClick::) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_headerBtn];
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.frame = CGRectMake(35, 12, 0, 0);
        [self addSubview:_sectionLabel];
        NSArray * salerName = @[@"韩国面料",@"日本面料",@"朝鲜面料",@"法国面料"];
        _sectionLabel.text = [NSString stringWithFormat:@"    %@",salerName[arc4random()%4]];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
        [_sectionLabel sizeToFit];
    }
    return self;
}

// 组头的点击事件
- (void)headerBtnClick: (UIButton*)HeaderBtn :(NSInteger)section{
    HeaderBtn.selected = !HeaderBtn.selected;
    if ([self.headerDelegate respondsToSelector:@selector(headerSelectedBtnClick:)]) {
        [self.headerDelegate headerSelectedBtnClick:self.tag];
    }
}


@end
