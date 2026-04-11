package com.huacai.snack.domain;

import java.math.BigDecimal;
import com.huacai.system.general.annotation.Excel;
import com.huacai.system.general.core.domain.BaseEntity;
import lombok.*;

/**
 * 商品对象 product
 *
 * @author huacai
 * @date 2025-10-12
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 商品ID */
    private String productId;

    /** 分类ID */
    @Excel(name = "分类ID")
    private String categoryId;

    /** 商品名称 */
    @Excel(name = "商品名称")
    private String name;

    /** 描述 */
    @Excel(name = "描述")
    private String description;

    /** 价格 */
    @Excel(name = "价格")
    private BigDecimal price;

    /** 图片 */
    @Excel(name = "图片")
    private String image;

    //分类名称
    private String categoryName;

}
