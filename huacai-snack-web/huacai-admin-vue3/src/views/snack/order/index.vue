<template>
    <div class="app-container">
        <!-- 顶部搜索 -->
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
            <el-form-item label="订单号" prop="orderId">
                <el-input
                        v-model="queryParams.orderId"
                        placeholder="请输入订单号"
                        clearable
                        @keyup.enter="handleQuery"
                />
            </el-form-item>
            <el-form-item label="订单状态" prop="status">
                <el-select style="width: 200px;" v-model="queryParams.status" placeholder="请选择订单状态" clearable>
                    <el-option
                            v-for="dict in order_status"
                            :key="dict.value"
                            :label="dict.label"
                            :value="dict.value"
                    />
                </el-select>
            </el-form-item>
            <el-form-item label="下单用户名" prop="userName">
                <el-input
                        v-model="queryParams.userName"
                        placeholder="请输入下单用户名"
                        clearable
                        @keyup.enter="handleQuery"
                />
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <!-- 顶部按钮 -->
        <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
                <el-button
                        type="primary"
                        plain
                        icon="Plus"
                        @click="handleAdd"
                        v-hasPermi="['snack:order:add']"
                >新增
                </el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button
                        type="success"
                        plain
                        icon="Edit"
                        :disabled="single"
                        @click="handleUpdate"
                        v-hasPermi="['snack:order:edit']"
                >修改
                </el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button
                        type="danger"
                        plain
                        icon="Delete"
                        :disabled="multiple"
                        @click="handleDelete"
                        v-hasPermi="['snack:order:remove']"
                >删除
                </el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button
                        type="warning"
                        plain
                        icon="Download"
                        @click="handleExport"
                        v-hasPermi="['snack:order:export']"
                >导出
                </el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button
                        type="primary"
                        icon="Upload"
                        size="mini"
                        @click="handleImport"
                >导入
                </el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>

        <!-- 表格 -->
        <el-table @row-click="clickRow" ref="table" highlight-current-row
                  border v-loading="loading" :data="orderList" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" align="center"/>
            <el-table-column label="序号" align="center" type="index" :index="indexMethod"/>
            <el-table-column label="订单号" align="center" prop="orderId" width="180"/>
            <el-table-column label="收货人" align="center" prop="name"/>
            <el-table-column label="手机号码" align="center" prop="phone"/>
            <el-table-column label="收货地址" align="center" prop="address"/>
            <el-table-column label="合计价格" align="center" prop="totalAmount"/>
            <el-table-column label="商品件数" align="center" prop="productCount"/>
            <el-table-column label="订单状态" align="center" prop="status">
                <template #default="scope">
                    <dict-tag :options="order_status" :value="scope.row.status"/>
                </template>
            </el-table-column>
            <el-table-column label="备注" align="center" prop="remark"/>
            <el-table-column label="下单用户名" align="center" prop="userName"/>
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
                <template #default="scope">
                    <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
                               v-hasPermi="['snack:order:edit']">修改
                    </el-button>
                    <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)"
                               v-hasPermi="['snack:order:remove']">删除
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- 分页组件 -->
        <pagination
                v-show="total>0"
                :total="total"
                v-model:page="queryParams.pageNum"
                v-model:limit="queryParams.pageSize"
                @pagination="getList"
        />

        <!-- 导入对话框 -->
        <vxe-modal :title="upload.title" v-model="upload.open" width="400px" showFooter show-zoom resize>
            <el-upload
                    ref="uploadRef"
                    :limit="1"
                    accept=".xlsx, .xls"
                    :headers="upload.headers"
                    :action="upload.url"
                    :data="{ updateSupport: upload.updateSupport }"
                    :disabled="upload.isUploading"
                    :on-progress="handleFileUploadProgress"
                    :on-success="handleFileSuccess"
                    :auto-upload="false"
                    drag
            >
                <el-icon class="el-icon--upload">
                    <upload-filled/>
                </el-icon>
                <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                <template #tip>
                    <div class="el-upload__tip text-center">
                        <span>仅允许导入xls、xlsx格式文件。</span>
                        <el-link type="primary" :underline="false" style="font-size:12px;vertical-align: baseline;"
                                 @click="importTemplate">下载模板
                        </el-link>
                    </div>
                </template>
            </el-upload>
            <div slot="footer" class="dialog-footer">
                <el-button type="primary" @click="submitFileForm">确 定</el-button>
                <el-button @click="upload.open = false">取 消</el-button>
            </div>
        </vxe-modal>

        <!-- 添加或修改订单对话框 -->
        <vxe-modal :title="title" v-model="open" width="40%" show-maximize showFooter resize>
            <el-form ref="orderRef" :model="form" :rules="rules" label-width="80px">
                <el-form-item label="收货人" prop="name">
                    <el-input v-model="form.name" placeholder="请输入收货人"/>
                </el-form-item>
                <el-form-item label="手机号码" prop="phone">
                    <el-input v-model="form.phone" placeholder="请输入手机号码"/>
                </el-form-item>
                <el-form-item label="收货地址" prop="address">
                    <el-input v-model="form.address" placeholder="请输入收货地址"/>
                </el-form-item>
                <el-form-item label="合计价格" prop="totalAmount">
                    <el-input v-model="form.totalAmount" placeholder="请输入合计价格"/>
                </el-form-item>
                <el-form-item label="商品件数" prop="productCount">
                    <el-input v-model="form.productCount" placeholder="请输入商品件数"/>
                </el-form-item>
                <el-form-item label="备注" prop="remark">
                    <el-input v-model="form.remark" type="textarea" placeholder="请输入内容"/>
                </el-form-item>
                <el-divider content-position="center">订单商品明细信息</el-divider>
                <el-row :gutter="10" class="mb8">
                    <el-col :span="1.5">
                        <el-button type="primary" icon="Plus" @click="handleAddOrderProducts">添加</el-button>
                    </el-col>
                    <el-col :span="1.5">
                        <el-button type="danger" icon="Delete" @click="handleDeleteOrderProducts">删除</el-button>
                    </el-col>
                </el-row>
                <el-table :data="orderProductsList" :row-class-name="rowOrderProductsIndex"
                          @selection-change="handleOrderProductsSelectionChange" ref="orderProducts">
                    <el-table-column type="selection" width="50" align="center"/>
                    <el-table-column label="序号" align="center" prop="index" width="50"/>
                    <el-table-column label="商品名称" prop="name" width="150">
                        <template #default="scope">
                            <el-input v-model="scope.row.name" placeholder="请输入商品名称"/>
                        </template>
                    </el-table-column>
                    <el-table-column label="价格" prop="price" width="150">
                        <template #default="scope">
                            <el-input v-model="scope.row.price" placeholder="请输入价格"/>
                        </template>
                    </el-table-column>
                    <el-table-column label="数量" prop="quantity" width="150">
                        <template #default="scope">
                            <el-input v-model="scope.row.quantity" placeholder="请输入数量"/>
                        </template>
                    </el-table-column>
                </el-table>
            </el-form>
            <template #footer>
                <div class="dialog-footer">
                    <el-button type="primary" @click="submitForm">确 定</el-button>
                    <el-button @click="cancel">取 消</el-button>
                </div>
            </template>
        </vxe-modal>
    </div>
