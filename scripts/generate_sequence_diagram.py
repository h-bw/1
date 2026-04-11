from pathlib import Path
import subprocess


ROOT = Path(r"D:\DevelopSoft\lingshi")
OUT = ROOT / "thesis_images" / "sequence"
OUT.mkdir(parents=True, exist_ok=True)
DOT = Path(r"D:\DevelopSoft\Graphviz\bin\dot.exe")


DOT_SOURCE = r'''
digraph G {
    graph [rankdir=LR, splines=ortho, nodesep=0.8, ranksep=0.6, bgcolor="white", fontname="Microsoft YaHei"]
    node [fontname="Microsoft YaHei", shape=plaintext]
    edge [fontname="Microsoft YaHei", color="#555555", arrowsize=0.7]

    front [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#E09F3E">
            <TR><TD BGCOLOR="#FFF5E6"><B>前端页面</B><BR/>UniApp / Vue</TD></TR>
        </TABLE>
    >]
    controller [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#4C956C">
            <TR><TD BGCOLOR="#EEF7F1"><B>控制层</B><BR/>Controller</TD></TR>
        </TABLE>
    >]
    service [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#4C956C">
            <TR><TD BGCOLOR="#EEF7F1"><B>业务层</B><BR/>Service</TD></TR>
        </TABLE>
    >]
    mapper [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#8E6C88">
            <TR><TD BGCOLOR="#F8F1FA"><B>数据访问层</B><BR/>Mapper / MyBatis</TD></TR>
        </TABLE>
    >]
    db [label=<
        <TABLE BORDER="0" CELLBORDER="1" CELLSPACING="0" CELLPADDING="10" COLOR="#C8553D">
            <TR><TD BGCOLOR="#FFF0F3"><B>数据库</B><BR/>MySQL</TD></TR>
        </TABLE>
    >]

    {rank=same; front; controller; service; mapper; db;}

    lf [shape=none, label="|"];
    lc [shape=none, label="|"];
    ls [shape=none, label="|"];
    lm [shape=none, label="|"];
    ld [shape=none, label="|"];

    front -> controller [label="1. 发起请求\n(商品查询/购物车/订单提交)", minlen=2]
    controller -> service [label="2. 参数接收与业务分发", minlen=2]
    service -> mapper [label="3. 调用数据访问接口", minlen=2]
    mapper -> db [label="4. 执行增删改查", minlen=2]
    db -> mapper [label="5. 返回查询或写入结果", minlen=2]
    mapper -> service [label="6. 返回持久层结果", minlen=2]
    service -> controller [label="7. 封装业务处理结果", minlen=2]
    controller -> front [label="8. 返回 JSON 响应并刷新页面", minlen=2]
}
'''


def main():
    dot_path = OUT / "图2-6-系统数据处理时序图.dot"
    svg_path = OUT / "图2-6-系统数据处理时序图.svg"
    png_path = OUT / "图2-6-系统数据处理时序图.png"

    dot_path.write_text(DOT_SOURCE.strip() + "\n", encoding="utf-8")
    subprocess.run([str(DOT), "-Tsvg", str(dot_path), "-o", str(svg_path)], check=True)
    subprocess.run([str(DOT), "-Tpng", str(dot_path), "-o", str(png_path)], check=True)
    print(str(OUT))


if __name__ == "__main__":
    main()
