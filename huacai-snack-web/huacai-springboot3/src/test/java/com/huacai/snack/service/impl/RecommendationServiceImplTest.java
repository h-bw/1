package com.huacai.snack.service.impl;

import com.huacai.snack.domain.Order;
import com.huacai.snack.domain.OrderProducts;
import com.huacai.snack.domain.Product;
import com.huacai.snack.mapper.OrderMapper;
import com.huacai.snack.mapper.ProductMapper;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertIterableEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RecommendationServiceImplTest {

    @Mock
    private OrderMapper orderMapper;

    @Mock
    private ProductMapper productMapper;

    @InjectMocks
    private RecommendationServiceImpl recommendationService;

    @Test
    void shouldRecommendProductsFromMostSimilarUsers() {
        List<Order> allOrders = List.of(
                order(1L, "芒果干", 1L),
                order(2L, "芒果干", 1L),
                order(2L, "开心果", 2L),
                order(3L, "牛肉干", 1L)
        );
        List<Product> allProducts = List.of(
                product("701", "芒果干"),
                product("105", "开心果"),
                product("301", "牛肉干")
        );

        when(orderMapper.selectOrderList(any(Order.class))).thenReturn(allOrders);
        when(productMapper.selectProductList(any(Product.class))).thenReturn(allProducts);

        List<Product> recommendations = recommendationService.getAdvancedRecommendationsForUser(1L, 1);

        assertEquals(1, recommendations.size());
        assertEquals("开心果", recommendations.get(0).getName());
    }

    @Test
    void shouldFallbackToPopularProductsWhenTargetUserHasNoHistory() {
        List<Order> allOrders = List.of(
                order(2L, "开心果", 3L),
                order(3L, "开心果", 1L),
                order(4L, "牛肉干", 1L)
        );
        List<Product> allProducts = List.of(
                product("105", "开心果"),
                product("301", "牛肉干")
        );

        when(orderMapper.selectOrderList(any(Order.class))).thenReturn(allOrders);
        when(productMapper.selectProductList(any(Product.class))).thenReturn(allProducts);

        List<Product> recommendations = recommendationService.getAdvancedRecommendationsForUser(1L, 2);

        assertIterableEquals(List.of("开心果", "牛肉干"),
                recommendations.stream().map(Product::getName).toList());
    }

    private static Order order(Long userId, String productName, Long quantity) {
        Order order = new Order();
        order.setUserId(userId);
        OrderProducts orderProducts = new OrderProducts();
        orderProducts.setName(productName);
        orderProducts.setQuantity(quantity);
        order.setOrderProductsList(List.of(orderProducts));
        return order;
    }

    private static Product product(String productId, String productName) {
        Product product = new Product();
        product.setProductId(productId);
        product.setName(productName);
        product.setPrice(BigDecimal.valueOf(19.9));
        return product;
    }
}
