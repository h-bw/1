import request from '@/utils/request'

// 查询商品总数 订单总数 分类总数
export function selectDataInfo() {
    return request({
        url: '/home/page/selectDataInfo',
        method: 'get'
    })
}

// 商品分类统计(商品数量对应商品分类名称)
export function selectCategoryChart() {
    return request({
        url: '/home/page/selectCategoryChart',
        method: 'get'
    })
}

// 订单状态统计(状态对应数量)
export function selectOrderStatusCount() {
    return request({
        url: '/home/page/selectOrderStatusCount',
        method: 'get'
    })
}
