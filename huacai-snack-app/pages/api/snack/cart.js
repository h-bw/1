import request from '@/utils/request'

// 查询购物车列表
export function listCart(query) {
  return request({
    url: '/snack/cart/list',
    method: 'get',
    params: query
  })
}

// 查询购物车详细
export function getCart(cartId) {
  return request({
    url: '/snack/cart/' + cartId,
    method: 'get'
  })
}

// 新增购物车
export function addCart(data) {
  return request({
    url: '/snack/cart',
    method: 'post',
    data: data
  })
}

// 修改购物车
export function updateCart(data) {
  return request({
    url: '/snack/cart',
    method: 'put',
    data: data
  })
}

// 删除购物车
export function delCart(cartId) {
  return request({
    url: '/snack/cart/' + cartId,
    method: 'delete'
  })
}

// 查询个人的购物车数据
export function selectMyCartList() {
  return request({
    url: '/snack/cart/selectMyCartList',
    method: 'get'
  })
}

// 增加商品数量
export function increaseQuantity(cartId) {
  return request({
    url: '/snack/cart/increaseQuantity/' + cartId,
    method: 'put'
  })
}

// 减少商品数量
export function reduceQuantity(cartId) {
  return request({
    url: '/snack/cart/reduceQuantity/' + cartId,
    method: 'put'
  })
}

// 将商品添加至购物车
export function addProductToCart(productId) {
  return request({
    url: '/snack/cart/addProductToCart/' + productId,
    method: 'put'
  })
}
