package com.huacai.snack.controller;

import com.huacai.snack.domain.Product;
import com.huacai.snack.service.IRecommendationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.huacai.system.general.core.controller.BaseController;
import com.huacai.system.general.core.page.TableDataInfo;

import java.util.List;

/**
 * 推荐控制器
 *
 * @author huacai
 * @date 2025-10-10
 */
@RestController
@RequestMapping("/snack/recommendation")
public class RecommendationController extends BaseController {

    @Autowired
    private IRecommendationService recommendationService;

    /**
     * 获取推荐商品列表
     */
    @GetMapping("/advanced")
    public TableDataInfo getAdvancedRecommendationsForUser(@RequestParam(defaultValue = "10") int limit) {
        startPage();
        Long userId = getUserId();
        List<Product> list = recommendationService.getAdvancedRecommendationsForUser(userId, limit);
        return getDataTable(list);
    }
}
