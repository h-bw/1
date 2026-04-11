package com.huacai.snack.service;

import com.huacai.snack.domain.Product;

import java.util.List;

/**
 * 推荐服务接口
 */
public interface IRecommendationService {

    /**
     * 获取推荐商品列表
     * @param userId 当前用户ID
     * @param limit 返回的商品数量限制
     * @return 推荐商品列表
     */
    List<Product> getAdvancedRecommendationsForUser(Long userId, int limit);
}
