package com.huacai.snack.domain;

import com.huacai.system.general.annotation.Excel;
import com.huacai.system.general.core.domain.BaseEntity;
import lombok.*;

/**
 * 零食分类对象 category
 *
 * @author huacai
 * @date 2025-10-12
 */
@EqualsAndHashCode(callSuper = true)
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Category extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 零食分类ID */
    private String categoryId;

    /** 分类名称 */
    @Excel(name = "分类名称")
    private String name;

    /** 分类图片 */
    @Excel(name = "分类图片")
    private String image;

    /** 描述 */
    @Excel(name = "描述")
    private String description;


}
