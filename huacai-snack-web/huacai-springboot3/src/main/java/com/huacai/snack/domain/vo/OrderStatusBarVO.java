package com.huacai.snack.domain.vo;

import lombok.Data;

/**
 * 订单状态统计柱状图VO
 */
@Data
public class OrderStatusBarVO {
    private String orderStatus;
    private Integer orderCount;
}
