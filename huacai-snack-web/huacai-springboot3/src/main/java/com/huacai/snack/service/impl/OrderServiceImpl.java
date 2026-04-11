package com.huacai.snack.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.huacai.snack.domain.vo.OrderStatusBarVO;
import com.huacai.system.general.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

import com.huacai.system.general.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.huacai.snack.domain.OrderProducts;
import com.huacai.snack.mapper.OrderMapper;
import com.huacai.snack.domain.Order;
import com.huacai.snack.service.IOrderService;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.util.CollectionUtils;

import static com.huacai.system.general.utils.SecurityUtils.getUserId;

/**
 * 订单Service业务层处理
 *
 * @author huacai
 * @date 2025-10-16
 */
@Service
public class OrderServiceImpl implements IOrderService {
    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private SqlSessionFactory sqlSessionFactory;

    /**
     * 查询订单
     *
     * @param orderId 订单主键
     * @return 订单
     */
    @Override
    public Order selectOrderByOrderId(String orderId) {
        return orderMapper.selectOrderByOrderId(orderId);
    }

    /**
     * 查询订单列表
     *
     * @param order 订单
     * @return 订单
     */
    @Override
    public List<Order> selectOrderList(Order order) {
        return orderMapper.selectOrderList(order);
    }

    /**
     * 新增订单
     *
     * @param order 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int insertOrder(Order order) {
        order.setCreateTime(DateUtils.getNowDate());
        Long userId = getUserId();
        order.setUserId(userId);

        //获取当前日期时间
        LocalDateTime now = LocalDateTime.now();
        //定义格式器
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        //格式化为字符串
        String formatDateTime = now.format(formatter);
        order.setOrderId("OR" + formatDateTime + userId);

        int rows = orderMapper.insertOrder(order);
        insertOrderProducts(order);
        return rows;
    }

    /**
     * 批量新增订单
     *
     * @param orders 订单List
     * @return 结果
     */
    @Override
    public int batchInsertOrder(List<Order> orders) {
        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH, false);
        int count = 0;
        if (!CollectionUtils.isEmpty(orders)) {
            try {
                for (int i = 0; i < orders.size(); i++) {
                    int row = orderMapper.insertOrder(orders.get(i));
                    // 防止内存溢出，每100次提交一次,并清除缓存
                    boolean bool = (i > 0 && i % 100 == 0) || i == orders.size() - 1;
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
     * 修改订单
     *
     * @param order 订单
     * @return 结果
     */
    @Transactional
    @Override
    public int updateOrder(Order order) {
        orderMapper.deleteOrderProductsByOrderId(order.getOrderId());
        insertOrderProducts(order);
        return orderMapper.updateOrder(order);
    }

    /**
     * 批量删除订单
     *
     * @param orderIds 需要删除的订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteOrderByOrderIds(String[] orderIds) {
        orderMapper.deleteOrderProductsByOrderIds(orderIds);
        return orderMapper.deleteOrderByOrderIds(orderIds);
    }

    /**
     * 删除订单信息
     *
     * @param orderId 订单主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteOrderByOrderId(String orderId) {
        orderMapper.deleteOrderProductsByOrderId(orderId);
        return orderMapper.deleteOrderByOrderId(orderId);
    }

    /**
     * 查询每种状态在订单中各有多少个
     * @return
     */
    @Override
    public List<OrderStatusBarVO> selectOrderStatus() {
        return orderMapper.selectOrderStatus();
    }

    /**
     * 新增订单商品明细信息
     *
     * @param order 订单对象
     */
    public void insertOrderProducts(Order order) {
        List<OrderProducts> orderProductsList = order.getOrderProductsList();
        String orderId = order.getOrderId();
        if (StringUtils.isNotNull(orderProductsList)) {
            List<OrderProducts> list = new ArrayList<OrderProducts>();
            for (OrderProducts orderProducts : orderProductsList) {
                orderProducts.setOrderId(orderId);
                list.add(orderProducts);
            }
            if (list.size() > 0) {
                orderMapper.batchOrderProducts(list);
            }
        }
    }
}
