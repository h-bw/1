<template>
  <!-- 订单确认页面容器 -->
    <view class="order-confirm-container">
        <!-- 收货地址区域 -->
        <view class="address-section" @click="selectAddress">
            <!-- 如果有选中的地址, 显示地址信息 -->
            <view class="address-content" v-if="selectedAddress">
                <view class="address-info">
                    <!-- 联系人信息 -->
                    <view class="contact-info">
                        <text class="name">{{ selectedAddress.name }}</text>
                        <text class="phone">{{ selectedAddress.phone }}</text>
                    </view>
                    <!-- 详细地址 -->
                    <view class="address-detail">
                        {{ selectedAddress.detail }}
                    </view>
                </view>
                <!-- 右侧箭头图片 -->
                <uni-icons type="right" size="20" color="#999"/>
            </view>
            <!-- 如果没有选中的地址, 显示占位符 -->
            <view v-else class="address-placeholder">
                <text>请选择收货地址</text>
                <uni-icons type="right" size="20" color="#999"/>
            </view>
        </view>

        <!-- 添加地址按钮(仅在没有地址时显示) -->
        <view class="add-address-section" v-if="!selectedAddress && addressList.length === 0" @click="addAddress">
            <view class="add-address-btn">
                <uni-icons type="plusempty" size="18" color="#ff5339"/>
                <text class="add-text">新增收货地址</text>
            </view>
        </view>

        <!-- 商品列表区域 -->
        <view class="products-section">
            <view class="section-title">商品信息</view>
            <!-- 遍历订单商品列表 -->
            <view class="product-item" v-for="(item, index) in orderItems" :key="index">
                <!-- 商品图片 -->
                <view class="product-image">
                    <image :src="item.image" mode="aspectFill"/>
                </view>
                <!-- 商品信息 -->
                <view class="product-info">
                    <view class="product-name">{{ item.name }}</view>
                    <view class="product-price-quantity">
                        <text class="price">¥{{ item.price }}</text>
                        <text class="quantity">x{{ item.quantity.toFixed(2) }}</text>
                    </view>
                </view>
            </view>
        </view>

        <!-- 订单备注区域 -->
        <view class="order-remark-section">
            <view class="section-title">订单备注</view>
            <textarea class="remark-input"
                      placeholder="请输入订单备注(可选)"
                      v-model="orderRemark"
                      maxlength="100"
            />
        </view>

        <!-- 底部结算栏 -->
        <view class="order-footer">
            <!-- 总金额 -->
            <view class="total-amount">
                总价:
                <text class="amount">¥{{ totalAmount.toFixed(2) }}</text>
            </view>
            <!-- 结算按钮 -->
            <button class="submit-order-btn" @click="settlement">
                结算
            </button>
        </view>

        <!-- 地址选择弹窗 -->
        <uni-popup ref="addressPopup" type="bottom">
            <view class="address-picker-container">
                <view class="popup-header">
                    <text class="header-title">选择收货地址</text>
                    <view class="close-icon" @click="closeAddressPopup">
                        <uni-icons type="closeempty" size="20" color="#999"></uni-icons>
                    </view>
                </view>

                <scroll-view class="address-list" scroll-y>
                    <view
                            class="address-item"
                            v-for="(address, index) in addressList"
                            :key="address.addressId"
                    >
                        <view class="address-info" @click="selectAddressItem(address)">
                            <view class="contact-info">
                                <text class="name">{{ address.name }}</text>
                                <text class="phone">{{ address.phone }}</text>
                            </view>
                            <view class="address-detail">
                                {{ address.detail }}
                            </view>
                        </view>

                        <view class="address-actions">
                            <view class="use-btn" @click="selectAddressItem(address)">
                                使用
                            </view>
                            <view class="delete-btn" @click="deleteAddress(address, index)">
                                删除
                            </view>
                        </view>
                    </view>

                    <view class="add-new-address" @click="addNewAddressFromPopup">
                        <uni-icons type="plusempty" size="18" color="#ff5339"></uni-icons>
                        <text class="add-text">新增收货地址</text>
                    </view>
                </scroll-view>
            </view>
        </uni-popup>

        <!-- 新增收货地址弹窗组件 -->
        <AddAddress ref="addAddressRef" @ok="getNewAddress"/>
    </view>
</template>

<script setup>
import {ref} from 'vue'
import {onLoad} from "@dcloudio/uni-app";
import {delAddress, selectMyAddressList} from "@/pages/api/snack/address";
import AddAddress from "@/pages/order/AddAddress.vue";
import {addOrder} from "@/pages/api/snack/order";
import {delCart} from "@/pages/api/snack/cart";

