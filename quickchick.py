import argparse
import subprocess
import csv
import re
from pathlib import Path
from typing import Any

import matplotlib.pyplot as plt


in_files = [
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/"
    #     "ty-sizes=Main.sKVTree.t-4/stack_size=1/intwidth=1/spec_entropy/"
    #     "freq=2-spb=200/prop=isSTs/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/"
    #     "ty-sizes=Main.sKVTree.t-4/stack_size=1/intwidth=3/spec_entropy/"
    #     "freq=2-spb=200/prop=isSTs/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/"
    #     "ty-sizes=Main.sKVTree.t-4/stack_size=1/intwidth=3/satisfy_property/"
    #     "prop=satisfies_stickyness_simple/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/"
    #     "ty-sizes=Main.sKVTree.t-4/stack_size=2/intwidth=1/spec_entropy/"
    #     "freq=2-spb=200/prop=isSTs/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/"
    #     "ty-sizes=Main.sKVTree.t-4/stack_size=2/intwidth=3/spec_entropy/"
    #     "freq=2-spb=200/prop=isSTs/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    # Path(
    #     "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/ty-sizes=Main.sKVTree.t-4/stack_size=1/intwidth=3/spec_entropy/freq=2-spb=200/prop=always_true/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    # ),
    Path(
        "tuning-output/v133_artifact/st/langsiblingderived/root_ty=Main.sKVTree.t/ty-sizes=Main.sKVTree.t-10/stack_size=1/intwidth=1/spec_entropy/freq=2-spb=200/prop=isSTs/0.3/epochs=2000/bound=0.1/trained_Generator.v"
    )


]


def parse_quickchick_output(output: str) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    blocks = [block.strip() for block in output.split("\n\n") if block.strip()]

    for block in blocks:
        lines = [line.strip() for line in block.splitlines() if line.strip()]
        if not lines:
            continue

        header = lines[0]
        prefix = "QuickChecking (count_test "
        if not header.startswith(prefix) or not header.endswith(")"):
            continue

        test_name = header[len(prefix):-1]

        false_value = ""
        true_value = ""
        time_value = ""

        for line in lines[1:]:
            false_match = re.match(r"^(\d+)\s*:\s*false$", line)
            if false_match:
                false_value = false_match.group(1)
                continue

            true_match = re.match(r"^(\d+)\s*:\s*true$", line)
            if true_match:
                true_value = true_match.group(1)
                continue

            time_match = re.match(r"^Time Elapsed:\s*([0-9.]+)s$", line)
            if time_match:
                time_value = time_match.group(1)

        rows.append(
            {
                "test": test_name,
                "true": true_value,
                "false": false_value,
                "time": time_value,
            }
        )

    return rows


def write_csv(csv_path: Path, rows: list[dict[str, str]]) -> None:
    with csv_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=["test", "true", "false", "time"])
        writer.writeheader()
        writer.writerows(rows)


def read_csv(csv_path: Path) -> list[dict[str, str]]:
    with csv_path.open("r", encoding="utf-8", newline="") as handle:
        return list(csv.DictReader(handle))


def to_int(value: str) -> int:
    value = value.strip()
    if value == "":
        return 0
    return int(value)


def build_row_map(rows: list[dict[str, str]]) -> dict[str, dict[str, Any]]:
    return {
        row["test"]: {
            "true": to_int(row.get("true", "")),
            "false": to_int(row.get("false", "")),
            "time": row.get("time", ""),
        }
        for row in rows
    }


