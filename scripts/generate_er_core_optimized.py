from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images" / "optimized"
OUT.mkdir(parents=True, exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DOT_SOURCE = r'''
digraph G {
    graph [rankdir=TB, fontname="Microsoft YaHei", bgcolor="white", nodesep=0.7, ranksep=0.8]
    node [shape=plain, fontname="Microsoft YaHei"]
    edge [fontname="Microsoft YaHei", color="#4A6572", arrowsize=0.8]

    user [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>sys_user</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">user_id<BR/>user_name</TD></TR>
        </TABLE>
    >]

    address [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>address</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">address_id<BR/>user_id<BR/>name<BR/>phone</TD></TR>
        </TABLE>
    >]

    orderm [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>order</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">order_id<BR/>user_id<BR/>total_amount<BR/>status</TD></TR>
        </TABLE>
    >]

    category [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>category</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">category_id<BR/>name</TD></TR>
        </TABLE>
    >]

    product [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>product</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">product_id<BR/>category_id<BR/>name<BR/>price</TD></TR>
        </TABLE>
    >]

    cart [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>cart</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">cart_id<BR/>product_id<BR/>user_id<BR/>quantity</TD></TR>
        </TABLE>
    >]

    orderp [label=<
        <TABLE BORDER="1" CELLBORDER="1" CELLSPACING="0" CELLPADDING="8" COLOR="#4E79A7">
            <TR><TD BGCOLOR="#F7FBFF"><B>order_products</B></TD><TD BGCOLOR="#F7FBFF" ALIGN="LEFT">op_id<BR/>order_id<BR/>name<BR/>price<BR/>quantity</TD></TR>
        </TABLE>
    >]

    {rank=same; address; user; orderm;}
    {rank=same; category; product; cart; orderp;}

    user -> address [label="1 对 多"]
    user -> orderm [label="1 对 多"]
    user -> cart [label="1 对 多"]
    category -> product [label="1 对 多"]
    product -> cart [label="1 对 多"]
    orderm -> orderp [label="1 对 多"]
}
'''


def main():
    dot_path = OUT / "图3-2-核心交易ER图-优化版.dot"
    svg_path = OUT / "图3-2-核心交易ER图-优化版.svg"
    png_path = OUT / "图3-2-核心交易ER图-优化版.png"

    dot_path.write_text(DOT_SOURCE.strip() + "\n", encoding="utf-8")
    subprocess.run([str(DOT), "-Tsvg", str(dot_path), "-o", str(svg_path)], check=True)
    subprocess.run([str(DOT), "-Tpng", str(dot_path), "-o", str(png_path)], check=True)
    print(str(OUT))


if __name__ == "__main__":
    main()
