package com.huacai.snack.controller;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.huacai.system.general.core.controller.BaseController;
import com.huacai.system.general.core.domain.AjaxResult;

import java.io.InputStream;

import org.springframework.web.multipart.MultipartFile;
import com.huacai.snack.domain.Cart;
import com.huacai.snack.service.ICartService;
import com.huacai.system.general.utils.poi.ExcelUtil;
import com.huacai.system.general.core.page.TableDataInfo;

/**
 * 购物车Controller
 *
 * @author huacai
 * @date 2025-10-13
 */
@RestController
@RequestMapping("/snack/cart")
public class CartController extends BaseController {
    @Autowired
    private ICartService cartService;

    /**
     * 查询购物车列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Cart cart) {
        startPage();
        List<Cart> list = cartService.selectCartList(cart);
        return getDataTable(list);
    }

    /**
     * 导出购物车列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Cart cart) {
        List<Cart> list = cartService.selectCartList(cart);
        ExcelUtil<Cart> util = new ExcelUtil<Cart>(Cart. class);
        util.exportExcel(response, list, "购物车数据");
    }

    /**
     * 下载模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Cart> util = new ExcelUtil<Cart>(Cart. class);
        util.importTemplateExcel(response, "购物车数据");
    }

    /**
     * 导入数据
     */
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Cart> util = new ExcelUtil<Cart>(Cart. class);
        InputStream inputStream = file.getInputStream();
        List<Cart> list = util.importExcel(inputStream);
        inputStream.close();
        int count = cartService.batchInsertCart(list);
        return AjaxResult.success("导入成功" + count + "条信息！");
    }

    /**
     * 获取购物车详细信息
     */
    @GetMapping(value = "/{cartId}")
    public AjaxResult getInfo(@PathVariable("cartId") String cartId) {
        return success(cartService.selectCartByCartId(cartId));
    }

    /**
     * 新增购物车
     */
    @PostMapping
    public AjaxResult add(@RequestBody Cart cart) {
        return toAjax(cartService.insertCart(cart));
    }

    /**
     * 修改购物车
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Cart cart) {
        return toAjax(cartService.updateCart(cart));
    }

    /**
     * 删除购物车
     */
    @DeleteMapping("/{cartIds}")
    public AjaxResult remove(@PathVariable String[] cartIds) {
        return toAjax(cartService.deleteCartByCartIds(cartIds));
    }

    /**
     * 查询个人的购物车数据
     */
    @GetMapping("/selectMyCartList")
    public AjaxResult selectMyCartList() {
        Cart cart = new Cart();
        cart.setUserId(getUserId());
        List<Cart> list = cartService.selectCartList(cart);
        return success(list);
    }

    /**
     * 增加商品数量
     */
    @PutMapping("/increaseQuantity/{cartId}")
    public AjaxResult increaseQuantity(@PathVariable String cartId) {
        //查询该商品此前在购物车中的数量
        Long oldQuantity = cartService.selectCartByCartId(cartId).getQuantity();
        Cart cart = new Cart();
        cart.setCartId(cartId);
        cart.setQuantity(oldQuantity + 1);
        return toAjax(cartService.updateCart(cart));
    }

    /**
     * 减少商品数量
     */
    @PutMapping("/reduceQuantity/{cartId}")
    public AjaxResult reduceQuantity(@PathVariable String cartId) {
        //查询该商品此前在购物车中的数量
        Long oldQuantity = cartService.selectCartByCartId(cartId).getQuantity();
        Cart cart = new Cart();
        cart.setCartId(cartId);
        cart.setQuantity(oldQuantity - 1);
        return toAjax(cartService.updateCart(cart));
    }

    /**
     * 将商品添加至购物车
     */
    @PutMapping("/addProductToCart/{productId}")
    public AjaxResult addProductToCart(@PathVariable String productId) {
        return toAjax(cartService.addProductToCart(productId));
    }

}
