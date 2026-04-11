package com.huacai.snack.domain.vo;

import lombok.Data;

/**
 * 后台统计数据VO
 */
@Data
public class CountInfoVO {
    //商品总数
    private Integer productCount;
    //订单总数
    private Integer orderCount;
    //分类总数
    private Integer categoryCount;
}
