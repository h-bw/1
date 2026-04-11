<template>
  <!-- 主页仪表盘主容器 -->
    <div class="dashboard">
        <!-- 欢迎信息区域 -->
        <div class="welcome-message">
            <h2>欢迎访问零食商城管理端</h2>
        </div>

        <!-- 数据卡片 -->
        <el-row :gutter="20" class="dashboard-row">
            <el-col :span="8">
                <!-- 商品总数卡片 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-icon bg-primary">
                        <el-icon>
                            <ShoppingCart/>
                        </el-icon>
                    </div>
                    <!-- 卡片内容区域 -->
                    <div class="dashboard-card-content">
                        <div class="dashboard-card-label">商品总数</div>
                        <div class="dashboard-card-value">{{ productCount }}</div>
                    </div>
                </div>
            </el-col>
            <el-col :span="8">
                <!-- 订单总数卡片 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-icon bg-success">
                        <el-icon>
                            <ShoppingCart/>
                        </el-icon>
                    </div>
                    <!-- 卡片内容区域 -->
                    <div class="dashboard-card-content">
                        <div class="dashboard-card-label">订单总数</div>
                        <div class="dashboard-card-value">{{ orderCount }}</div>
                    </div>
                </div>
            </el-col>
            <el-col :span="8">
                <!-- 分类总数卡片 -->
                <div class="dashboard-card">
                    <div class="dashboard-card-icon bg-warning">
                        <el-icon>
                            <ShoppingCart/>
                        </el-icon>
                    </div>
                    <!-- 卡片内容区域 -->
                    <div class="dashboard-card-content">
                        <div class="dashboard-card-label">分类总数</div>
                        <div class="dashboard-card-value">{{ categoryCount }}</div>
                    </div>
                </div>
            </el-col>
        </el-row>

        <el-row :gutter="20" class="dashboard-row">
            <el-col :span="12">
                <!-- 商品分类统计图表容器 -->
                <div class="dashboard-chart">
                    <div class="dashboard-chart-header">
                        <span>商品分类统计</span>
                    </div>
                    <div class="dashboard-chart-body">
                        <div ref="categoryChart" style="width: 100%; height: 400px;"></div>
                    </div>
                </div>
            </el-col>

            <el-col :span="12">
                <!-- 订单状态统计图表容器 -->
                <div class="dashboard-chart">
                    <div class="dashboard-chart-header">
                        <span>订单状态统计</span>
                    </div>
                    <div class="dashboard-chart-body">
                        <div ref="orderChart" style="width: 100%; height: 400px;"></div>
                    </div>
                </div>
            </el-col>
        </el-row>


    </div>
</template>

<script setup>
import {onMounted, ref} from 'vue'
import {selectCategoryChart, selectDataInfo, selectOrderStatusCount} from "@/api/snack/homePage.js";
import {ShoppingCart} from "@element-plus/icons-vue";
import * as echarts from 'echarts'

//商品总数
const productCount = ref(0)
//订单总数
const orderCount = ref(0)
//分类总数
const categoryCount = ref(0)

//商品分类数量数据
const categoryChartData = ref([])
//订单状态数据
const orderStatusChartData = ref([])

const categoryChart = ref(null)
const orderChart = ref(null)

//加载数据
const loadData = () => {
    //查询商品总数 订单总数 分类总数
    selectDataInfo().then(res => {
        productCount.value = res.data.productCount
        orderCount.value = res.data.orderCount
        categoryCount.value = res.data.categoryCount
    })

    //获取商品分类图表数据
    selectCategoryChart().then(res => {
        categoryChartData.value = res.data

        selectOrderStatusCount().then(res => {
            orderStatusChartData.value = res.data
            //数据加载完后初始化图表
            initCharts()
        })
    })
}

//初始化图表
const initCharts = () => {
    // 商品分类统计图
    const categoryChartInstance = echarts.init(categoryChart.value)
    const categoryOption = {
        tooltip: {
            trigger: 'item'
        },
        legend: {
            bottom: 'bottom'
        },
        series: [
            {
                name: '商品分类',
                type: 'pie',
                radius: ['40%', '70%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    borderRadius: 10,
                    borderColor: '#fff',
                    borderWidth: 2
                },
                label: {
                    show: false,
                    position: 'center'
                },
                emphasis: {
                    label: {
                        show: true,
                        fontSize: '18',
                        fontWeight: 'bold'
                    }
                },
                labelLine: {
                    show: false
                },
                data: categoryChartData.value
            }
        ]
    }
    categoryChartInstance.setOption(categoryOption)

    // 订单状态统计图
    const orderChartInstance = echarts.init(orderChart.value)
    const orderOption = {
        tooltip: {  // 提示框配置
            trigger: 'axis'  // 坐标轴触发
        },
        legend: {   // 图例配置
            bottom: 'bottom' // 图例位置在底部
        },
        xAxis: {    // X轴配置
            type: 'category',   // 类目轴
            data: orderStatusChartData.value.statusList  // X轴数据（订单状态列表）
        },
        yAxis: {    // Y轴配置
            type: 'value'       // 数值轴
        },
        series: [
            {
                name: '订单数量',  // 系列名称
                data: orderStatusChartData.value.countList,  // 系列数据（订单数量列表）
                type: 'bar',    // 柱状图类型
                itemStyle: {    // 图形样式
                    // 渐变颜色配置
                    color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                        {offset: 0, color: '#83bff6'},  // 0%位置的颜色
                        {offset: 0.5, color: '#188df0'}, // 50%位置的颜色
                        {offset: 1, color: '#188df0'}   // 100%位置的颜色
                    ])
                }
            }
        ]
    }
    orderChartInstance.setOption(orderOption)

    // 监听窗口大小变化，自适应图表
    window.addEventListener('resize', () => {
        categoryChartInstance.resize()
        orderChartInstance.resize()
    })
}

