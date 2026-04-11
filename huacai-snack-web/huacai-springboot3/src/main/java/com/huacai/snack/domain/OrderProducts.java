package com.huacai.snack.domain;

import java.math.BigDecimal;
import com.huacai.system.general.annotation.Excel;
import com.huacai.system.general.core.domain.BaseEntity;
import lombok.*;
/**
 * 订单商品明细对象 order_products
 *
 * @author huacai
 * @date 2025-10-16
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderProducts extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 订单商品明细ID */
    private Long opId;

    /** 订单号 */
    @Excel(name = "订单号")
    private String orderId;

    /** 图片 */
    @Excel(name = "图片")
    private String image;

    /** 商品名称 */
    @Excel(name = "商品名称")
    private String name;

    /** 价格 */
    @Excel(name = "价格")
    private BigDecimal price;

    /** 数量 */
    @Excel(name = "数量")
    private Long quantity;


}
