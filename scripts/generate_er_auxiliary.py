from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images" / "optimized"
OUT.mkdir(parents=True, exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DOT_SOURCE = r'''
digraph G {
    graph [rankdir=LR, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.8, ranksep=1.0, compound=true]
    node [shape=plain, fontname="Microsoft YaHei"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    subgraph cluster_home {
        label="首页展示辅助模块"
        fontname="Microsoft YaHei"
        fontsize=14
        color="#E09F3E"
        style="rounded"

        banner [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#E09F3E">
                <TR><TD BGCOLOR="#FFF5E6"><B>banner</B></TD><TD BGCOLOR="#FFF5E6" ALIGN="LEFT">banner_id<BR/>image<BR/>sort</TD></TR>
            </TABLE>
        >]

        product_home [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#E09F3E">
                <TR><TD BGCOLOR="#FFF5E6"><B>product</B></TD><TD BGCOLOR="#FFF5E6" ALIGN="LEFT">product_id<BR/>name<BR/>price<BR/>image</TD></TR>
            </TABLE>
        >]

        banner -> product_home [style=dashed, label="首页共同展示"]
    }

    subgraph cluster_rec {
        label="推荐服务辅助模块"
        fontname="Microsoft YaHei"
        fontsize=14
        color="#8E6C88"
        style="rounded"

        user [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#8E6C88">
                <TR><TD BGCOLOR="#F8F1FA"><B>sys_user</B></TD><TD BGCOLOR="#F8F1FA" ALIGN="LEFT">user_id<BR/>user_name</TD></TR>
            </TABLE>
        >]

        orderm [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#8E6C88">
                <TR><TD BGCOLOR="#F8F1FA"><B>order</B></TD><TD BGCOLOR="#F8F1FA" ALIGN="LEFT">order_id<BR/>user_id<BR/>status</TD></TR>
            </TABLE>
        >]

        orderp [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#8E6C88">
                <TR><TD BGCOLOR="#F8F1FA"><B>order_products</B></TD><TD BGCOLOR="#F8F1FA" ALIGN="LEFT">op_id<BR/>order_id<BR/>name<BR/>price<BR/>quantity</TD></TR>
            </TABLE>
        >]

        product_rec [label=<
            <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#8E6C88">
                <TR><TD BGCOLOR="#F8F1FA"><B>product</B></TD><TD BGCOLOR="#F8F1FA" ALIGN="LEFT">product_id<BR/>name<BR/>price<BR/>image</TD></TR>
            </TABLE>
        >]

        user -> orderm [label="1 对 多"]
        orderm -> orderp [label="1 对 多"]
        orderp -> product_rec [style=dashed, label="推荐匹配依据"]
    }
}
'''


def main():
    dot_path = OUT / "图3-3-辅助功能ER图-优化版.dot"
    svg_path = OUT / "图3-3-辅助功能ER图-优化版.svg"
    png_path = OUT / "图3-3-辅助功能ER图-优化版.png"

    dot_path.write_text(DOT_SOURCE.strip() + "\n", encoding="utf-8")
    subprocess.run([str(DOT), "-Tsvg", str(dot_path), "-o", str(svg_path)], check=True)
    subprocess.run([str(DOT), "-Tpng", str(dot_path), "-o", str(png_path)], check=True)
    print(str(OUT))


if __name__ == "__main__":
    main()
