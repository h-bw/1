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
import com.huacai.snack.domain.Address;
import com.huacai.snack.service.IAddressService;
import com.huacai.system.general.utils.poi.ExcelUtil;
import com.huacai.system.general.core.page.TableDataInfo;

/**
 * 收货地址Controller
 *
 * @author huacai
 * @date 2025-10-14
 */
@RestController
@RequestMapping("/snack/address")
public class AddressController extends BaseController {
    @Autowired
    private IAddressService addressService;

    /**
     * 查询收货地址列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Address address) {
        startPage();
        List<Address> list = addressService.selectAddressList(address);
        return getDataTable(list);
    }

    /**
     * 导出收货地址列表
     */
    @PostMapping("/export")
    public void export(HttpServletResponse response, Address address) {
        List<Address> list = addressService.selectAddressList(address);
        ExcelUtil<Address> util = new ExcelUtil<Address>(Address. class);
        util.exportExcel(response, list, "收货地址数据");
    }

    /**
     * 下载模板
     */
    @PostMapping("/importTemplate")
    public void importTemplate(HttpServletResponse response) {
        ExcelUtil<Address> util = new ExcelUtil<Address>(Address. class);
        util.importTemplateExcel(response, "收货地址数据");
    }

    /**
     * 导入数据
     */
    @PostMapping("/importData")
    public AjaxResult importData(MultipartFile file) throws Exception {
        ExcelUtil<Address> util = new ExcelUtil<Address>(Address. class);
        InputStream inputStream = file.getInputStream();
        List<Address> list = util.importExcel(inputStream);
        inputStream.close();
        int count = addressService.batchInsertAddress(list);
        return AjaxResult.success("导入成功" + count + "条信息！");
    }

    /**
     * 获取收货地址详细信息
     */
    @GetMapping(value = "/{addressId}")
    public AjaxResult getInfo(@PathVariable("addressId") String addressId) {
        return success(addressService.selectAddressByAddressId(addressId));
    }

    /**
     * 新增收货地址
     */
    @PostMapping
    public AjaxResult add(@RequestBody Address address) {
        return toAjax(addressService.insertAddress(address));
    }

    /**
     * 修改收货地址
     */
    @PutMapping
    public AjaxResult edit(@RequestBody Address address) {
        return toAjax(addressService.updateAddress(address));
    }

    /**
     * 删除收货地址
     */
    @DeleteMapping("/{addressIds}")
    public AjaxResult remove(@PathVariable String[] addressIds) {
        return toAjax(addressService.deleteAddressByAddressIds(addressIds));
    }

    /**
     * 查询个人的收货地址列表
     */
    @GetMapping("/selectMyAddressList")
    public AjaxResult selectMyAddressList() {
        Address address = new Address();
        address.setUserId(getUserId());
        return success(addressService.selectAddressList(address));
    }
}
