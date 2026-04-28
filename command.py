import subprocess
import argparse
import shlex

parser = argparse.ArgumentParser(description="run a Loaded Dice command")
parser.add_argument("name", default="ST", help="name of generator")
parser.add_argument("type", default="sKVTree", help="type for generator")
parser.add_argument("method", default="SpecEntropy", help="type for generator")
parser.add_argument("--prop", default="satisfies_stickyness", help="type for generator")
parser.add_argument("--valid", default="isST", help="type for generator")
parser.add_argument("-s", "--sibling", action="store_true", help="using sibling derive or not")
parser.add_argument("--size", type=int, default=4, help="initial calling size")
parser.add_argument("--stack", type=int, default=1, help="stack size")
parser.add_argument("--intwidth", type=int, default=3, help="intwidth")
parser.add_argument("--speed", type=float, default=0.3, help="speedx")
parser.add_argument("--epoch", type=int, default=2000, help="# rounds of tuning")
parser.add_argument("--bound", type=float, default=0.1, help="# rounds of tuning")

args = parser.parse_args()

if (args.sibling):
    derive = "LangSiblingDerivedGenerator"
else:
    derive = "LangDerivedGenerator"

if (args.method == "SpecEntropy"):
    prop = f"2,200,{args.valid}"
else:
    prop = args.prop

cmd = f"julia --project experiments/tool.jl -f " \
  f"\"{derive}{{{args.name}}}(Main.{args.type}.t,Pair{{Type,Integer}}[Main.{args.type}.t=>{args.size}],{args.stack},{args.intwidth})\" " \
  f"\"Pair{{{args.method}{{{args.name}}},Float64}}[{args.method}{{{args.name}}}({prop})=>{args.speed}]\" " \
  f"{args.epoch} {args.bound}"

print(cmd)

subprocess.run(shlex.split(cmd), check=True)