def plot_results(rows: list[dict[str, str]], plot_path: Path) -> None:
    row_map = build_row_map(rows)

    def get_true(test_name: str) -> int:
        return row_map.get(test_name, {"true": 0})["true"]

    bars: list[tuple[str, list[tuple[str, int]]]] = [
        (
            "main",
            [
                ("is_sticky", get_true("is_sticky")),
                ("is_left_sticky", get_true("is_left_sticky")),
                ("is_right_sticky", get_true("is_right_sticky")),
                ("is_rl_balanced", get_true("is_rl_balanced")),
            ],
        )
    ]

    for h in [0, 1, 2, 3, 4]:
        bars.append(
            (
                f"h={h}",
                [
                    (f"(is_height_x {h})", get_true(f"(is_height_x {h})")),
                    (f"(is_sticky_and_height_x {h})", get_true(f"(is_sticky_and_height_x {h})")),
                    (
                        f"(is_prop_and_height_x is_rl_balanced {h})",
                        get_true(f"(is_prop_and_height_x is_rl_balanced {h})"),
                    ),
                    (
                        f"(is_prop_and_height_x is_left_sticky {h})",
                        get_true(f"(is_prop_and_height_x is_left_sticky {h})"),
                    ),
                    (
                        f"(is_prop_and_height_x is_right_sticky {h})",
                        get_true(f"(is_prop_and_height_x is_right_sticky {h})"),
                    ),
                ],
            )
        )

    fig, ax = plt.subplots(figsize=(15, 7), constrained_layout=True)
    main_colors = ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"]
    height_colors = ["#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd"]
    shown_labels: set[str] = set()

    x_positions = list(range(len(bars)))
    for bar_index, (_, components) in enumerate(bars):
        n_components = len(components)
        offset_step = 0.07
        bar_width = 0.22

        for comp_index, (comp_name, value) in enumerate(components):
            if bar_index == 0:
                color = main_colors[comp_index % len(main_colors)]
                series_name = f"main: {comp_name}"
            else:
                color = height_colors[comp_index % len(height_colors)]
                series_name = f"height: {comp_name}"

            if series_name in shown_labels:
                label = "_nolegend_"
            else:
                label = series_name
                shown_labels.add(series_name)

            x_offset = (comp_index - (n_components - 1) / 2) * offset_step
            # Overlap bars in the same group (no stacking) so each bar remains on 0..1000 scale.
            ax.bar(
                bar_index + x_offset,
                value,
                width=bar_width,
                color=color,
                alpha=1.0,
                edgecolor="black",
                linewidth=1.2,
                label=label,
            )

    ax.set_title("Overlapped True Counts: Main and Heights 0-4")
    ax.set_ylabel("True count")
    ax.set_xlabel("Bar group")
    ax.set_xticks(x_positions)
    ax.set_xticklabels([name for name, _ in bars])
    ax.set_ylim(0, 1000)
    ax.grid(axis="y", alpha=0.3)
    ax.legend(loc="upper right", fontsize=8)

    fig.savefig(plot_path, dpi=180)
    plt.close(fig)


def plot_results_sticky_height(rows: list[dict[str, str]], plot_path: Path) -> None:
    row_map = build_row_map(rows)

    def get_true(test_name: str) -> int:
        return row_map.get(test_name, {"true": 0})["true"]

    bars: list[tuple[str, list[tuple[str, int]]]] = [
        (
            "main",
            [
                ("is_sticky", get_true("is_sticky")),
            ],
        )
    ]

    for h in range(11):  # 0 through 10
        bars.append(
            (
                f"h={h}",
                [
                    (f"(is_height_x {h})", get_true(f"(is_height_x {h})")),
                    (f"(is_sticky_and_height_x {h})", get_true(f"(is_sticky_and_height_x {h})")),
                ],
            )
        )

    fig, ax = plt.subplots(figsize=(15, 7), constrained_layout=True)
    main_color = "#1f77b4"
    height_colors = ["#ff7f0e", "#2ca02c"]
    shown_labels: set[str] = set()

    x_positions = list(range(len(bars)))
    for bar_index, (bar_name, components) in enumerate(bars):
        n_components = len(components)
        offset_step = 0.15
        bar_width = 0.3

        for comp_index, (comp_name, value) in enumerate(components):
            if bar_index == 0:
                # Main bar - single bar
                color = main_color
                series_name = "main: is_sticky"
            else:
                # Height bars - paired bars
                color = height_colors[comp_index % len(height_colors)]
                if "is_height_x" in comp_name and "sticky_and" not in comp_name:
                    series_name = "height: is_height_x"
                else:
                    series_name = "height: is_sticky_and_height_x"

            if series_name in shown_labels:
                label = "_nolegend_"
            else:
                label = series_name
                shown_labels.add(series_name)

            if n_components == 1:
                # Single bar (main)
                x_offset = 0
            else:
                # Paired bars (heights)
                x_offset = (comp_index - 0.5) * offset_step

            ax.bar(
                bar_index + x_offset,
                value,
                width=bar_width,
                color=color,
                alpha=0.9,
                edgecolor="black",
                linewidth=1.2,
                label=label,
            )

    ax.set_title("Height Tests: is_sticky, is_height_x and is_sticky_and_height_x (h=0 to 10)")
    ax.set_ylabel("True count")
    ax.set_xlabel("Test")
    ax.set_xticks(x_positions)
    ax.set_xticklabels([name for name, _ in bars], rotation=0)
    ax.set_ylim(0, 1000)
    ax.grid(axis="y", alpha=0.3)
    ax.legend(loc="upper right", fontsize=8)

    fig.savefig(plot_path, dpi=180)
    plt.close(fig)


