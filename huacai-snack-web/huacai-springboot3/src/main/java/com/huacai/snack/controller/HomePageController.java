package com.huacai.snack.controller;

import com.huacai.snack.domain.Category;
import com.huacai.snack.domain.Order;
import com.huacai.snack.domain.Product;
import com.huacai.snack.domain.vo.CountInfoVO;
import com.huacai.snack.domain.vo.OrderStatusBarVO;
import com.huacai.snack.domain.vo.PieVO;
import com.huacai.snack.service.ICategoryService;
import com.huacai.snack.service.IOrderService;
import com.huacai.snack.service.IProductService;
import com.huacai.system.general.core.domain.AjaxResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/home/page")
public class HomePageController {
    @Autowired
    private IProductService productService;

    @Autowired
    private IOrderService orderService;

    @Autowired
    private ICategoryService categoryService;

    /**
     * 查询商品总数 订单总数 分类总数
     */
    @GetMapping("/selectDataInfo")
    public AjaxResult selectDataInfo() {
        //查询商品总数
        int productCount = productService.selectProductList(new Product()).size();
        //查询订单总数
        int orderCount = orderService.selectOrderList(new Order()).size();
        //查询分类总数
        int categoryCount = categoryService.selectCategoryList(new Category()).size();

        CountInfoVO countInfoVO = new CountInfoVO();
        countInfoVO.setProductCount(productCount);
        countInfoVO.setOrderCount(orderCount);
        countInfoVO.setCategoryCount(categoryCount);

        return AjaxResult.success(countInfoVO);
    }

    /**
     * 商品分类统计(商品数量对应商品分类名称)
     */
    @GetMapping("/selectCategoryChart")
    public AjaxResult selectCategoryChart() {
        List<PieVO> pieVOList = categoryService.selectProductCountByCategory();
        return AjaxResult.success(pieVOList);
    }

    /**
     * 订单状态统计(状态对应数量)
     */
    @GetMapping("/selectOrderStatusCount")
    public AjaxResult selectOrderStatusCount() {
        List<OrderStatusBarVO> orderStatusList = orderService.selectOrderStatus();

        //创建两个空列表, 分别用来存放订单状态名称和对应的订单数量
        ArrayList<String> statusList = new ArrayList<>();
        ArrayList<Integer> countList = new ArrayList<>();

        //遍历查询结果, 把每个状态和对应的数量分别添加到对应的列表中
        for (OrderStatusBarVO vo : orderStatusList) {
            statusList.add(vo.getOrderStatus());
            countList.add(vo.getOrderCount());
        }

        //创建一个Map来组织返回给前端的数据
        HashMap<String, Object> result = new HashMap<>();
        result.put("statusList", statusList);
        result.put("countList", countList);

        //返回成功结果, 包含状态列表和数量列表
        return AjaxResult.success(result);
    }

}
