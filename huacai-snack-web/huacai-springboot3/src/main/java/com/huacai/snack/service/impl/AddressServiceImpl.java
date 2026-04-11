package com.huacai.snack.service.impl;

import java.util.List;

import com.huacai.system.general.utils.DateUtils;
import com.huacai.system.general.utils.uuid.IdUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.huacai.snack.mapper.AddressMapper;
import com.huacai.snack.domain.Address;
import com.huacai.snack.service.IAddressService;
import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.util.CollectionUtils;

import static com.huacai.system.general.utils.SecurityUtils.getUserId;

/**
 * 收货地址Service业务层处理
 *
 * @author huacai
 * @date 2025-10-14
 */
@Service
public class AddressServiceImpl implements IAddressService {
    @Autowired
    private AddressMapper addressMapper;

    @Autowired
    private SqlSessionFactory sqlSessionFactory;

    /**
     * 查询收货地址
     *
     * @param addressId 收货地址主键
     * @return 收货地址
     */
    @Override
    public Address selectAddressByAddressId(String addressId) {
        return addressMapper.selectAddressByAddressId(addressId);
    }

    /**
     * 查询收货地址列表
     *
     * @param address 收货地址
     * @return 收货地址
     */
    @Override
    public List<Address> selectAddressList(Address address) {
        return addressMapper.selectAddressList(address);
    }

    /**
     * 新增收货地址
     *
     * @param address 收货地址
     * @return 结果
     */
    @Override
    public int insertAddress(Address address) {
        Long userId = getUserId();

        address.setCreateTime(DateUtils.getNowDate());
        address.setAddressId(IdUtils.fastSimpleUUID());
        address.setUserId(userId);

        //查询个人此前是否有默认收货地址
        Boolean isDefaultByUserId = addressMapper.selectIsDefaultByUserId(userId);
        //如果已有默认收货地址, 就将此前的默认地址修改为非默认, 再新增新地址
        if (isDefaultByUserId) {
            //根据用户ID查询此前的默认地址ID
            String addressId = addressMapper.selectOldDefaultAddressIdByUserId(userId);
            Address newDefaultAddress = new Address();
            newDefaultAddress.setAddressId(addressId);
            newDefaultAddress.setIsDefault(false);
            addressMapper.updateAddress(newDefaultAddress);
            return addressMapper.insertAddress(address);
        } else {
            //如果此前没有默认地址, 就直接插入
            return addressMapper.insertAddress(address);
        }
    }

    /**
     * 批量新增收货地址
     *
     * @param addresss 收货地址List
     * @return 结果
     */
    @Override
    public int batchInsertAddress(List<Address> addresss) {
        SqlSession sqlSession = sqlSessionFactory.openSession(ExecutorType.BATCH, false);
        int count = 0;
        if (!CollectionUtils.isEmpty(addresss)) {
            try {
                for (int i = 0; i < addresss.size(); i++) {
                    int row = addressMapper.insertAddress(addresss.get(i));
                    // 防止内存溢出，每100次提交一次,并清除缓存
                    boolean bool = (i > 0 && i % 100 == 0) || i == addresss.size() - 1;
                    if (bool) {
                        sqlSession.commit();
                        sqlSession.clearCache();
                    }
                    count = i + 1;
                }
            } catch (Exception e) {
                e.printStackTrace();
                // 没有提交的数据可以回滚
                sqlSession.rollback();
            } finally {
                sqlSession.close();
                return count;
            }
        }
        return count;
    }

    /**
     * 修改收货地址
     *
     * @param address 收货地址
     * @return 结果
     */
    @Override
    public int updateAddress(Address address) {
        return addressMapper.updateAddress(address);
    }

    /**
     * 批量删除收货地址
     *
     * @param addressIds 需要删除的收货地址主键
     * @return 结果
     */
    @Override
    public int deleteAddressByAddressIds(String[] addressIds) {
        return addressMapper.deleteAddressByAddressIds(addressIds);
    }

    /**
     * 删除收货地址信息
     *
     * @param addressId 收货地址主键
     * @return 结果
     */
    @Override
    public int deleteAddressByAddressId(String addressId) {
        return addressMapper.deleteAddressByAddressId(addressId);
    }
}
