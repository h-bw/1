from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images" / "usecase"
OUT.mkdir(parents=True, exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DIAGRAMS = {
    "图2-3-普通用户用例图": r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.5, ranksep=1.0]
    node [fontname="Microsoft YaHei"]
    edge [fontname="Microsoft YaHei", color="#666666", arrowsize=0.7]

    user [label="普通用户", shape=plaintext, fontsize=15]

    subgraph cluster_system {
        label="零食商城小程序"
        fontname="Microsoft YaHei"
        fontsize=14
        color="#7EA8BE"
        style="rounded"

        uc1 [label="注册/登录", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc2 [label="浏览首页", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc3 [label="分类查看商品", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc4 [label="查看商品详情", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc5 [label="加入购物车", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc6 [label="管理购物车", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc7 [label="管理收货地址", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc8 [label="提交订单", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc9 [label="查看订单", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
        uc10 [label="查看推荐商品", shape=ellipse, style=filled, fillcolor="#F7FBFF", color="#4E79A7"]
    }

    user -> uc1
    user -> uc2
    user -> uc3
    user -> uc4
    user -> uc5
    user -> uc6
    user -> uc7
    user -> uc8
    user -> uc9
    user -> uc10

    uc8 -> uc7 [style=dashed, label="<<include>>"]
    uc8 -> uc6 [style=dashed, label="<<include>>"]
    uc5 -> uc4 [style=dashed, label="<<extend>>"]
}
''',
    "图2-4-管理员用例图": r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.5, ranksep=1.0]
    node [fontname="Microsoft YaHei"]
    edge [fontname="Microsoft YaHei", color="#666666", arrowsize=0.7]

    admin [label="管理员", shape=plaintext, fontsize=15]

    subgraph cluster_system {
        label="零食商城后台管理系统"
        fontname="Microsoft YaHei"
        fontsize=14
        color="#8CB369"
        style="rounded"

        uc1 [label="后台登录", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc2 [label="管理商品分类", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc3 [label="管理商品信息", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc4 [label="管理轮播图", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc5 [label="查看订单信息", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc6 [label="管理系统用户", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc7 [label="管理角色权限", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
        uc8 [label="查看统计数据", shape=ellipse, style=filled, fillcolor="#F7FFF5", color="#59A14F"]
    }

    admin -> uc1
    admin -> uc2
    admin -> uc3
    admin -> uc4
    admin -> uc5
    admin -> uc6
    admin -> uc7
    admin -> uc8

    uc3 -> uc2 [style=dashed, label="<<include>>"]
}
''',
    "图2-5-系统总体用例图": r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.7, ranksep=1.0]
    node [fontname="Microsoft YaHei"]
    edge [fontname="Microsoft YaHei", color="#666666", arrowsize=0.7]

    user [label="普通用户", shape=plaintext, fontsize=15]
    admin [label="管理员", shape=plaintext, fontsize=15]

    subgraph cluster_system {
        label="基于SpringBoot+UniApp+Vue的零食商城小程序"
        fontname="Microsoft YaHei"
        fontsize=14
        color="#B07AA1"
        style="rounded"

        uc1 [label="注册/登录", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc2 [label="浏览商品", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc3 [label="管理购物车", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc4 [label="管理收货地址", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc5 [label="提交与查询订单", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc6 [label="商品分类管理", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc7 [label="商品信息管理", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc8 [label="轮播图管理", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc9 [label="订单管理", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc10 [label="系统权限管理", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
        uc11 [label="推荐服务", shape=ellipse, style=filled, fillcolor="#FFF8FD", color="#B07AA1"]
    }

    user -> uc1
    user -> uc2
    user -> uc3
    user -> uc4
    user -> uc5
    user -> uc11

    admin -> uc6
    admin -> uc7
    admin -> uc8
    admin -> uc9
    admin -> uc10
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
