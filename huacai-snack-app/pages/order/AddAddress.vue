<template>
    <view>
        <!-- 新增收货地址弹窗 -->
        <uni-popup ref="addAddressRef" type="bottom" background-color="#fff">
            <view class="add-address-popup">
                <!-- 弹窗头部 -->
                <view class="popup-header">
                    <text class="header-title">新增收货地址</text>
                    <uni-icons type="closeempty" size="20" color="#999" @click="closeAddAddressPopup"/>
                </view>

                <!-- 表单 -->
                <view class="popup-content">
                    <!-- 收货人姓名 -->
                    <view class="form-item">
                        <text class="label">收货人</text>
                        <input class="input" placeholder="请输入收货人姓名" v-model="form.name" maxlength="20"/>
                    </view>

                    <!-- 收货人手机号码 -->
                    <view class="form-item">
                        <text class="label">手机号码</text>
                        <input class="input" placeholder="请输入手机号码" v-model="form.phone" maxlength="20"
                               type="number"/>
                    </view>

                    <!-- 收货人详细地址 -->
                    <view class="form-item">
                        <text class="label">详细地址</text>
                        <input class="textarea"
                               placeholder="请输入详细地址信息, 如道路 小区 单元等信息"
                               v-model="form.detail"/>
                    </view>

                    <!-- 是否默认地址 -->
                    <view class="form-item switch-item">
                        <text class="label">设为默认地址</text>
                        <switch :checked="form.isDefault" @change="onDefaultAddressChange"/>
                    </view>
                </view>

                <!-- 弹窗底部 -->
                <view class="popup-footer">
                    <button class="cancel-btn" @click="closeAddAddressPopup">取消</button>
                    <button class="save-btn" @click="saveAddress">确定</button>
                </view>

            </view>
        </uni-popup>
    </view>
</template>

<script setup>
import {ref} from 'vue'
import {addAddress} from "@/pages/api/snack/address";

//弹窗引用, 用来控制弹窗是否打开
const addAddressRef = ref(null)

//表单参数
const form = ref({
    name: '',
    phone: '',
    detail: '',
    isDefault: true
})

//关闭弹窗
const closeAddAddressPopup = () => {
    addAddressRef.value.close()
}

//默认地址开关变更事件
const onDefaultAddressChange = (e) => {
    form.value.isDefault = e.detail.value
}

//添加地址
const insertAddress = () => {
    //清空表单数据, 重置为初始状态
    form.value = {
        name: '',
        phone: '',
        detail: '',
        isDefault: true
    }
    //打开弹窗
    addAddressRef.value.open()
}

//定义一个可触发的事件
const emit = defineEmits(['ok'])

//保存地址
const saveAddress = () => {
    //调用api新增地址
    addAddress(form.value).then(res => {
        //地址添加完之后, 向父组件触发'ok'事件, 并且将新地址数据传参给父组件
        emit('ok', form.value)

        //关闭弹窗
        closeAddAddressPopup()

        //成功提示
        uni.showToast({
            title: '地址添加成功',
            icon: "success"
        })
    })
}

//暴露方法给父组件使用
defineExpose({
    insertAddress
})
</script>

<style scoped>
/* 弹窗容器样式 */
.add-address-popup {
    padding: 20px; /* 内边距 */
    min-height: 300px; /* 最小高度，确保弹窗有足够空间 */
}

/* 弹窗头部样式 */
.popup-header {
    display: flex; /* 使用flex布局 */
    justify-content: space-between; /* 两端对齐：标题在左，关闭按钮在右 */
    align-items: center; /* 垂直居中 */
    padding-bottom: 15px; /* 底部内边距 */
    border-bottom: 1px solid #eee; /* 底部边框，用于分隔头部和内容 */
}

/* 头部标题样式 */
.header-title {
    font-size: 18px; /* 字体大小 */
    font-weight: bold; /* 字体粗细：粗体 */
    color: #333; /* 字体颜色：深灰色 */
}

/* 弹窗内容区域样式 */
.popup-content {
    padding: 15px 0; /* 上下内边距15px，左右无内边距 */
}

/* 表单项目通用样式 */
.form-item {
    margin-bottom: 20px; /* 底部外边距，创建项目间距 */
    display: flex; /* 使用flex布局 */
    flex-direction: column; /* 垂直排列：标签在上，输入框在下 */
}

/* 表单标签样式 */
.label {
    font-size: 14px; /* 字体大小 */
    color: #333; /* 字体颜色：深灰色 */
    margin-bottom: 8px; /* 底部外边距，与输入框保持距离 */
}

/* 输入框和文本域通用样式 */
.input, .textarea {
    padding: 10px; /* 内边距 */
    border: 1px solid #eee; /* 边框：浅灰色细边框 */
    border-radius: 4px; /* 圆角边框 */
    font-size: 14px; /* 字体大小 */
    background-color: #f8f9fa; /* 背景色：浅灰色 */
}

/* 输入框特定样式 */
.input {
    height: 40px; /* 固定高度 */
}

/* 文本域特定样式 */
.textarea {
    height: 80px; /* 固定高度，比普通输入框高 */
    width: 100%; /* 宽度100%，填充父容器 */
}

/* 开关项目的特殊样式 */
.form-item.switch-item {
    flex-direction: row; /* 水平排列：标签在左，开关在右 */
    justify-content: space-between; /* 两端对齐 */
    align-items: center; /* 垂直居中 */
}

/* 弹窗底部样式 */
.popup-footer {
    display: flex; /* 使用flex布局 */
    justify-content: space-between; /* 两端对齐：取消按钮在左，保存按钮在右 */
    padding-top: 15px; /* 顶部内边距 */
    border-top: 1px solid #eee; /* 顶部边框，用于分隔内容和底部 */
}

/* 取消和保存按钮通用样式 */
.cancel-btn, .save-btn {
    flex: 1; /* 弹性布局，两个按钮平均分配宽度 */
    height: 40px; /* 固定高度 */
    border-radius: 4px; /* 圆角边框 */
    font-size: 16px; /* 字体大小 */
}

/* 取消按钮特定样式 */
.cancel-btn {
    background-color: #fff; /* 背景色：白色 */
    border: 1px solid #ddd; /* 边框：灰色 */
    color: #666; /* 字体颜色：中灰色 */
    margin-right: 10px; /* 右外边距，与保存按钮保持距离 */
}

/* 保存按钮特定样式 */
.save-btn {
    /* 渐变背景：从粉红色到红色 */
    background: linear-gradient(135deg, #ff6b81, #ff4757);
    color: #fff; /* 字体颜色：白色 */
    border: none; /* 无边框 */
}
</style>
