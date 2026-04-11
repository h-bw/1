from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images" / "modules"
OUT.mkdir(parents=True, exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DIAGRAMS = {
    "图3-7-首页展示模块图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    root [label="首页展示模块", shape=ellipse, fillcolor="#FFF5E6", color="#E09F3E", fontsize=16]

    banner [label="轮播图展示", fillcolor="#F3F7FF", color="#457B9D"]
    category [label="分类导航入口", fillcolor="#F3F7FF", color="#457B9D"]
    hot [label="热门商品展示", fillcolor="#EEF7F1", color="#4C956C"]
    recommend [label="推荐商品展示", fillcolor="#EEF7F1", color="#4C956C"]
    jump [label="商品详情跳转", fillcolor="#F8F1FA", color="#8E6C88"]

    {rank=same; banner; category;}
    {rank=same; hot; recommend;}

    root -> banner
    root -> category
    root -> hot
    root -> recommend
    hot -> jump
    recommend -> jump
}
''',
    "图3-8-商品浏览模块图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    root [label="商品浏览模块", shape=ellipse, fillcolor="#FFF5E6", color="#E09F3E", fontsize=16]

    list [label="商品列表查看", fillcolor="#F3F7FF", color="#457B9D"]
    category [label="分类筛选浏览", fillcolor="#F3F7FF", color="#457B9D"]
    detail [label="商品详情查看", fillcolor="#EEF7F1", color="#4C956C"]
    info [label="名称/价格/图片展示", fillcolor="#EEF7F1", color="#4C956C"]
    cart [label="加入购物车入口", fillcolor="#F8F1FA", color="#8E6C88"]

    {rank=same; list; category;}
    {rank=same; detail; info;}

    root -> list
    root -> category
    list -> detail
    category -> detail
    detail -> info
    detail -> cart
}
''',
    "图3-9-购物车业务流程图-模块版": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.4, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="用户选择商品", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="加入购物车", fillcolor="#FFF5E6", color="#E09F3E"]
    c [label="判断购物车中\n是否已存在该商品", shape=diamond, fillcolor="#FFF8D6", color="#B08900"]
    d [label="更新商品数量", fillcolor="#EEF7F1", color="#4C956C"]
    e [label="新增购物车记录", fillcolor="#EEF7F1", color="#4C956C"]
    f [label="展示购物车列表", fillcolor="#F3F7FF", color="#457B9D"]
    g [label="进入订单确认", fillcolor="#F8F1FA", color="#8E6C88"]

    a -> b -> c
    c -> d [label="是"]
    c -> e [label="否"]
    d -> f
    e -> f
    f -> g
}
''',
    "图3-10-后台管理模块图": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.45, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    root [label="后台管理模块", shape=ellipse, fillcolor="#EEF7F1", color="#4C956C", fontsize=16]

    category [label="商品分类管理", fillcolor="#F3F7FF", color="#457B9D"]
    product [label="商品信息管理", fillcolor="#F3F7FF", color="#457B9D"]
    banner [label="轮播图管理", fillcolor="#F3F7FF", color="#457B9D"]
    order [label="订单管理", fillcolor="#F8F1FA", color="#8E6C88"]
    system [label="系统管理", fillcolor="#F8F1FA", color="#8E6C88"]
    stats [label="统计分析", fillcolor="#FFF5E6", color="#E09F3E"]

    {rank=same; category; product; banner;}
    {rank=same; order; system; stats;}

    root -> category
    root -> product
    root -> banner
    root -> order
    root -> system
    root -> stats
}
''',
    "图3-11-推荐模块流程图-模块版": r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.4, ranksep=0.55]
    node [shape=box, style="rounded,filled", fontname="Microsoft YaHei", color="#355C7D", fillcolor="#F6FBFF"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    a [label="读取用户历史订单", fillcolor="#FFF5E6", color="#E09F3E"]
    b [label="是否存在历史订单", shape=diamond, fillcolor="#FFF8D6", color="#B08900"]
    c [label="返回热门商品", fillcolor="#EEF7F1", color="#4C956C"]
    d [label="提取已购商品集合", fillcolor="#EEF7F1", color="#4C956C"]
    e [label="查找相似用户", fillcolor="#EEF7F1", color="#4C956C"]
    f [label="统计候选商品", fillcolor="#F8F1FA", color="#8E6C88"]
    g [label="热门商品补充与去重", fillcolor="#F8F1FA", color="#8E6C88"]
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
