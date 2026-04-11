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
import com.huacai.snack.domain.Product;
import com.huacai.snack.service.IProductService;
import com.huacai.system.general.utils.poi.ExcelUtil;
import com.huacai.system.general.core.page.TableDataInfo;

/**
 * 商品Controller
 *
 * @author huacai
 * @date 2025-10-12
 */
@RestController
@RequestMapping("/snack/product")
public class ProductController extends BaseController {
    @Autowired
    private IProductService productService;

    /**
     * 查询商品列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Product product) {
        startPage();
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }

    /**
     * 导出商品列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Product product) {
        List<Product> list = productService.selectProductList(product);
        ExcelUtil<Product> util = new ExcelUtil<Product>(Product. class);
        util.exportExcel(response, list, "商品数据");
    }

    /**
     * 下载模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Product> util = new ExcelUtil<Product>(Product. class);
        util.importTemplateExcel(response, "商品数据");
    }

    /**
     * 导入数据
     */
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Product> util = new ExcelUtil<Product>(Product. class);
        InputStream inputStream = file.getInputStream();
        List<Product> list = util.importExcel(inputStream);
        inputStream.close();
        int count = productService.batchInsertProduct(list);
        return AjaxResult.success("导入成功" + count + "条信息！");
    }

    /**
     * 获取商品详细信息
     */
    @GetMapping(value = "/{productId}")
    public AjaxResult getInfo(@PathVariable("productId") String productId) {
        return success(productService.selectProductByProductId(productId));
    }

    /**
     * 新增商品
     */
    @PostMapping
    public AjaxResult add(@RequestBody Product product) {
        return toAjax(productService.insertProduct(product));
    }

    /**
     * 修改商品
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Product product) {
        return toAjax(productService.updateProduct(product));
    }

    /**
     * 删除商品
     */
    @DeleteMapping("/{productIds}")
    public AjaxResult remove(@PathVariable String[] productIds) {
        return toAjax(productService.deleteProductByProductIds(productIds));
    }
}
