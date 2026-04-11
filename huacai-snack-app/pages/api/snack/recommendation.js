import request from '@/utils/request'

// 获取推荐商品列表
export function getAdvancedRecommendationsForUser() {
    return request({
        url: '/snack/recommendation/advanced',
        method: 'get'
    })
}
