import csv
import re
from collections import defaultdict
from pathlib import Path

import matplotlib.pyplot as plt

# 

CASE_RE = re.compile(r"-?\d+")


def parse_case(case_raw: str):
    case = case_raw.strip().strip('"')
    if case == "tt":
        return None

    nums = [int(x) for x in CASE_RE.findall(case)]
    if len(nums) == 1:
        return (0, nums[0])
    if len(nums) >= 2:
        return (nums[0], nums[1])
    return None


def load_points(csv_path: Path):
    points = defaultdict(lambda: defaultdict(list))

    with csv_path.open(newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            parsed = parse_case(row.get("case", ""))
            if parsed is None:
                continue

            size, stack1 = parsed
            if size not in (0, 1, 2, 3):
                continue

            try:
                weight = float(row["weight"])
            except (TypeError, ValueError, KeyError):
                continue

            points[size][stack1].append(weight)

    return points


def plot_size(size: int, stack_to_weights, out_dir: Path):
    xs = []
    ys = []
    for stack1, weights in stack_to_weights.items():
        for weight in weights:
            xs.append(stack1)
            ys.append(weight)

    plt.figure(figsize=(6, 4))
    plt.scatter(xs, ys, alpha=0.8)
    plt.title(f"Size {size}: Stack1 vs Weight")
    plt.xlabel("stack1")
    plt.ylabel("weight")
    plt.grid(True, alpha=0.3)

    out_path = out_dir / f"size{size}.png"
    plt.savefig(out_path, dpi=150, bbox_inches="tight")
    plt.close()


def transpose_points(points_by_size):
    points_by_stack = defaultdict(lambda: defaultdict(list))
    for size, stack_to_weights in points_by_size.items():
        for stack1, weights in stack_to_weights.items():
            points_by_stack[stack1][size].extend(weights)
    return points_by_stack


def plot_stack1(stack1: int, size_to_weights, out_dir: Path):
    xs = []
    ys = []
    for size, weights in size_to_weights.items():
        for weight in weights:
            xs.append(size)
            ys.append(weight)

    plt.figure(figsize=(6, 4))
    plt.scatter(xs, ys, alpha=0.8)
    plt.title(f"Stack1 {stack1}: Size vs Weight")
    plt.xlabel("size")
    plt.ylabel("weight")
    plt.grid(True, alpha=0.3)

    out_path = out_dir / f"stack1_{stack1}.png"
    plt.savefig(out_path, dpi=150, bbox_inches="tight")
    plt.close()


if __name__ == "__main__":
    base_dir = Path(__file__).resolve().parent
    csv_path = base_dir / "matched_cases.csv"

    if not csv_path.exists():
        raise FileNotFoundError(f"Could not find {csv_path}")

    points = load_points(csv_path)
    points_by_stack = transpose_points(points)

    for size in (0, 1, 2, 3):
        plot_size(size, points.get(size, {}), base_dir)

    for stack1 in sorted(points_by_stack.keys()):
        plot_stack1(stack1, points_by_stack[stack1], base_dir)

    print("Saved size-based plots: size0.png, size1.png, size2.png, size3.png")
    print("Saved stack1-based plots:", ", ".join(f"stack1_{s}.png" for s in sorted(points_by_stack.keys())))
