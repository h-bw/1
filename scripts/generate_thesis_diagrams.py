from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images"
OUT.mkdir(exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DIAGRAMS = {
    "图2-1-系统总体架构图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.5, ranksep=0.7]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    frontend1 [label="用户端页面\n(UniApp 小程序/移动端)", fillcolor="#FFF5E6", color="#E09F3E"]
    frontend2 [label="后台管理端\n(Vue.js + Vite)", fillcolor="#F3F7FF", color="#457B9D"]
    controller [label="控制层\nController", fillcolor="#EEF7F1", color="#4C956C"]
    service [label="业务层\nService", fillcolor="#EEF7F1", color="#4C956C"]
    mapper [label="数据访问层\nMapper / MyBatis", fillcolor="#F8F1FA", color="#8E6C88"]
    db [label="MySQL 数据库", fillcolor="#FFF0F3", color="#C8553D"]

    frontend1 -> controller [label="HTTP / JSON 请求"]
    frontend2 -> controller [label="HTTP / JSON 请求"]
    controller -> service [label="参数处理与业务分发"]
    service -> mapper [label="调用数据访问接口"]
    mapper -> db [label="增删改查"]
}
''',
    "图2-2-系统数据处理流程图": r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.55, ranksep=0.8]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="前端发起请求", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="控制层接收请求", fillcolor="#EEF7F1", color="#4C956C"]
    c [label="业务层处理逻辑", fillcolor="#EEF7F1", color="#4C956C"]
    d [label="数据库读写", fillcolor="#FFF0F3", color="#C8553D"]
    e [label="封装响应结果", fillcolor="#F3F7FF", color="#457B9D"]
    f [label="前端页面展示", fillcolor="#F3F7FF", color="#457B9D"]

    a -> b -> c -> d -> e -> f
}
''',
    "图3-1-系统功能模块图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.5, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    root [label="零食商城\n小程序系统", shape=ellipse, fillcolor="#EAF4FF", color="#457B9D"]

    user [shape=plain, label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#E09F3E">
            <TR><TD BGCOLOR="#FFF5E6"><B>用户端模块</B></TD></TR>
            <TR><TD>首页展示</TD></TR>
            <TR><TD>分类与商品浏览</TD></TR>
            <TR><TD>购物车</TD></TR>
            <TR><TD>地址管理</TD></TR>
            <TR><TD>订单管理</TD></TR>
            <TR><TD>个人中心</TD></TR>
        </TABLE>
    >]

    admin [shape=plain, label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4C956C">
            <TR><TD BGCOLOR="#EEF7F1"><B>后台管理模块</B></TD></TR>
            <TR><TD>分类管理</TD></TR>
            <TR><TD>商品管理</TD></TR>
            <TR><TD>轮播图管理</TD></TR>
            <TR><TD>订单管理</TD></TR>
            <TR><TD>系统管理</TD></TR>
            <TR><TD>统计分析</TD></TR>
        </TABLE>
    >]

    rec [shape=plain, label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#8E6C88">
            <TR><TD BGCOLOR="#F8F1FA"><B>推荐模块</B></TD></TR>
            <TR><TD>热门商品推荐</TD></TR>
            <TR><TD>历史订单推荐</TD></TR>
            <TR><TD>推荐结果展示</TD></TR>
            <TR><TD>用户浏览引导</TD></TR>
            <TR><TD>商品发现支持</TD></TR>
            <TR><TD>扩展接口预留</TD></TR>
        </TABLE>
    >]

    {rank=same; user; admin; rec;}

    root -> user
    root -> admin
    root -> rec
}
''',
    "图3-2-数据库ER关系图": r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.7, ranksep=0.9]
    node [shape=record, style="filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    user [label="{sys_user|user_id\luser_name\lpassword\l}"]
    addr [label="{address|address_id\lname\lphone\ldetail\luser_id\l}"]
    category [label="{category|category_id\lname\limage\l}"]
    product [label="{product|product_id\lcategory_id\lname\lprice\limage\l}"]
    cart [label="{cart|cart_id\lproduct_id\luser_id\lquantity\l}"]
    orderm [label="{order|order_id\luser_id\ltotal_amount\lstatus\l}"]
    orderp [label="{order_products|op_id\lorder_id\lname\lprice\lquantity\l}"]
    banner [label="{banner|banner_id\limage\lsort\l}"]

    user -> addr [label="1 对 多"]
    user -> cart [label="1 对 多"]
    user -> orderm [label="1 对 多"]
    category -> product [label="1 对 多"]
    product -> cart [label="1 对 多"]
    orderm -> orderp [label="1 对 多"]
}
''',
    "图3-3-购物车业务流程图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.65]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="用户选择商品", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="点击加入购物车", fillcolor="#FFF5E6", color="#E09F3E"]
    c [label="判断购物车中\n是否已存在该商品", shape=diamond, fillcolor="#FFF8D6", color="#B08900"]
    d [label="数量加 1", fillcolor="#EEF7F1", color="#4C956C"]
    e [label="新增购物车记录", fillcolor="#EEF7F1", color="#4C956C"]
    f [label="返回结果并刷新页面", fillcolor="#F3F7FF", color="#457B9D"]

    a -> b -> c
    c -> d [label="是"]
    c -> e [label="否"]
    d -> f
    e -> f
}
''',
    "图3-4-订单提交流程图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.65]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="用户确认商品信息", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="选择收货地址", fillcolor="#FFF5E6", color="#E09F3E"]
    c [label="填写订单备注", fillcolor="#FFF5E6", color="#E09F3E"]
    d [label="提交订单请求", fillcolor="#F3F7FF", color="#457B9D"]
    e [label="生成订单编号", fillcolor="#EEF7F1", color="#4C956C"]
    f [label="写入订单主表", fillcolor="#EEF7F1", color="#4C956C"]
    g [label="批量写入订单明细", fillcolor="#EEF7F1", color="#4C956C"]
    h [label="删除已结算购物车项", fillcolor="#F8F1FA", color="#8E6C88"]
    i [label="返回下单成功结果", fillcolor="#F3F7FF", color="#457B9D"]

    a -> b -> c -> d -> e -> f -> g -> h -> i
}
''',
    "图3-5-推荐模块流程图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.65]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="读取当前用户历史订单", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="是否存在历史订单", shape=diamond, fillcolor="#FFF8D6", color="#B08900"]
    c [label="返回热门商品", fillcolor="#EEF7F1", color="#4C956C"]
    d [label="提取已购商品集合", fillcolor="#EEF7F1", color="#4C956C"]
    e [label="查找相似用户", fillcolor="#EEF7F1", color="#4C956C"]
    f [label="统计相似用户偏好商品", fillcolor="#EEF7F1", color="#4C956C"]
    g [label="合并热门商品并去重", fillcolor="#F8F1FA", color="#8E6C88"]
    h [label="返回推荐结果", fillcolor="#F3F7FF", color="#457B9D"]

    a -> b
    b -> c [label="否"]
    b -> d [label="是"]
    d -> e -> f -> g -> h
    c -> h
}
''',
}


def render(name: str, dot_source: str):
    dot_path = OUT / f"{name}.dot"
    svg_path = OUT / f"{name}.svg"
    png_path = OUT / f"{name}.png"
    dot_path.write_text(dot_source.strip() + "\n", encoding="utf-8")
    subprocess.run([str(DOT), "-Tsvg", str(dot_path), "-o", str(svg_path)], check=True)
    subprocess.run([str(DOT), "-Tpng", str(dot_path), "-o", str(png_path)], check=True)


def main():
    for name, source in DIAGRAMS.items():
        render(name, source)
    print(str(OUT))


if __name__ == "__main__":
    main()
