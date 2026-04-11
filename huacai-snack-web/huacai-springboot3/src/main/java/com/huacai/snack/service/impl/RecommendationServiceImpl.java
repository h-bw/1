package com.huacai.snack.service.impl;

import com.huacai.snack.domain.Order;
import com.huacai.snack.domain.OrderProducts;
import com.huacai.snack.domain.Product;
import com.huacai.snack.mapper.OrderMapper;
import com.huacai.snack.mapper.ProductMapper;
import com.huacai.snack.service.IRecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 推荐服务实现类
 */
@Service
public class RecommendationServiceImpl implements IRecommendationService {
    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private ProductMapper productMapper;

    /**
     * 获取推荐商品列表
     *
     * @param userId 当前用户ID
     * @param limit  返回的商品数量限制
     * @return 推荐商品列表
     */
    @Override
    public List<Product> getAdvancedRecommendationsForUser(Long userId, int limit) {
        //1.获取目标用户的历史订单数据
        List<Order> targetUserOrders = orderMapper.selectOrderList(new Order() {{
            setUserId(userId);
        }});

        //如果用户没有订单记录, 则返回热门商品
        if (targetUserOrders == null || targetUserOrders.isEmpty()) {
            return getPopularProducts(limit);
        }

        //2. 获取所有用户订单数据
        List<Order> allOrders = orderMapper.selectOrderList(new Order());

        //3. 找到相似用户
        Set<Long> similarUsers = findSimilarUsers(userId, targetUserOrders, allOrders);

        //4.获取相似用户喜欢的商品
        List<Product> SimilarUserProducts = getProductsFromSimilarUsers(similarUsers, targetUserOrders, allOrders);

        //5.结合原有推荐算法生成综合推荐
        List<Product> baseRecommendations = getRecommendationsForUser(userId, limit);

        //6.合并并且去重推荐结果
        Set<String> productIds = new HashSet<>();
        List<Product> finalRecommendations = new ArrayList<>();

        //先添加相似用户喜欢的商品
        for (Product product : SimilarUserProducts) {
            if (finalRecommendations.size() >= limit) break;
            if (!productIds.contains(product.getProductId())) {
                finalRecommendations.add(product);
                productIds.add(product.getProductId());
            }
        }

        //再补充基础推荐算法的结果
        for (Product product : baseRecommendations) {
            if (finalRecommendations.size() >= limit) break;
            if (!productIds.contains(product.getProductId())) {
                finalRecommendations.add(product);
                productIds.add(product.getProductId());
            }
        }

        return finalRecommendations;
    }

    /**
     * 获取热门商品列表
     */
    public List<Product> getPopularProducts(int limit) {
        //获取所有商品
        List<Product> allProducts = productMapper.selectProductList(new Product());

        //统计商品出现次数
        HashMap<String, Integer> productCountMap = new HashMap<>();

        //获取所有订单用于计算热度
        List<Order> allOrders = orderMapper.selectOrderList(new Order());

        //统计每个商品被购买的次数
        for (Order order : allOrders) {
            List<OrderProducts> orderProductsList = order.getOrderProductsList();
            if (orderProductsList != null) {
                for (OrderProducts op : orderProductsList) {
                    productCountMap.put(op.getName(), productCountMap.getOrDefault(op.getName(), 0) + 1);
                }
            }
        }

        //根据热度排序返回
        return allProducts.stream()
                .sorted((p1, p2) -> {
                    Integer count1 = productCountMap.getOrDefault(p1.getName(), 0);
                    Integer count2 = productCountMap.getOrDefault(p2.getName(), 0);
                    return Integer.compare(count2, count1); //降序排列
                })
                .limit(limit)
                .collect(Collectors.toList());
    }

    /**
     * 查找相似用户
     */
    private Set<Long> findSimilarUsers(Long userId, List<Order> targetUserOrders, List<Order> allOrders) {
        Set<Long> similarUsers = new HashSet<>();

        //获取目标用户购买的所有商品名称
        Set<String> targetUserProducts = targetUserOrders.stream()
                .flatMap(order -> order.getOrderProductsList().stream())
                .map(OrderProducts::getName)
                .collect(Collectors.toSet());

        // 遍历所有订单，查找购买了相同商品的其他用户
        for (Order order : allOrders) {
            // 跳过目标用户自己的订单
            if (order.getUserId() != null && order.getUserId().equals(userId)) {
                continue;
            }

            // 检查该订单是否包含目标用户购买过的商品
            List<OrderProducts> orderProductsList = order.getOrderProductsList();
            if (orderProductsList != null) {
                for (OrderProducts op : orderProductsList) {
                    if (targetUserProducts.contains(op.getName())) {
                        similarUsers.add(order.getUserId());
                        break; // 找到一个共同商品就足够了
                    }
                }
            }
        }
        return similarUsers;
    }

