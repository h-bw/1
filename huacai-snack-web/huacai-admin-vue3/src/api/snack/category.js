import request from '@/utils/request'

// 查询零食分类列表
export function listCategory(query) {
  return request({
    url: '/snack/category/list',
    method: 'get',
    params: query
  })
}

// 查询零食分类详细
export function getCategory(categoryId) {
  return request({
    url: '/snack/category/' + categoryId,
    method: 'get'
  })
}

// 新增零食分类
export function addCategory(data) {
  return request({
    url: '/snack/category',
    method: 'post',
    data: data
  })
}

// 修改零食分类
export function updateCategory(data) {
  return request({
    url: '/snack/category',
    method: 'put',
    data: data
  })
}

// 删除零食分类
export function delCategory(categoryId) {
  return request({
    url: '/snack/category/' + categoryId,
    method: 'delete'
  })
}

// 不分页查询分类名称列表
export function selectAllCategoryNameList() {
  return request({
    url: '/snack/category/selectAllCategoryNameList',
    method: 'get'
  })
}
