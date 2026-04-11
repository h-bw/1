package com.huacai.snack.mapper;

import java.util.List;

import com.huacai.snack.domain.vo.CategoryNameVO;
import com.huacai.snack.domain.vo.PieVO;
import org.apache.ibatis.annotations.Mapper;
import com.huacai.snack.domain.Category;

/**
 * 零食分类Mapper接口
 *
 * @author huacai
 * @date 2025-10-12
 */
@Mapper
public interface CategoryMapper
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
     * 修改零食分类
     *
     * @param category 零食分类
     * @return 结果
     */
    public int updateCategory(Category category);

    /**
     * 删除零食分类
     *
     * @param categoryId 零食分类主键
     * @return 结果
     */
    public int deleteCategoryByCategoryId(String categoryId);

    /**
     * 批量删除零食分类
     *
     * @param categoryIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCategoryByCategoryIds(String[] categoryIds);

    /**
     * 不分页查询分类名称列表
     * @return
     */
    List<CategoryNameVO> selectAllCategoryNameList();

    /**
     * 查询每种分类各有多少商品
     * @return
     */
    List<PieVO> selectProductCountByCategory();
}
