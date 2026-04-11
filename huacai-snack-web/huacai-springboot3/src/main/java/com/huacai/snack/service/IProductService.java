package com.huacai.snack.service;

import java.util.List;
import com.huacai.snack.domain.Product;

/**
 * 商品Service接口
 *
 * @author huacai
 * @date 2025-10-12
 */
public interface IProductService
{
    /**
     * 查询商品
     *
     * @param productId 商品主键
     * @return 商品
     */
    public Product selectProductByProductId(String productId);

    /**
     * 查询商品列表
     *
     * @param product 商品
     * @return 商品集合
     */
    public List<Product> selectProductList(Product product);

    /**
     * 新增商品
     *
     * @param product 商品
     * @return 结果
     */
    public int insertProduct(Product product);

    /**
     * 批量新增商品
     *
     * @param products 商品List
     * @return 结果
     */
    public int batchInsertProduct(List<Product> products);

    /**
     * 修改商品
     *
     * @param product 商品
     * @return 结果
     */
    public int updateProduct(Product product);

    /**
     * 批量删除商品
     *
     * @param productIds 需要删除的商品主键集合
     * @return 结果
     */
    public int deleteProductByProductIds(String[] productIds);

    /**
     * 删除商品信息
     *
     * @param productId 商品主键
     * @return 结果
     */
    public int deleteProductByProductId(String productId);
}
