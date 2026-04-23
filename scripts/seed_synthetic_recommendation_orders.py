from __future__ import annotations

import subprocess
from dataclasses import dataclass
from decimal import Decimal


MYSQL_EXE = r"C:\Program Files\MySQL\MySQL Server 8.1\bin\mysql.exe"
DB_ARGS = [
    MYSQL_EXE,
    "--default-character-set=utf8mb4",
    "--host=localhost",
    "--port=3306",
    "--user=root",
    "--password=123456",
    "huacai-snack",
]


PRODUCT_PRICES = {
    "芒果干": Decimal("18.90"),
    "猕猴桃干": Decimal("19.90"),
    "葡萄干": Decimal("12.90"),
    "香蕉片": Decimal("11.90"),
    "夹心饼干": Decimal("12.90"),
    "华夫饼": Decimal("22.90"),
    "威化饼干": Decimal("15.90"),
    "酸奶": Decimal("8.90"),
    "果汁饮料": Decimal("6.90"),
    "碳酸饮料": Decimal("4.90"),
    "薯片": Decimal("7.90"),
    "虾条": Decimal("6.90"),
    "爆米花": Decimal("12.90"),
    "玉米片": Decimal("8.90"),
    "芝士球": Decimal("11.90"),
    "气泡水": Decimal("4.90"),
    "洋葱圈": Decimal("8.90"),
    "开心果": Decimal("45.90"),
    "巴旦木": Decimal("35.90"),
    "五香瓜子": Decimal("16.90"),
    "原味瓜子": Decimal("15.90"),
    "牛肉干": Decimal("45.90"),
    "手撕牛肉": Decimal("52.90"),
    "猪肉脯": Decimal("32.90"),
    "原味肉松": Decimal("25.90"),
}


@dataclass(frozen=True)
class UserProfile:
    user_id: int
    consignee: str
    phone: str
    address: str
    orders: list[tuple[str, list[tuple[str, int]], str]]


USERS = [
    UserProfile(
        201,
        "陈晨",
        "1390000201",
        "成都市高新区模拟评估1号",
        [
            ("2025-10-19 09:00:00", [("芒果干", 1), ("果汁饮料", 2)], "已完成"),
            ("2025-10-20 09:15:00", [("猕猴桃干", 1), ("夹心饼干", 1)], "已完成"),
            ("2025-10-21 09:30:00", [("酸奶", 2), ("葡萄干", 1)], "已完成"),
            ("2025-10-22 09:45:00", [("香蕉片", 1), ("华夫饼", 1)], "待收货"),
        ],
    ),
    UserProfile(
        202,
        "林悦",
        "1390000202",
        "成都市高新区模拟评估2号",
        [
            ("2025-10-19 10:00:00", [("芒果干", 1), ("果汁饮料", 1)], "已完成"),
            ("2025-10-20 10:15:00", [("香蕉片", 2), ("华夫饼", 1)], "已完成"),
            ("2025-10-21 10:30:00", [("酸奶", 1), ("威化饼干", 1)], "已完成"),
            ("2025-10-22 10:45:00", [("猕猴桃干", 1), ("夹心饼干", 1)], "待收货"),
        ],
    ),
    UserProfile(
        203,
        "周宁",
        "1390000203",
        "成都市高新区模拟评估3号",
        [
            ("2025-10-19 11:00:00", [("芒果干", 1), ("酸奶", 1)], "已完成"),
            ("2025-10-20 11:15:00", [("香蕉片", 1), ("华夫饼", 1)], "已完成"),
            ("2025-10-21 11:30:00", [("夹心饼干", 1), ("果汁饮料", 1)], "已完成"),
            ("2025-10-22 11:45:00", [("猕猴桃干", 1), ("葡萄干", 1)], "待收货"),
        ],
    ),
    UserProfile(
        204,
        "赵航",
        "1390000204",
        "成都市锦江区模拟评估4号",
        [
            ("2025-10-19 13:00:00", [("薯片", 2), ("碳酸饮料", 1)], "已完成"),
            ("2025-10-20 13:15:00", [("虾条", 1), ("爆米花", 1)], "已完成"),
            ("2025-10-21 13:30:00", [("气泡水", 1), ("洋葱圈", 1)], "已完成"),
            ("2025-10-22 13:45:00", [("玉米片", 1), ("芝士球", 1)], "待收货"),
        ],
    ),
    UserProfile(
        205,
        "孙琪",
        "1390000205",
        "成都市锦江区模拟评估5号",
        [
            ("2025-10-19 14:00:00", [("薯片", 1), ("碳酸饮料", 2)], "已完成"),
            ("2025-10-20 14:15:00", [("玉米片", 1), ("芝士球", 1)], "已完成"),
            ("2025-10-21 14:30:00", [("爆米花", 1), ("气泡水", 1)], "已完成"),
            ("2025-10-22 14:45:00", [("虾条", 1), ("洋葱圈", 1)], "待收货"),
        ],
    ),
    UserProfile(
        206,
        "吴桐",
        "1390000206",
        "成都市锦江区模拟评估6号",
        [
            ("2025-10-19 15:00:00", [("虾条", 1), ("玉米片", 1)], "已完成"),
            ("2025-10-20 15:15:00", [("爆米花", 1), ("洋葱圈", 1)], "已完成"),
            ("2025-10-21 15:30:00", [("气泡水", 1), ("芝士球", 1)], "已完成"),
            ("2025-10-22 15:45:00", [("薯片", 1), ("碳酸饮料", 1)], "待收货"),
        ],
    ),
    UserProfile(
        207,
        "许川",
        "1390000207",
        "成都市武侯区模拟评估7号",
        [
            ("2025-10-19 17:00:00", [("开心果", 1), ("牛肉干", 1)], "已完成"),
            ("2025-10-20 17:15:00", [("原味瓜子", 1), ("手撕牛肉", 1)], "已完成"),
            ("2025-10-21 17:30:00", [("牛肉干", 1), ("原味肉松", 1)], "已完成"),
            ("2025-10-22 17:45:00", [("巴旦木", 1), ("五香瓜子", 1)], "待收货"),
        ],
    ),
    UserProfile(
        208,
        "何薇",
        "1390000208",
        "成都市武侯区模拟评估8号",
        [
            ("2025-10-19 18:00:00", [("开心果", 1), ("牛肉干", 1)], "已完成"),
            ("2025-10-20 18:15:00", [("巴旦木", 1), ("五香瓜子", 1)], "已完成"),
            ("2025-10-21 18:30:00", [("猪肉脯", 1), ("原味肉松", 1)], "已完成"),
            ("2025-10-22 18:45:00", [("原味瓜子", 1), ("手撕牛肉", 1)], "待收货"),
        ],
    ),
    UserProfile(
        209,
        "高原",
        "1390000209",
        "成都市武侯区模拟评估9号",
        [
            ("2025-10-19 19:00:00", [("开心果", 1), ("巴旦木", 1)], "已完成"),
            ("2025-10-20 19:15:00", [("牛肉干", 1), ("五香瓜子", 1)], "已完成"),
            ("2025-10-21 19:30:00", [("猪肉脯", 1), ("原味瓜子", 1)], "已完成"),
            ("2025-10-22 19:45:00", [("手撕牛肉", 1), ("原味肉松", 1)], "待收货"),
        ],
    ),
]


