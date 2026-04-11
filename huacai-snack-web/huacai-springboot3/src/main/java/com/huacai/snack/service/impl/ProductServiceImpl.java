package com.huacai.snack.service.impl;

import java.util.List;

import com.huacai.system.general.utils.DateUtils;
import com.huacai.system.general.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.huacai.snack.mapper.ProductMapper;
import com.huacai.snack.domain.Product;
import com.huacai.snack.service.IProductService;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.util.CollectionUtils;

/**
 * 商品Service业务层处理
 *
 * @author huacai
 * @date 2025-10-12
 */
@Service
public class ProductServiceImpl implements IProductService {
    @Autowired
    private ProductMapper productMapper;

    @Autowired
    private SqlSessionFactory sqlSessionFactory;

    /**
     * 查询商品
     *
     * @param productId 商品主键
     * @return 商品
     */
    @Override
    public Product selectProductByProductId(String productId) {
        return productMapper.selectProductByProductId(productId);
    }

    /**
     * 查询商品列表
     *
     * @param product 商品
     * @return 商品
     */
    @Override
    public List<Product> selectProductList(Product product) {
        return productMapper.selectProductList(product);
    }

    /**
     * 新增商品
     *
     * @param product 商品
     * @return 结果
     */
    @Override
    public int insertProduct(Product product) {
        product.setCreateTime(DateUtils.getNowDate());
        product.setProductId(IdUtils.fastSimpleUUID());
        return productMapper.insertProduct(product);
    }

    /**
     * 批量新增商品
     *
     * @param products 商品List
     * @return 结果
     */
    @Override
    public int batchInsertProduct(List<Product> products) {
        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH, false);
        int count = 0;
        if (!CollectionUtils.isEmpty(products)) {
            try {
                for (int i = 0; i < products.size(); i++) {
                    int row = productMapper.insertProduct(products.get(i));
                    // 防止内存溢出，每100次提交一次,并清除缓存
                    boolean bool = (i > 0 && i % 100 == 0) || i == products.size() - 1;
                    if (bool) {
                        sqlSession.commit();
                        sqlSession.clearCache();
                    }
                    count = i + 1;
                }
            } catch (Exception e) {
                e.printStackTrace();
                // 没有提交的数据可以回滚
                sqlSession.rollback();
            } finally {
                sqlSession.close();
                return count;
            }
        }
        return count;
    }

    /**
     * 修改商品
     *
     * @param product 商品
     * @return 结果
     */
    @Override
    public int updateProduct(Product product) {
        return productMapper.updateProduct(product);
    }

    /**
     * 批量删除商品
     *
     * @param productIds 需要删除的商品主键
     * @return 结果
     */
    @Override
    public int deleteProductByProductIds(String[] productIds) {
        return productMapper.deleteProductByProductIds(productIds);
    }

    /**
     * 删除商品信息
     *
     * @param productId 商品主键
     * @return 结果
     */
    @Override
    public int deleteProductByProductId(String productId) {
        return productMapper.deleteProductByProductId(productId);
    }
}
