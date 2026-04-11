package com.huacai.snack.domain;

import com.huacai.system.general.annotation.Excel;
import com.huacai.system.general.core.domain.BaseEntity;
import lombok.*;

/**
 * 购物车对象 cart
 *
 * @author huacai
 * @date 2025-10-13
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Cart extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 购物车ID */
    private String cartId;

    /** 商品ID */
    @Excel(name = "商品ID")
    private String productId;

    /** 数量 */
    @Excel(name = "数量")
    private Long quantity;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 商品名称 */
    private String name;

    /** 描述 */
    private String description;

    /** 价格 */
    private String price;

    /** 图片 */
    private String image;

    /** 下单用户名 */
    private String userName;


}