def run_one_file(in_file: Path, csv_only: bool, height_plot: bool) -> int:
    out_file = in_file.with_name("qc_results.txt")
    csv_file = in_file.with_name("qc_results.csv")
    plot_file = in_file.with_name("qc_results_plot.png")
    plot_heights_file = in_file.with_name("qc_results_heights_plot.png")

    if csv_only:
        if not csv_file.exists():
            print(f"Missing CSV, cannot plot: {csv_file}")
            return 1

        rows = read_csv(csv_file)
        if height_plot:
            plot_results_sticky_height(rows, plot_heights_file)
            print(f"File: {in_file}")
            print(f"CSV mode: skipped coqc")
            print(f"Read CSV from {csv_file}")
            print(f"Wrote sticky height plot to {plot_heights_file}")
        else:
            plot_results(rows, plot_file)
            print(f"File: {in_file}")
            print(f"CSV mode: skipped coqc")
            print(f"Read CSV from {csv_file}")
            print(f"Wrote plot to {plot_file}")
        return 0

    try:
        result = subprocess.run(
            ["coqc", str(in_file)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            check=False,
        )
        output = result.stdout
    except FileNotFoundError as error:
        output = f"Failed to run coqc: {error}\n"

    out_file.write_text(output, encoding="utf-8")
    rows = parse_quickchick_output(output)
    write_csv(csv_file, rows)
    if height_plot:
        plot_results_sticky_height(rows, plot_heights_file)
        print(output, end="")
        print(f"File: {in_file}")
        print(f"Wrote output to {out_file}")
        print(f"Wrote CSV to {csv_file}")
        print(f"Wrote sticky height plot to {plot_heights_file}")
    else:
        plot_results(rows, plot_file)
        print(output, end="")
        print(f"File: {in_file}")
        print(f"Wrote output to {out_file}")
        print(f"Wrote CSV to {csv_file}")
        print(f"Wrote plot to {plot_file}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Run QuickChick Coq files and generate CSV/plots")
    parser.add_argument(
        "--csv",
        action="store_true",
        help="Skip coqc and generate plots from existing qc_results.csv files.",
    )
    parser.add_argument(
        "--heights",
        action="store_true",
        help="Generate additional sticky height plot (heights 0-10).",
    )
    parser.add_argument(
        "files",
        nargs="*",
        type=Path,
        help="Coq generator files to process. If not provided, processes files from in_files list.",
    )
    args = parser.parse_args()

    # Use provided files or fall back to in_files list
    files_to_process = args.files if args.files else in_files

    for in_file in files_to_process:
        run_one_file(in_file, csv_only=args.csv, height_plot=args.heights)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())