//新增收货地址组件实例
const addAddressRef = ref(null)
const addressPopup = ref(null)

//订单商品数据
const orderItems = ref([])
//订单总金额
const totalAmount = ref(0)
//当前选中的地址
const selectedAddress = ref(null)
//收货地址列表数据
const addressList = ref([])
//订单备注信息
const orderRemark = ref('')

//新增地址
const addAddress = () => {
    addAddressRef.value.insertAddress()
}

// 从弹窗中新增地址
const addNewAddressFromPopup = () => {
    closeAddressPopup()
    addAddress()
}

//获取新地址的回调函数
const getNewAddress = (newAddress) => {
    //将获取到的新地址设置为当前选中地址
    selectedAddress.value = newAddress
    //将新地址添加至地址列表中
    addressList.value.push({
        addressId: addressList.value.length + 1,
        ...newAddress
    })
}

//页面加载时调用
onLoad((options) => {
    //解析传入的商品数据
    if (options.items) {
        //解析并且解码商品数据
        orderItems.value = JSON.parse(decodeURIComponent(options.items));
    }

    //解析传入的总金额
    if (options.total) {
        totalAmount.value = parseFloat(options.total)
    }

    //查询个人的收货地址列表
    selectMyAddressList().then(res => {
        addressList.value = res.data
        //设置默认地址(优先使用默认地址, 否则使用第一个地址)
        const defaultAddress = addressList.value.find(addr => addr.isDefault)
        if (defaultAddress) {
            selectedAddress.value = defaultAddress
        } else if (addressList.value.length > 0) {
            selectedAddress.value = addressList.value[0]
        }
    })
})

//选择地址函数
const selectAddress = () => {
    //如果没有地址且地址列表为空, 提示用户添加地址
    if (!selectedAddress.value && addressList.value.length === 0) {
        uni.showModal({
            title: '提示',
            content: '您还没有收货地址, 请先添加收货地址',
            confirmText: '去添加',
            cancelText: '取消',
            success: (res) => {
                if (res.confirm) {
                    addAddress()
                }
            }
        })
        return
    }
    //如果有地址, 就显示地址选择弹窗
    openAddressPopup()
}

//打开地址选择弹窗
const openAddressPopup = () => {
    addressPopup.value.open()
}

//关闭地址选择弹窗
const closeAddressPopup = () => {
    addressPopup.value.close()
}

//在弹窗中选择地址
const selectAddressItem = (address) => {
    selectedAddress.value = address
    closeAddressPopup()
}

//在弹窗中删除地址
const deleteAddress = (address, index) => {
    uni.showModal({
        title: '确认删除',
        content: `确定要删除 ${address.name} 的收货地址吗？`,
        success: (res) => {
            if (res.confirm) {
                // 调用删除地址API
                delAddress(address.addressId).then(response => {
                    // 从地址列表中移除
                    addressList.value.splice(index, 1);

                    // 如果删除的是当前选中地址，更新选中状态
                    if (selectedAddress.value && selectedAddress.value.addressId === address.addressId) {
                        // 设置为列表中的第一个地址或清空
                        selectedAddress.value = addressList.value.length > 0
                            ? addressList.value[0]
                            : null;
                    }

                    uni.showToast({
                        title: '删除成功',
                        icon: 'success'
                    });
                })
            }
        }
    });
}

//结算
const settlement = () => {
    //验证是否选择了收货地址
    if (!selectedAddress.value) {
        uni.showToast({
            title: '请选择收货地址',
            icon: "none"
        })
        return
    }

    //显示加载提示
    uni.showLoading({
        title: '提交中'
    })
    uni.hideLoading()

    //准备订单数据
    const orderData = {
        name: selectedAddress.value.name,
        phone: selectedAddress.value.phone,
        address: selectedAddress.value.detail,
        totalAmount: totalAmount.value,
        productCount: orderItems.value.reduce((count, item) => count + item.quantity, 0),
        remark: orderRemark.value,
        orderProductsList: orderItems.value.map(item => ({
            cartId: item.cartId,
            name: item.name,
            price: item.price,
            quantity: item.quantity,
            image: item.image,
        }))
    }

    //提交订单
    addOrder(orderData).then(res => {
        //结算时将已结算的商品从该用户购物车中移除
        const cartIds = orderData.orderProductsList.map(item => item.cartId.toString())
        delCart(cartIds).then(res => {
            //显示成功提示
            uni.showModal({
                title: '结算完成',
                content: `订单金额: ¥${totalAmount.value.toFixed(2)}`,
                showCancel: false,
                confirmText: '我知道了',
                success: (res) => {
                    if (res.confirm) {
                        //跳转到订单页
                        uni.switchTab({
                            url: '/pages/order/index'
                        })
                    }
                }
            })
        })
    })
}

