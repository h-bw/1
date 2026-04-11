package com.huacai.snack.domain;

import java.math.BigDecimal;
import java.util.List;
import com.huacai.system.general.annotation.Excel;
import com.huacai.system.general.core.domain.BaseEntity;
import lombok.*;

/**
 * 订单对象 order
 *
 * @author huacai
 * @date 2025-10-16
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 订单号 */
    private String orderId;

    /** 收货人 */
    @Excel(name = "收货人")
    private String name;

    /** 手机号码 */
    @Excel(name = "手机号码")
    private String phone;

    /** 收货地址 */
    @Excel(name = "收货地址")
    private String address;

    /** 合计价格 */
    @Excel(name = "合计价格")
    private BigDecimal totalAmount;

    /** 商品件数 */
    @Excel(name = "商品件数")
    private Long productCount;

    /** 订单状态 */
    @Excel(name = "订单状态")
    private String status;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 订单商品明细信息 */
    private List<OrderProducts> orderProductsList;

    //下单用户名
    private String userName;


}
