import argparse
import json
import math
import statistics
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from decimal import Decimal
from typing import Any, Dict, List, Tuple

import requests


BASE_URL = "http://127.0.0.1:8080"


@dataclass
class BenchConfig:
    name: str
    method: str
    path: str
    concurrency_levels: List[int]
    request_factor: int = 10


def login(username: str, password: str) -> str:
    response = requests.post(
        f"{BASE_URL}/login",
        json={"username": username, "password": password, "code": "", "uuid": ""},
        timeout=15,
    )
    payload = response.json()
    if response.status_code != 200 or payload.get("code") != 200:
        raise RuntimeError(f"login failed for {username}: {payload}")
    return payload["token"]


def auth_headers(token: str) -> Dict[str, str]:
    return {"Authorization": f"Bearer {token}"}


def fetch_products(token: str, page_size: int = 12) -> List[Dict[str, Any]]:
    response = requests.get(
        f"{BASE_URL}/snack/product/list",
        params={"pageNum": 1, "pageSize": page_size},
        headers=auth_headers(token),
        timeout=15,
    )
    payload = response.json()
    if response.status_code != 200 or payload.get("code") != 200:
        raise RuntimeError(f"fetch_products failed: {payload}")
    return payload["rows"]


def build_order_payload(products: List[Dict[str, Any]], index: int) -> Dict[str, Any]:
    left = products[index % len(products)]
    right = products[(index + 1) % len(products)]
    quantity_left = 1 + (index % 2)
    quantity_right = 1
    total_amount = Decimal(str(left["price"])) * quantity_left + Decimal(str(right["price"])) * quantity_right
    return {
        "name": "张三",
        "phone": "13800138000",
        "address": f"测试地址{index % 20}",
        "totalAmount": float(total_amount),
        "productCount": quantity_left + quantity_right,
        "status": "待收货",
        "orderProductsList": [
            {
                "image": left["image"],
                "name": left["name"],
                "price": left["price"],
                "quantity": quantity_left,
            },
            {
                "image": right["image"],
                "name": right["name"],
                "price": right["price"],
                "quantity": quantity_right,
            },
        ],
    }


def percentile(values: List[float], pct: float) -> float:
    if not values:
        return 0.0
    if len(values) == 1:
        return values[0]
    ordered = sorted(values)
    position = (len(ordered) - 1) * pct
    lower = math.floor(position)
    upper = math.ceil(position)
    if lower == upper:
        return ordered[lower]
    return ordered[lower] + (ordered[upper] - ordered[lower]) * (position - lower)


def send_request(
    method: str,
    path: str,
    token: str,
    payload: Dict[str, Any] | None = None,
) -> Tuple[bool, float, str]:
    start = time.perf_counter()
    try:
        response = requests.request(
            method=method,
            url=f"{BASE_URL}{path}",
            headers=auth_headers(token),
            json=payload,
            timeout=30,
        )
        elapsed_ms = (time.perf_counter() - start) * 1000
        body = response.json()
        ok = response.status_code == 200 and body.get("code") == 200
        message = body.get("msg", "")
        return ok, elapsed_ms, message
    except Exception as exc:  # noqa: BLE001
        elapsed_ms = (time.perf_counter() - start) * 1000
        return False, elapsed_ms, str(exc)


def run_single_benchmark(
    method: str,
    path: str,
    token_pool: List[str],
    concurrency: int,
    total_requests: int,
    order_products: List[Dict[str, Any]] | None = None,
) -> Dict[str, Any]:
    latencies: List[float] = []
    errors = 0
    error_samples: List[str] = []

    def task(index: int) -> Tuple[bool, float, str]:
        token = token_pool[index % len(token_pool)]
        payload = None
        if order_products is not None:
            payload = build_order_payload(order_products, index)
        return send_request(method, path, token, payload)

    start = time.perf_counter()
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = [executor.submit(task, i) for i in range(total_requests)]
        for future in as_completed(futures):
            ok, elapsed_ms, message = future.result()
            latencies.append(elapsed_ms)
            if not ok:
                errors += 1
                if len(error_samples) < 5:
                    error_samples.append(message)
    total_elapsed = time.perf_counter() - start
    success_count = total_requests - errors

    return {
        "concurrency": concurrency,
        "requests": total_requests,
        "avg_ms": round(statistics.fmean(latencies), 2) if latencies else 0.0,
        "p95_ms": round(percentile(latencies, 0.95), 2),
        "error_rate": round(errors / total_requests, 4) if total_requests else 0.0,
        "throughput_rps": round(success_count / total_elapsed, 2) if total_elapsed else 0.0,
        "errors": errors,
        "error_samples": error_samples,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="D:\\DevelopSoft\\lingshi\\logs\\interface_benchmark_results.json")
    parser.add_argument("--users", nargs="+", default=["张三:123456"])
    args = parser.parse_args()

    token_pool = []
    for user in args.users:
        username, password = user.split(":", 1)
        token_pool.append(login(username, password))

    products = fetch_products(token_pool[0])
    configs = [
        BenchConfig("商品查询接口", "GET", "/snack/product/list?pageNum=1&pageSize=10", [10, 30, 50]),
        BenchConfig("订单提交接口", "POST", "/snack/order", [10, 30, 50]),
        BenchConfig("推荐接口", "GET", "/snack/recommendation/advanced?limit=10&pageNum=1&pageSize=10", [10, 30, 50]),
    ]

    results: Dict[str, List[Dict[str, Any]]] = {}
    for config in configs:
        rows = []
        for concurrency in config.concurrency_levels:
            total_requests = concurrency * config.request_factor
            order_products = products if config.name == "订单提交接口" else None
            rows.append(
                run_single_benchmark(
                    method=config.method,
                    path=config.path,
                    token_pool=token_pool,
                    concurrency=concurrency,
                    total_requests=total_requests,
                    order_products=order_products,
                )
            )
        results[config.name] = rows

    with open(args.output, "w", encoding="utf-8") as file:
        json.dump(results, file, ensure_ascii=False, indent=2)

    print(json.dumps(results, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
