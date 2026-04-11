package com.huacai.snack.service;

import java.util.List;
import com.huacai.snack.domain.Address;

/**
 * 收货地址Service接口
 *
 * @author huacai
 * @date 2025-10-14
 */
public interface IAddressService
{
    /**
     * 查询收货地址
     *
     * @param addressId 收货地址主键
     * @return 收货地址
     */
    public Address selectAddressByAddressId(String addressId);

    /**
     * 查询收货地址列表
     *
     * @param address 收货地址
     * @return 收货地址集合
     */
    public List<Address> selectAddressList(Address address);

    /**
     * 新增收货地址
     *
     * @param address 收货地址
     * @return 结果
     */
    public int insertAddress(Address address);

    /**
     * 批量新增收货地址
     *
     * @param addresss 收货地址List
     * @return 结果
     */
    public int batchInsertAddress(List<Address> addresss);

    /**
     * 修改收货地址
     *
     * @param address 收货地址
     * @return 结果
     */
    public int updateAddress(Address address);

    /**
     * 批量删除收货地址
     *
     * @param addressIds 需要删除的收货地址主键集合
     * @return 结果
     */
    public int deleteAddressByAddressIds(String[] addressIds);

    /**
     * 删除收货地址信息
     *
     * @param addressId 收货地址主键
     * @return 结果
     */
    public int deleteAddressByAddressId(String addressId);
}