def sql_quote(value: str) -> str:
    return "'" + value.replace("\\", "\\\\").replace("'", "''") + "'"


def rounded_unit_price(name: str) -> int:
    return int(PRODUCT_PRICES[name].quantize(Decimal("1")))


def order_total(items: list[tuple[str, int]]) -> Decimal:
    total = sum(PRODUCT_PRICES[name] * qty for name, qty in items)
    return total.quantize(Decimal("0.00"))


def order_id_for(created_at: str, user_id: int) -> str:
    digits = created_at.replace("-", "").replace(":", "").replace(" ", "")
    return f"OR{digits}{user_id}"


def build_sql() -> str:
    statements: list[str] = [
        "SET NAMES utf8mb4;",
        "SET FOREIGN_KEY_CHECKS = 0;",
        "DELETE op FROM order_products op JOIN `order` o ON op.order_id = o.order_id WHERE o.remark = 'synthetic-eval';",
        "DELETE FROM `order` WHERE remark = 'synthetic-eval';",
        "DELETE FROM address WHERE detail LIKE '%模拟评估%';",
    ]

    for profile in USERS:
        address_id = f"synthetic-address-{profile.user_id}"
        statements.append(
            "INSERT INTO address (address_id, name, phone, detail, is_default, user_id, create_time) VALUES "
            f"({sql_quote(address_id)}, {sql_quote(profile.consignee)}, {sql_quote(profile.phone)}, "
            f"{sql_quote(profile.address)}, 1, {profile.user_id}, '2025-10-18 08:00:00');"
        )

        for created_at, items, status in profile.orders:
            order_id = order_id_for(created_at, profile.user_id)
            total_amount = order_total(items)
            product_count = sum(qty for _, qty in items)
            statements.append(
                "INSERT INTO `order` "
                "(order_id, name, phone, address, total_amount, product_count, status, remark, user_id, create_time) VALUES "
                f"({sql_quote(order_id)}, {sql_quote(profile.consignee)}, {sql_quote(profile.phone)}, "
                f"{sql_quote(profile.address)}, {total_amount}, {product_count}, {sql_quote(status)}, 'synthetic-eval', "
                f"{profile.user_id}, {sql_quote(created_at)});"
            )

            for name, qty in items:
                statements.append(
                    "INSERT INTO order_products (order_id, image, name, price, quantity) VALUES "
                    f"({sql_quote(order_id)}, NULL, {sql_quote(name)}, {rounded_unit_price(name)}, {qty});"
                )

    statements.append("SET FOREIGN_KEY_CHECKS = 1;")
    return "\n".join(statements) + "\n"


def main() -> None:
    sql = build_sql()
    completed = subprocess.run(
        DB_ARGS,
        input=sql,
        text=True,
        encoding="utf-8",
        capture_output=True,
        check=False,
    )
    if completed.returncode != 0:
        raise SystemExit(
            f"Seeding failed with code {completed.returncode}\nSTDOUT:\n{completed.stdout}\nSTDERR:\n{completed.stderr}"
        )

    total_orders = sum(len(profile.orders) for profile in USERS)
    total_items = sum(sum(qty for _, qty in items) for profile in USERS for _, items, _ in profile.orders)
    print(f"Inserted synthetic evaluation data for {len(USERS)} users.")
    print(f"Inserted {total_orders} orders and {total_items} item quantities.")


if __name__ == "__main__":
    main()