//组件挂载完成后执行
onMounted(() => {
    //加载数据
    loadData()
})

</script>

<style scoped>
/* 仪表盘主容器样式 */
.dashboard {
    padding: 20px; /* 内边距 */
    background-color: #f5f7fa; /* 背景颜色 - 浅灰色 */
}

/* 欢迎信息区域样式 */
.welcome-message {
    text-align: center; /* 文字居中 */
    padding: 20px; /* 内边距 */
    margin-bottom: 20px; /* 底部外边距 */
    /* 渐变背景：从浅蓝色到深蓝色，135度角度 */
    background: linear-gradient(135deg, #69a3e1 0%, #0b6fda 100%);
    border-radius: 8px; /* 圆角 */
    /* 盒子阴影：水平偏移0，垂直偏移2px，模糊半径12px，扩展半径0，半透明黑色 */
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    color: white; /* 文字颜色白色 */
}

/* 欢迎信息标题样式 */
.welcome-message h2 {
    margin: 0; /* 清除默认外边距 */
    font-size: 30px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
}

/* 仪表盘行样式 */
.dashboard-row {
    margin-bottom: 15px; /* 底部外边距 */
}

/* 数据卡片样式 */
.dashboard-card {
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中对齐 */
    background: #fff; /* 背景白色 */
    border-radius: 8px; /* 圆角 */
    padding: 20px; /* 内边距 */
    /* 盒子阴影 */
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    transition: box-shadow 0.3s ease; /* 阴影过渡动画，0.3秒缓动效果 */
}

/* 卡片悬停效果 */
.dashboard-card:hover {
    /* 悬停时加深阴影 */
    box-shadow: 0 4px 20px 0 rgba(0, 0, 0, 0.15);
}

/* 卡片图标容器样式 */
.dashboard-card-icon {
    width: 60px; /* 固定宽度 */
    height: 60px; /* 固定高度 */
    border-radius: 8px; /* 圆角 */
    display: flex; /* 弹性布局 */
    align-items: center; /* 垂直居中 */
    justify-content: center; /* 水平居中 */
    margin-right: 15px; /* 右侧外边距 */
}

/* 卡片图标样式 */
.dashboard-card-icon i {
    font-size: 30px; /* 图标大小 */
    color: #fff; /* 图标颜色白色 */
}

/* 主要颜色样式类 */
.dashboard-card-icon.bg-primary {
    background: #409eff; /* Element Plus 主要蓝色 */
}

/* 成功颜色样式类 */
.dashboard-card-icon.bg-success {
    background: #67c23a; /* Element Plus 成功绿色 */
}

/* 警告颜色样式类 */
.dashboard-card-icon.bg-warning {
    background: #e6a23c; /* Element Plus 警告橙色 */
}

/* 危险颜色样式类 */
.dashboard-card-icon.bg-danger {
    background: #f56c6c; /* Element Plus 危险红色 */
}

/* 卡片内容区域样式 */
.dashboard-card-content {
    flex: 1; /* 占据剩余空间 */
}

/* 卡片标签文字样式 */
.dashboard-card-label {
    font-size: 14px; /* 字体大小 */
    color: #606266; /* 文字颜色 - 中等灰色 */
    margin-bottom: 5px; /* 底部外边距 */
}

/* 卡片数值样式 */
.dashboard-card-value {
    font-size: 24px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
    color: #303133; /* 文字颜色 - 深灰色 */
}

/* 图表容器样式 */
.dashboard-chart {
    background: #fff; /* 背景白色 */
    border-radius: 8px; /* 圆角 */
    /* 盒子阴影 */
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 表格容器样式（虽然模板中未使用，但CSS中定义了） */
.dashboard-table {
    background: #fff; /* 背景白色 */
    border-radius: 8px; /* 圆角 */
    /* 盒子阴影 */
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

/* 图表头部样式 */
.dashboard-chart-header {
    padding: 20px; /* 内边距 */
    border-bottom: 1px solid #ebeef5; /* 底部边框 - 浅灰色 */
    font-size: 16px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
    color: #303133; /* 文字颜色 - 深灰色 */
}

/* 表格头部样式（虽然模板中未使用，但CSS中定义了） */
.dashboard-table-header {
    padding: 20px; /* 内边距 */
    border-bottom: 1px solid #ebeef5; /* 底部边框 */
    font-size: 16px; /* 字体大小 */
    font-weight: bold; /* 字体粗细 */
    color: #303133; /* 文字颜色 */
}

/* 图表主体样式 */
.dashboard-chart-body {
    padding: 20px; /* 内边距 */
}

/* 表格主体样式（虽然模板中未使用，但CSS中定义了） */
.dashboard-table-body {
    padding: 20px; /* 内边距 */
}
</style>