</template>

<script setup name="Order">
import {listOrder, getOrder, delOrder, addOrder, updateOrder} from "@/api/snack/order"
import {getToken} from "@/utils/auth.js";

const baseURL = import.meta.env.VITE_APP_BASE_API

const {proxy} = getCurrentInstance()
const {order_status} = proxy.useDict('order_status')

const orderList = ref([])
const orderProductsList = ref([])
const open = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const checkedOrderProducts = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const selectedRow = ref(null)

const data = reactive({
    form: {},
    queryParams: {
        pageNum: 1,
        pageSize: 10,
        orderId: null,
        status: null,
        userId: null,
        userName: null
    },
    rules: {
        name: [
            {required: true, message: "收货人不能为空", trigger: "blur"}
        ],
        phone: [
            {required: true, message: "手机号码不能为空", trigger: "blur"}
        ],
        address: [
            {required: true, message: "收货地址不能为空", trigger: "blur"}
        ],
        totalAmount: [
            {required: true, message: "合计价格不能为空", trigger: "blur"}
        ],
        productCount: [
            {required: true, message: "商品件数不能为空", trigger: "blur"}
        ],
        status: [
            {required: true, message: "订单状态不能为空", trigger: "change"}
        ],
        userId: [
            {required: true, message: "用户ID不能为空", trigger: "blur"}
        ],
        createTime: [
            {required: true, message: "下单时间不能为空", trigger: "blur"}
        ]
    },
    // 导入参数
    upload: {
        // 是否显示弹出层（导入）
        open: false,
        // 弹出层标题（导入）
        title: "",
        // 是否禁用上传
        isUploading: false,
        // 设置上传的请求头部
        headers: {Authorization: "Bearer " + getToken()},
        // 上传的地址
        url: baseURL + "/snack/order/importData"
    }
})

const {queryParams, form, rules, upload} = toRefs(data)

//点击行 获取行
const clickRow = (row) => {
    selectedRow.value = row; // 更新选中的行
    const table = proxy.$refs.table;
    // 清除所有已选中的行
    table.clearSelection();
    // 选中当前点击的行
    table.toggleRowSelection(row, true);
}

