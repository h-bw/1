package com.huacai.snack.service.impl;

import java.util.List;

import com.huacai.system.general.utils.DateUtils;
import com.huacai.system.general.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.huacai.snack.mapper.CartMapper;
import com.huacai.snack.domain.Cart;
import com.huacai.snack.service.ICartService;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import static com.huacai.system.general.utils.SecurityUtils.getUserId;

/**
 * 购物车Service业务层处理
 *
 * @author huacai
 * @date 2025-10-13
 */
@Service
public class CartServiceImpl implements ICartService {
    @Autowired
    private CartMapper cartMapper;

    @Autowired
    private SqlSessionFactory sqlSessionFactory;

    /**
     * 查询购物车
     *
     * @param cartId 购物车主键
     * @return 购物车
     */
    @Override
    public Cart selectCartByCartId(String cartId) {
        return cartMapper.selectCartByCartId(cartId);
    }

    /**
     * 查询购物车列表
     *
     * @param cart 购物车
     * @return 购物车
     */
    @Override
    public List<Cart> selectCartList(Cart cart) {
        return cartMapper.selectCartList(cart);
    }

    /**
     * 新增购物车
     *
     * @param cart 购物车
     * @return 结果
     */
    @Override
    public int insertCart(Cart cart) {
        cart.setCreateTime(DateUtils.getNowDate());
        cart.setCartId(IdUtils.fastSimpleUUID());
        cart.setUserId(getUserId());
        return cartMapper.insertCart(cart);
    }

    /**
     * 批量新增购物车
     *
     * @param carts 购物车List
     * @return 结果
     */
    @Override
    public int batchInsertCart(List<Cart> carts) {
        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH, false);
        int count = 0;
        if (!CollectionUtils.isEmpty(carts)) {
            try {
                for (int i = 0; i < carts.size(); i++) {
                    int row = cartMapper.insertCart(carts.get(i));
                    // 防止内存溢出，每100次提交一次,并清除缓存
                    boolean bool = (i > 0 && i % 100 == 0) || i == carts.size() - 1;
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
     * 修改购物车
     *
     * @param cart 购物车
     * @return 结果
     */
    @Override
    public int updateCart(Cart cart) {
        return cartMapper.updateCart(cart);
    }

    /**
     * 批量删除购物车
     *
     * @param cartIds 需要删除的购物车主键
     * @return 结果
     */
    @Override
    public int deleteCartByCartIds(String[] cartIds) {
        return cartMapper.deleteCartByCartIds(cartIds);
    }

    /**
     * 删除购物车信息
     *
     * @param cartId 购物车主键
     * @return 结果
     */
    @Override
    public int deleteCartByCartId(String cartId) {
        return cartMapper.deleteCartByCartId(cartId);
    }

    /**
     * 将商品添加至购物车
     * @param productId
     * @return
     */
    @Override
    @Transactional
    public int addProductToCart(String productId) {
        //根据商品ID和用户ID查询购物车中是否有该商品
        Boolean isExist = cartMapper.selectIsExistByProductIdAndUserId(productId, getUserId());

        //如果有该商品, 就在原来的基础上把数量+1
        if (isExist) {
            //根据商品ID和用户ID查询购物信息
            Cart cart = cartMapper.selectCartByProductIdAndUserId(productId, getUserId());
            cart.setQuantity(cart.getQuantity() + 1);
            return cartMapper.updateCart(cart);
        } else {
            //如果没有商品, 就新增一条信息
            Cart cart = new Cart();
            cart.setCreateTime(DateUtils.getNowDate());
            cart.setCartId(IdUtils.fastSimpleUUID());
            cart.setUserId(getUserId());
            cart.setProductId(productId);
            cart.setQuantity(1L);
            return cartMapper.insertCart(cart);
        }
    }
}
