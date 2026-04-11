package com.huacai.snack.mapper;

import java.util.List;

import com.huacai.snack.domain.vo.OrderStatusBarVO;
import org.apache.ibatis.annotations.Mapper;
import com.huacai.snack.domain.Order;
import com.huacai.snack.domain.OrderProducts;

/**
 * 订单Mapper接口
 *
 * @author huacai
 * @date 2025-10-16
 */
@Mapper
public interface OrderMapper
{
    /**
     * 查询订单
     *
     * @param orderId 订单主键
     * @return 订单
     */
    public Order selectOrderByOrderId(String orderId);

    /**
     * 查询订单列表
     *
     * @param order 订单
     * @return 订单集合
     */
    public List<Order> selectOrderList(Order order);

    /**
     * 新增订单
     *
     * @param order 订单
     * @return 结果
     */
    public int insertOrder(Order order);

    /**
     * 修改订单
     *
     * @param order 订单
     * @return 结果
     */
    public int updateOrder(Order order);

    /**
     * 删除订单
     *
     * @param orderId 订单主键
     * @return 结果
     */
    public int deleteOrderByOrderId(String orderId);

    /**
     * 批量删除订单
     *
     * @param orderIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderByOrderIds(String[] orderIds);

    /**
     * 批量删除订单商品明细
     *
     * @param orderIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderProductsByOrderIds(String[] orderIds);

    /**
     * 批量新增订单商品明细
     *
     * @param orderProductsList 订单商品明细列表
     * @return 结果
     */
    public int batchOrderProducts(List<OrderProducts> orderProductsList);


    /**
     * 通过订单主键删除订单商品明细信息
     *
     * @param orderId 订单ID
     * @return 结果
     */
    public int deleteOrderProductsByOrderId(String orderId);

    /**
     * 查询每种状态在订单中各有多少个
     * @return
     */
    List<OrderStatusBarVO> selectOrderStatus();
}
