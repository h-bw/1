package com.huacai.snack.service.impl;

import com.huacai.snack.domain.Order;
import com.huacai.snack.domain.OrderProducts;
import com.huacai.snack.domain.Product;
import com.huacai.snack.mapper.OrderMapper;
import com.huacai.snack.mapper.ProductMapper;
import com.huacai.snack.service.IRecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
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
     * 获取推荐商品列表。
     * <p>
     * 实现方式：基于用户购买历史构建用户-商品交互矩阵，使用余弦相似度计算用户相似度，
     * 再对相似用户购买过而当前用户未购买的商品进行加权求和排序。
     * 如果当前用户没有历史订单或候选结果不足，则回退到热门商品推荐。
     */
    @Override
    public List<Product> getAdvancedRecommendationsForUser(Long userId, int limit) {
        if (userId == null || limit <= 0) {
            return Collections.emptyList();
        }

        List<Order> allOrders = safeOrderList(orderMapper.selectOrderList(new Order()));
        Map<Long, Map<String, Double>> userItemMatrix = buildUserItemMatrix(allOrders);
        Map<String, Double> targetInteractions = userItemMatrix.getOrDefault(userId, Collections.emptyMap());
        if (targetInteractions.isEmpty()) {
            return getPopularProducts(limit);
        }

        List<Product> allProducts = safeProductList(productMapper.selectProductList(new Product()));
        if (allProducts.isEmpty()) {
            return Collections.emptyList();
        }

        Map<String, Product> productByName = allProducts.stream()
                .filter(product -> hasText(product.getName()))
                .collect(Collectors.toMap(
                        Product::getName,
                        product -> product,
                        (existing, ignored) -> existing,
                        LinkedHashMap::new
                ));

        Set<String> purchasedProducts = new HashSet<>(targetInteractions.keySet());
        Map<Long, Double> userSimilarities = calculateUserSimilarities(userId, targetInteractions, userItemMatrix);
        Map<String, Double> collaborativeScores = scoreCandidateProducts(userSimilarities, userItemMatrix, purchasedProducts);

        List<Product> recommendations = collaborativeScores.entrySet().stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed()
                        .thenComparing(Map.Entry::getKey))
                .map(entry -> productByName.get(entry.getKey()))
                .filter(Objects::nonNull)
                .limit(limit)
                .collect(Collectors.toCollection(ArrayList::new));

        if (recommendations.size() >= limit) {
            return recommendations;
        }

        return supplementWithPopularProducts(recommendations, allProducts, allOrders, purchasedProducts, limit);
    }

    /**
     * 获取热门商品列表。
     */
    public List<Product> getPopularProducts(int limit) {
        if (limit <= 0) {
            return Collections.emptyList();
        }

        List<Order> allOrders = safeOrderList(orderMapper.selectOrderList(new Order()));
        List<Product> allProducts = safeProductList(productMapper.selectProductList(new Product()));
        return rankProductsByPopularity(allProducts, allOrders, Collections.emptySet(), Collections.emptySet(), limit);
    }

    private Map<Long, Map<String, Double>> buildUserItemMatrix(List<Order> orders) {
        Map<Long, Map<String, Double>> userItemMatrix = new HashMap<>();
        for (Order order : orders) {
            if (order == null || order.getUserId() == null) {
                continue;
            }

            Map<String, Double> itemPreferences = userItemMatrix.computeIfAbsent(order.getUserId(), key -> new HashMap<>());
            for (OrderProducts orderProduct : safeOrderProducts(order.getOrderProductsList())) {
                if (!hasText(orderProduct.getName())) {
                    continue;
                }

                double preference = extractPreference(orderProduct);
                itemPreferences.merge(orderProduct.getName(), preference, Double::sum);
            }
        }
        return userItemMatrix;
    }

    private Map<Long, Double> calculateUserSimilarities(Long userId,
                                                        Map<String, Double> targetInteractions,
                                                        Map<Long, Map<String, Double>> userItemMatrix) {
        Map<Long, Double> userSimilarities = new HashMap<>();
        for (Map.Entry<Long, Map<String, Double>> entry : userItemMatrix.entrySet()) {
            Long otherUserId = entry.getKey();
            if (userId.equals(otherUserId)) {
                continue;
            }

            double similarity = cosineSimilarity(targetInteractions, entry.getValue());
            if (similarity > 0D) {
                userSimilarities.put(otherUserId, similarity);
            }
        }
        return userSimilarities;
    }

    private Map<String, Double> scoreCandidateProducts(Map<Long, Double> userSimilarities,
                                                       Map<Long, Map<String, Double>> userItemMatrix,
                                                       Set<String> purchasedProducts) {
        Map<String, Double> collaborativeScores = new HashMap<>();

        for (Map.Entry<Long, Double> similarityEntry : userSimilarities.entrySet()) {
            Double similarity = similarityEntry.getValue();
            Map<String, Double> otherUserInteractions = userItemMatrix.getOrDefault(similarityEntry.getKey(), Collections.emptyMap());

            for (Map.Entry<String, Double> itemEntry : otherUserInteractions.entrySet()) {
                String productName = itemEntry.getKey();
                if (purchasedProducts.contains(productName)) {
                    continue;
                }

                collaborativeScores.merge(productName, similarity * itemEntry.getValue(), Double::sum);
            }
        }

        return collaborativeScores;
    }

    private double cosineSimilarity(Map<String, Double> left, Map<String, Double> right) {
        if (left.isEmpty() || right.isEmpty()) {
            return 0D;
        }

        Map<String, Double> smaller = left.size() <= right.size() ? left : right;
        Map<String, Double> larger = smaller == left ? right : left;

        double dotProduct = 0D;
        for (Map.Entry<String, Double> entry : smaller.entrySet()) {
            Double otherValue = larger.get(entry.getKey());
            if (otherValue != null) {
                dotProduct += entry.getValue() * otherValue;
            }
        }

        if (dotProduct == 0D) {
            return 0D;
        }

        double leftNorm = vectorNorm(left.values());
        double rightNorm = vectorNorm(right.values());
        if (leftNorm == 0D || rightNorm == 0D) {
            return 0D;
        }
        return dotProduct / (leftNorm * rightNorm);
    }

    private double vectorNorm(Collection<Double> values) {
        double squareSum = 0D;
        for (Double value : values) {
            if (value != null) {
                squareSum += value * value;
            }
        }
        return Math.sqrt(squareSum);
    }

    private List<Product> supplementWithPopularProducts(List<Product> collaborativeResults,
                                                        List<Product> allProducts,
                                                        List<Order> allOrders,
                                                        Set<String> purchasedProducts,
                                                        int limit) {
        LinkedHashSet<String> existingNames = collaborativeResults.stream()
                .map(Product::getName)
                .filter(this::hasText)
                .collect(Collectors.toCollection(LinkedHashSet::new));

        List<Product> supplemented = new ArrayList<>(collaborativeResults);
        List<Product> popularProducts = rankProductsByPopularity(allProducts, allOrders, purchasedProducts, existingNames, limit);
        for (Product product : popularProducts) {
            if (supplemented.size() >= limit) {
                break;
            }
            supplemented.add(product);
        }
        return supplemented;
    }

    private List<Product> rankProductsByPopularity(List<Product> allProducts,
                                                   List<Order> allOrders,
                                                   Set<String> excludedProducts,
                                                   Set<String> existingProducts,
                                                   int limit) {
        Map<String, Integer> popularity = buildProductPopularity(allOrders);
        Comparator<Product> comparator = Comparator
                .comparingInt((Product product) -> popularity.getOrDefault(product.getName(), 0))
                .reversed()
                .thenComparing(Product::getName, Comparator.nullsLast(String::compareTo));

        return allProducts.stream()
                .filter(product -> hasText(product.getName()))
                .filter(product -> !excludedProducts.contains(product.getName()))
                .filter(product -> !existingProducts.contains(product.getName()))
                .sorted(comparator)
                .limit(limit)
                .collect(Collectors.toList());
    }

    private Map<String, Integer> buildProductPopularity(List<Order> orders) {
        Map<String, Integer> popularity = new HashMap<>();
        for (Order order : orders) {
            for (OrderProducts orderProduct : safeOrderProducts(order.getOrderProductsList())) {
                if (!hasText(orderProduct.getName())) {
                    continue;
                }

                int weight = (int) Math.max(1L, orderProduct.getQuantity() == null ? 1L : orderProduct.getQuantity());
                popularity.merge(orderProduct.getName(), weight, Integer::sum);
            }
        }
        return popularity;
    }

    private double extractPreference(OrderProducts orderProduct) {
        if (orderProduct.getQuantity() == null || orderProduct.getQuantity() <= 0) {
            return 1D;
        }
        return orderProduct.getQuantity();
    }

    private List<Order> safeOrderList(List<Order> orders) {
        return orders == null ? Collections.emptyList() : orders;
    }

    private List<Product> safeProductList(List<Product> products) {
        return products == null ? Collections.emptyList() : products;
    }

    private List<OrderProducts> safeOrderProducts(List<OrderProducts> orderProducts) {
        return orderProducts == null ? Collections.emptyList() : orderProducts;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
