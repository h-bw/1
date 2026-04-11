package com.huacai.snack.domain.vo;

import lombok.Data;

/**
 * 分类名称列表VO
 * 用于前端下拉选择零食分类
 */
@Data
public class CategoryNameVO {
    //分类ID
    private String categoryId;
    //分类名称
    private String categoryName;
}
