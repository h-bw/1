package com.huacai.snack.service;

import java.util.List;
import com.huacai.snack.domain.Category;
import com.huacai.snack.domain.vo.CategoryNameVO;
import com.huacai.snack.domain.vo.PieVO;

/**
 * 零食分类Service接口
 *
 * @author huacai
 * @date 2025-10-12
 */
public interface ICategoryService
{
    /**
     * 查询零食分类
     *
     * @param categoryId 零食分类主键
     * @return 零食分类
     */
    public Category selectCategoryByCategoryId(String categoryId);

    /**
     * 查询零食分类列表
     *
     * @param category 零食分类
     * @return 零食分类集合
     */
    public List<Category> selectCategoryList(Category category);

    /**
     * 新增零食分类
     *
     * @param category 零食分类
     * @return 结果
     */
    public int insertCategory(Category category);

    /**
     * 批量新增零食分类
     *
     * @param categorys 零食分类List
     * @return 结果
     */
    public int batchInsertCategory(List<Category> categorys);

    /**
     * 修改零食分类
     *
     * @param category 零食分类
     * @return 结果
     */
    public int updateCategory(Category category);

    /**
     * 批量删除零食分类
     *
     * @param categoryIds 需要删除的零食分类主键集合
     * @return 结果
     */
    public int deleteCategoryByCategoryIds(String[] categoryIds);

    /**
     * 删除零食分类信息
     *
     * @param categoryId 零食分类主键
     * @return 结果
     */
    public int deleteCategoryByCategoryId(String categoryId);

    /**
     * 不分页查询分类名称列表
     * @return
     */
    List<CategoryNameVO> selectAllCategoryNameList();

    /**
     * 查询每种分类各有多少商品
     */
    List<PieVO> selectProductCountByCategory();

}