/** 自定义序号 */
const indexMethod = (index) => {
    let pageNum = queryParams.value.pageNum - 1;
    if ((pageNum !== -1 && pageNum !== 0)) {
        return (index + 1) + (pageNum * queryParams.value.pageSize);
    } else {
        return (index + 1)
    }
}

/** 查询订单列表 */
const getList = () => {
    loading.value = true
    listOrder(queryParams.value).then(response => {
        orderList.value = response.rows
        total.value = response.total
        loading.value = false
    })
}

// 取消按钮
const cancel = () => {
    open.value = false
    reset()
}

// 表单重置
const reset = () => {
    form.value = {
        orderId: null,
        name: null,
        phone: null,
        address: null,
        totalAmount: null,
        productCount: null,
        status: null,
        remark: null,
        userId: null,
        createTime: null
    }
    orderProductsList.value = []
    proxy.resetForm("orderRef")
}

/** 搜索按钮操作 */
const handleQuery = () => {
    queryParams.value.pageNum = 1
    getList()
}

/** 重置按钮操作 */
const resetQuery = () => {
    proxy.resetForm("queryRef")
    handleQuery()
}

// 多选框选中数据
const handleSelectionChange = (selection) => {
    ids.value = selection.map(item => item.orderId)
    single.value = selection.length != 1
    multiple.value = !selection.length
}

/** 新增按钮操作 */
const handleAdd = () => {
    reset()
    open.value = true
    title.value = "添加订单"
}

/** 修改按钮操作 */
const handleUpdate = (row) => {
    reset()
    const _orderId = row.orderId || ids.value
    getOrder(_orderId).then(response => {
        form.value = response.data
        orderProductsList.value = response.data.orderProductsList
        open.value = true
        title.value = "修改订单"
    })
}

/** 提交按钮 */
const submitForm = () => {
    proxy.$refs["orderRef"].validate(valid => {
        if (valid) {
            form.value.orderProductsList = orderProductsList.value
            if (form.value.orderId != null) {
                updateOrder(form.value).then(response => {
                    proxy.$modal.msgSuccess("修改成功")
                    open.value = false
                    getList()
                })
            } else {
                addOrder(form.value).then(response => {
                    proxy.$modal.msgSuccess("新增成功")
                    open.value = false
                    getList()
                })
            }
        }
    })
}

/** 删除按钮操作 */
const handleDelete = (row) => {
    const _orderIds = row.orderId || ids.value
    proxy.$modal.confirm('是否确认删除该项数据？').then(function () {
        return delOrder(_orderIds)
    }).then(() => {
        getList()
        proxy.$modal.msgSuccess("删除成功")
    }).catch(() => {
    })
}

/** 订单商品明细序号 */
const rowOrderProductsIndex = ({row, rowIndex}) => {
    row.index = rowIndex + 1
}

/** 订单商品明细添加按钮操作 */
const handleAddOrderProducts = () => {
    let obj = {}
    obj.image = ""
    obj.name = ""
    obj.price = ""
    obj.quantity = ""
    orderProductsList.value.push(obj)
}

/** 订单商品明细删除按钮操作 */
const handleDeleteOrderProducts = () => {
    if (checkedOrderProducts.value.length == 0) {
        proxy.$modal.msgError("请先选择要删除的订单商品明细数据")
    } else {
        const orderProductss = orderProductsList.value
        const checkedOrderProductss = checkedOrderProducts.value
        orderProductsList.value = orderProductss.filter(function (item) {
            return checkedOrderProductss.indexOf(item.index) == -1
        })
    }
}

/** 复选框选中数据 */
const handleOrderProductsSelectionChange = (selection) => {
    checkedOrderProducts.value = selection.map(item => item.index)
}

/** 导出按钮操作 */
const handleExport = () => {
    proxy.download('snack/order/export', {
        ...queryParams.value
    }, `order_${new Date().getTime()}.xlsx`)
}

/** 下载模板操作 */
const importTemplate = () => {
    proxy.download('snack/order/importTemplate', {}, `template_${new Date().getTime()}.xlsx`)
}

/** 导入按钮操作 */
const handleImport = () => {
    upload.value.title = "订单导入";
    upload.value.open = true;
}

// 文件上传中处理
const handleFileUploadProgress = (event, file, fileList) => {
    upload.value.isUploading = true;
}

// 文件上传成功处理
const handleFileSuccess = (response, file, fileList) => {
    upload.value.open = false;
    upload.value.isUploading = false;
    proxy.$refs.uploadRef.clearFiles();
    proxy.$alert("<div style='overflow: auto;overflow-x: hidden;max-height: 70vh;padding: 10px 20px 0;'>" + response.msg + "</div>", "导入结果", {dangerouslyUseHTMLString: true});
    getList();
}

// 提交上传文件
const submitFileForm = () => {
    proxy.$refs.uploadRef.submit();
}

getList()
</script>
