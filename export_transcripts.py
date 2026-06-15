#!/usr/bin/env python3
"""Export Cursor agent transcripts to Markdown (+ raw .jsonl copies).

Usage:
  python3 export_transcripts.py [--out DIR] [SLUG ...]

With no SLUG args, exports every project under ~/.cursor/projects that has
transcripts, into per-project subfolders. Pass one or more slug names (or
substrings) to limit the export.
"""
import json, glob, os, re, sys, shutil, argparse

PROJECTS = os.path.expanduser("~/.cursor/projects")

def clean_user(text):
    ts = re.search(r"<timestamp>(.*?)</timestamp>", text, re.S)
    q = re.search(r"<user_query>(.*?)</user_query>", text, re.S)
    out = []
    if ts: out.append(f"*{ts.group(1).strip()}*\n")
    out.append(q.group(1).strip() if q else text.strip())
    return "\n".join(out)

def render(path):
    lines = [json.loads(l) for l in open(path) if l.strip()]
    md, title = [], None
    for d in lines:
        if d.get("type") == "turn_ended":
            md.append("\n---\n"); continue
        role = d.get("role")
        content = d.get("message", {}).get("content")
        if not isinstance(content, list): continue
        if role == "user":
            for c in content:
                if c.get("type") == "text":
                    if title is None:
                        q = re.search(r"<user_query>(.*?)</user_query>", c["text"], re.S)
                        title = (q.group(1).strip() if q else c["text"].strip())[:80]
                    md.append(f"## User\n\n{clean_user(c['text'])}\n")
        elif role == "assistant":
            parts = []
            for c in content:
                if c.get("type") == "text" and c["text"].strip():
                    parts.append(c["text"].strip())
                elif c.get("type") == "tool_use":
                    inp = json.dumps(c.get("input", {}), indent=2, ensure_ascii=False)
                    parts.append(f"**Tool call: `{c.get('name','tool')}`**\n\n```json\n{inp}\n```")
            if parts:
                md.append("## Assistant\n\n" + "\n\n".join(parts) + "\n")
    header = f"# {title or 'Transcript'}\n\nSource: `{os.path.basename(path)}`\n\n---\n\n"
    return header + "\n".join(md)

def export_project(slug, out_base):
    src = os.path.join(PROJECTS, slug, "agent-transcripts")
    files = glob.glob(os.path.join(src, "**", "*.jsonl"), recursive=True)
    if not files: return 0
    out_dir = os.path.join(out_base, slug)
    os.makedirs(out_dir, exist_ok=True)
    for f in files:
        uuid = os.path.basename(f).replace(".jsonl", "")
        open(os.path.join(out_dir, uuid + ".md"), "w").write(render(f))
        shutil.copy2(f, os.path.join(out_dir, uuid + ".jsonl"))
    return len(files)

class HelpfulParser(argparse.ArgumentParser):
    def error(self, message):
        sys.stderr.write(f"error: {message}\n\n")
        self.print_help(sys.stderr)
        sys.exit(2)

def main():
    ap = HelpfulParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument("--out", default=os.path.dirname(os.path.abspath(__file__)),
                    help="output directory (default: script directory)")
    ap.add_argument("slugs", nargs="*",
                    help="project slug names or substrings to limit the export")
    a = ap.parse_args()
    all_slugs = sorted(os.listdir(PROJECTS))
    if a.slugs:
        sel = [s for s in all_slugs if any(p in s for p in a.slugs)]
    else:
        sel = all_slugs
    tp = tt = 0
    for slug in sel:
        n = export_project(slug, a.out)
        if n:
            tp += 1; tt += n
            print(f"  {n:>3}  {slug}")
    print(f"\nExported {tt} transcripts across {tp} projects -> {a.out}")

if __name__ == "__main__":
    main()