</script>

<style scoped>
/* 页面基础样式 */
page {
    /* 设置页面背景色 */
    background-color: #f8f9fa;
    /* 底部内边距，避免内容被底部栏遮挡 */
    padding-bottom: 100px;
}

/* 订单确认容器样式 */
.order-confirm-container {
    /* 容器样式会在子元素中定义 */
}

/* 地址部分样式 */
.address-section {
    /* 白色背景 */
    background-color: #fff;
    /* 外边距 */
    margin: 10px;
    /* 内边距 */
    padding: 15px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 阴影效果 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 地址内容区域样式 */
.address-content {
    /* 弹性布局 */
    display: flex;
    /* 垂直居中 */
    align-items: center;
    /* 两端对齐 */
    justify-content: space-between;
}

/* 地址信息区域样式 */
.address-info {
    /* 占据剩余空间 */
    flex: 1;
}

/* 联系人信息样式 */
.contact-info {
    /* 底部外边距 */
    margin-bottom: 5px;
}

/* 收货人姓名样式 */
.name {
    /* 字体大小 */
    font-size: 16px;
    /* 字体粗细 */
    font-weight: bold;
    /* 字体颜色 */
    color: #333;
    /* 右侧外边距 */
    margin-right: 15px;
}

/* 电话号码样式 */
.phone {
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #666;
}

/* 详细地址样式 */
.address-detail {
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #666;
    /* 行高 */
    line-height: 1.4;
}

/* 地址占位符样式 */
.address-placeholder {
    /* 弹性布局 */
    display: flex;
    /* 垂直居中 */
    align-items: center;
    /* 两端对齐 */
    justify-content: space-between;
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #999;
}

/* 添加地址部分样式 */
.add-address-section {
    /* 白色背景 */
    background-color: #fff;
    /* 外边距：上0 左右10px 下10px */
    margin: 0 10px 10px;
    /* 内边距 */
    padding: 15px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 阴影效果 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 添加地址按钮样式 */
.add-address-btn {
    /* 弹性布局 */
    display: flex;
    /* 垂直居中 */
    align-items: center;
    /* 水平居中 */
    justify-content: center;
}

/* 添加地址文字样式 */
.add-text {
    /* 左侧外边距 */
    margin-left: 5px;
    /* 字体大小 */
    font-size: 14px;
    /* 主题红色 */
    color: #ff5339;
}

/* 商品部分样式 */
.products-section {
    /* 白色背景 */
    background-color: #fff;
    /* 外边距 */
    margin: 10px;
    /* 内边距 */
    padding: 15px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 阴影效果 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 区域标题样式 */
.section-title {
    /* 字体大小 */
    font-size: 16px;
    /* 字体粗细 */
    font-weight: bold;
    /* 字体颜色 */
    color: #333;
    /* 底部外边距 */
    margin-bottom: 15px;
    /* 底部内边距 */
    padding-bottom: 10px;
    /* 底部边框 */
    border-bottom: 1px solid #f0f0f0;
}

/* 商品项样式 */
.product-item {
    /* 弹性布局 */
    display: flex;
    /* 底部外边距 */
    margin-bottom: 15px;
}

/* 最后一个商品项去掉底部外边距 */
.product-item:last-child {
    margin-bottom: 0;
}

/* 商品图片容器样式 */
.product-image {
    /* 固定宽度 */
    width: 80px;
    /* 固定高度 */
    height: 80px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 隐藏溢出内容 */
    overflow: hidden;
    /* 右侧外边距 */
    margin-right: 10px;
}

/* 商品图片样式 */
.product-image image {
    /* 宽度100%填充容器 */
    width: 100%;
    /* 高度100%填充容器 */
    height: 100%;
}

/* 商品信息区域样式 */
.product-info {
    /* 占据剩余空间 */
    flex: 1;
    /* 弹性布局，垂直方向排列 */
    display: flex;
    flex-direction: column;
    /* 两端对齐 */
    justify-content: space-between;
}

/* 商品名称样式 */
.product-name {
    /* 字体大小 */
    font-size: 15px;
    /* 字体颜色 */
    color: #333;
    /* 行高 */
    line-height: 1.3;
    /* 底部外边距 */
    margin-bottom: 5px;
}

/* 商品规格样式 */
.product-specs {
    /* 字体大小 */
    font-size: 12px;
    /* 字体颜色 */
    color: #999;
    /* 底部外边距 */
    margin-bottom: 10px;
}

/* 价格和数量区域样式 */
.product-price-quantity {
    /* 弹性布局 */
    display: flex;
    /* 两端对齐 */
    justify-content: space-between;
    /* 垂直居中 */
    align-items: center;
}

/* 价格样式 */
.price {
    /* 字体大小 */
    font-size: 16px;
    /* 主题红色 */
    color: #ff5339;
    /* 字体粗细 */
    font-weight: bold;
}

/* 数量样式 */
.quantity {
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #666;
}

/* 订单金额部分样式 */
.order-amount-section {
    /* 白色背景 */
    background-color: #fff;
    /* 外边距 */
    margin: 10px;
    /* 内边距 */
    padding: 15px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 阴影效果 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 金额项样式 */
.amount-item {
    /* 弹性布局 */
    display: flex;
    /* 两端对齐 */
    justify-content: space-between;
    /* 垂直居中 */
    align-items: center;
    /* 底部外边距 */
    margin-bottom: 10px;
}

/* 最后一个金额项去掉底部外边距 */
.amount-item:last-child {
    margin-bottom: 0;
}

/* 金额标签样式 */
.label {
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #666;
}

/* 金额数值样式 */
.value {
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #333;
}

/* 订单备注部分样式 */
.order-remark-section {
    /* 白色背景 */
    background-color: #fff;
    /* 外边距 */
    margin: 10px;
    /* 内边距 */
    padding: 15px;
    /* 圆角边框 */
    border-radius: 8px;
    /* 阴影效果 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
}

/* 备注输入框样式 */
.remark-input {
    /* 宽度100% */
    width: 100%;
    /* 固定高度 */
    height: 80px;
    /* 内边距 */
    padding: 10px;
    /* 浅灰色背景 */
    background-color: #f8f9fa;
    /* 圆角边框 */
    border-radius: 8px;
    /* 字体大小 */
    font-size: 14px;
    /* 字体颜色 */
    color: #333;
}

/* 订单底部样式 */
.order-footer {
    /* 固定定位在底部 */
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    /* 固定高度 */
    height: 60px;
    /* 白色背景 */
    background-color: #fff;
    /* 弹性布局 */
    display: flex;
    /* 垂直居中 */
    align-items: center;
    /* 左右内边距 */
    padding: 0 15px;
    /* 顶部阴影 */
    box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

/* 总金额显示样式 */
.total-amount {
    /* 占据剩余空间 */
    flex: 1;
    /* 字体大小 */
    font-size: 16px;
    /* 字体颜色 */
    color: #333;
}

/* 金额数字样式 */
.amount {
    /* 字体大小 */
    font-size: 20px;
    /* 主题红色 */
    color: #ff5339;
    /* 字体粗细 */
    font-weight: bold;
}

/* 提交订单按钮样式 */
.submit-order-btn {
    /* 固定宽度 */
    width: 120px;
    /* 固定高度 */
    height: 40px;
    /* 渐变背景色 */
    background: linear-gradient(135deg, #ff6b81, #ff4757);
    /* 白色文字 */
    color: #fff;
    /* 圆角边框 */
    border-radius: 20px;
    /* 字体大小 */
    font-size: 16px;
    /* 字体粗细 */
    font-weight: bold;
}

/* 地址选择弹窗样式 */
.address-picker-container {
    background-color: #fff;
    border-top-left-radius: 15px;
    border-top-right-radius: 15px;
    max-height: 70vh;
    overflow: hidden;
}

.popup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    border-bottom: 1px solid #f0f0f0;
}

.header-title {
    font-size: 16px;
    font-weight: bold;
    color: #333;
}

.close-icon {
    padding: 5px;
}

.address-list {
    max-height: 60vh;
    padding: 10px 15px;
}

.address-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid #f0f0f0;
}

.address-item:last-child {
    border-bottom: none;
}

.address-info {
    flex: 1;
    padding-right: 10px;
}

.use-btn {
    padding: 5px 15px;
    background-color: #ff5339;
    color: white;
    border-radius: 15px;
    font-size: 14px;
    margin-right: 10px;
}

.delete-btn {
    padding: 5px 15px;
    border: 1px solid #ff5339;
    color: #ff5339;
    border-radius: 15px;
    font-size: 14px;
}

.add-new-address {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px 0;
    color: #ff5339;
}

.add-text {
    margin-left: 5px;
    font-size: 14px;
}
</style>