    /**
     * 获取相似用户喜欢的商品列表
     */
    private List<Product> getProductsFromSimilarUsers(Set<Long> similarUsers, List<Order> targetUserOrders, List<Order> allOrders) {
        //获取目标用户已经购买的商品
        Set<String> targetUserProducts = targetUserOrders.stream()
                .flatMap(order -> order.getOrderProductsList().stream())
                .map(OrderProducts::getName)
                .collect(Collectors.toSet());

        //统计相似用户购买的商品次数
        HashMap<String, Integer> similarUserProductCount = new HashMap<>();
        for (Order order : allOrders) {
            if (order.getUserId() != null && similarUsers.contains(order.getUserId())) {
                List<OrderProducts> orderProductsList = order.getOrderProductsList();
                if (orderProductsList != null) {
                    for (OrderProducts op : orderProductsList) {
                        //只统计目标用户未购买的商品
                        if (!targetUserProducts.contains(op.getName())) {
                            similarUserProductCount.put(op.getName(), similarUserProductCount.getOrDefault(op.getName(), 0) + 1);
                        }
                    }
                }
            }
        }

        //获取所有商品
        List<Product> allProducts = productMapper.selectProductList(new Product());

        //根据统计次数排序并且返回
        return allProducts.stream()
                .filter(product -> similarUserProductCount.containsKey(product.getName()))
                .sorted((p1, p2) -> {
                    Integer count1 = similarUserProductCount.getOrDefault(p1.getName(), 0);
                    Integer count2 = similarUserProductCount.getOrDefault(p2.getName(), 0);
                    return Integer.compare(count2, count1); //降序排列
                })
                .collect(Collectors.toList());
    }

    /**
     * 根据用户ID获取推荐商品列表
     */
    private List<Product> getRecommendationsForUser(Long userId, int limit) {
        //1.获取目标用户的历史订单数据
        List<Order> targetUserOrders = orderMapper.selectOrderList(new Order() {{
            setUserId(userId);
        }});

        //如果用户没有订单记录, 则返回热门商品
        if (targetUserOrders == null || targetUserOrders.isEmpty()) {
            return getPopularProducts(limit);
        }

        //2.构建用户画像, 统计用户购买过的商品分类偏好
        Map<String, Integer> categoryPreference = buildUserCategoryPreference(targetUserOrders);

        //3.获取所有商品
        List<Product> allProducts = productMapper.selectProductList(new Product());

        //4.计算每个商品的推荐分数
        Map<Product, Double> productScores = calculateProductScores(allProducts, categoryPreference, targetUserOrders);

        //5.根据分数拍需要并且返回前N个商品
        return productScores.entrySet().stream()
                .sorted(Map.Entry.<Product, Double>comparingByValue().reversed())
                .limit(limit)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
    }

    /**
     * 构建用户画像
     */
    private Map<String, Integer> buildUserCategoryPreference(List<Order> userOrders) {
        HashMap<String, Integer> categoryPreference = new HashMap<>();

        //遍历用户所有订单, 统计个分类商品的购买次数
        for (Order order : userOrders) {
            List<OrderProducts> orderProductsList = order.getOrderProductsList();
            if (orderProductsList != null) {
                for (OrderProducts op : orderProductsList) {
                    //使用商品名称作为标识
                    categoryPreference.put(op.getName(), categoryPreference.getOrDefault(op.getName(), 0) + 1);
                }
            }
        }
        return categoryPreference;
    }

    /**
     * 计算商品推荐分类
     */
    private Map<Product, Double> calculateProductScores(List<Product> products, Map<String, Integer> categoryPreference, List<Order> userOrders) {
        HashMap<Product, Double> scores = new HashMap<>();

        //获取用户已经购买的商品名称列表, 避免重复推荐
        Set<String> purchasedProducts = userOrders.stream()
                .flatMap(order -> order.getOrderProductsList().stream())
                .map(OrderProducts::getName)
                .collect(Collectors.toSet());

        for (Product product : products) {
            //避免推荐用户已经购买过的商品
            if (purchasedProducts.contains(product.getName())) {
                continue;
            }

            double score = 0.0;

            //1.基于分类偏好的分数(主要因素)
            Integer preferenceCount = categoryPreference.getOrDefault(product.getName(), 0);
            score += preferenceCount * 10; //偏好权重

            //2.基于价格的分数(价格适中更受欢迎)
            if (product.getPrice() != null) {
                //假设最受欢迎的价格区间是10-50元
                BigDecimal price = product.getPrice();
                if (price.compareTo(BigDecimal.valueOf(10)) >= 0 && price.compareTo(BigDecimal.valueOf(50)) <= 0) {
                    score += 5; //价格在合理区间加分
                }
            }

            //3.随机因子
            score += Math.random() * 3;

            scores.put(product, score);
        }
        return scores;
    }


}
