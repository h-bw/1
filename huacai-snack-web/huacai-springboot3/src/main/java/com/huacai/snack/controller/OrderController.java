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
import com.huacai.snack.domain.Order;
import com.huacai.snack.service.IOrderService;
import com.huacai.system.general.utils.poi.ExcelUtil;
import com.huacai.system.general.core.page.TableDataInfo;

/**
 * 订单Controller
 *
 * @author huacai
 * @date 2025-10-16
 */
@RestController
@RequestMapping("/snack/order")
public class OrderController extends BaseController {
    @Autowired
    private IOrderService orderService;

    /**
     * 查询订单列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Order order) {
        startPage();
        List<Order> list = orderService.selectOrderList(order);
        return getDataTable(list);
    }

    /**
     * 导出订单列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Order order) {
        List<Order> list = orderService.selectOrderList(order);
        ExcelUtil<Order> util = new ExcelUtil<Order>(Order. class);
        util.exportExcel(response, list, "订单数据");
    }

    /**
     * 下载模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Order> util = new ExcelUtil<Order>(Order. class);
        util.importTemplateExcel(response, "订单数据");
    }

    /**
     * 导入数据
     */
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Order> util = new ExcelUtil<Order>(Order. class);
        InputStream inputStream = file.getInputStream();
        List<Order> list = util.importExcel(inputStream);
        inputStream.close();
        int count = orderService.batchInsertOrder(list);
        return AjaxResult.success("导入成功" + count + "条信息！");
    }

    /**
     * 获取订单详细信息
     */
    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") String orderId) {
        return success(orderService.selectOrderByOrderId(orderId));
    }

    /**
     * 新增订单
     */
    @PostMapping
    public AjaxResult add(@RequestBody Order order) {
        return toAjax(orderService.insertOrder(order));
    }

    /**
     * 修改订单
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Order order) {
        return toAjax(orderService.updateOrder(order));
    }

    /**
     * 删除订单
     */
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable String[] orderIds) {
        return toAjax(orderService.deleteOrderByOrderIds(orderIds));
    }

    /**
     * 查询个人的所有订单
     */
    @GetMapping("/selectMyOrderList")
    public AjaxResult selectMyOrderList() {
        Order order = new Order();
        order.setUserId(getUserId());
        return success(orderService.selectOrderList(order));
    }

}
