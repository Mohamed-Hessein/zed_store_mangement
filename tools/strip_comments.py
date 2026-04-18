#!/usr/bin/env python3
import sys
import os
import io
import re

# Strip comments from Dart files while preserving string literals (single, double, triple)
# Usage: python tools/strip_comments.py <path>

def strip_comments(code: str) -> str:
    i = 0
    n = len(code)
    out = []
    state = 'NORMAL'
    # states: NORMAL, SL_COMMENT, ML_COMMENT, S_QUOTE, D_QUOTE, TS_QUOTE, TD_QUOTE
    while i < n:
        ch = code[i]
        next2 = code[i:i+2]
        if state == 'NORMAL':
            if next2 == '//':
                state = 'SL_COMMENT'
                i += 2
                continue
            if next2 == '/*':
                state = 'ML_COMMENT'
                i += 2
                continue
            # triple quotes
            if code.startswith("'''", i):
                out.append("'''")
                i += 3
                state = 'TS_QUOTE'
                continue
            if code.startswith('"""', i):
                out.append('"""')
                i += 3
                state = 'TD_QUOTE'
                continue
            if ch == "'":
                out.append(ch)
                i += 1
                state = 'S_QUOTE'
                continue
            if ch == '"':
                out.append(ch)
                i += 1
                state = 'D_QUOTE'
                continue
            out.append(ch)
            i += 1
        elif state == 'SL_COMMENT':
            if ch == '\n':
                out.append(ch)
                state = 'NORMAL'
            i += 1
        elif state == 'ML_COMMENT':
            if code.startswith('*/', i):
                i += 2
                state = 'NORMAL'
            else:
                i += 1
        elif state == 'S_QUOTE':
            out.append(ch)
            if ch == "\\":
                # escape next
                if i+1 < n:
                    out.append(code[i+1])
                    i += 2
                    continue
            elif ch == "'":
                state = 'NORMAL'
            i += 1
        elif state == 'D_QUOTE':
            out.append(ch)
            if ch == '\\':
                if i+1 < n:
                    out.append(code[i+1])
                    i += 2
                    continue
            elif ch == '"':
                state = 'NORMAL'
            i += 1
        elif state == 'TS_QUOTE':
            out.append(ch)
            if code.startswith("'''", i):
                out.append("'''")
                i += 3
                state = 'NORMAL'
                continue
            i += 1
        elif state == 'TD_QUOTE':
            out.append(ch)
            if code.startswith('"""', i):
                out.append('"""')
                i += 3
                state = 'NORMAL'
                continue
            i += 1
        else:
            out.append(ch)
            i += 1
    return ''.join(out)


def process_file(path, make_backup=True):
    try:
        with io.open(path, 'r', encoding='utf-8') as f:
            src = f.read()
    except Exception as e:
        print(f"[SKIP] Could not read {path}: {e}")
        return
    cleaned = strip_comments(src)
    if cleaned == src:
        print(f"[OK] No changes for {path}")
        return
    if make_backup:
        backup = path + '.bak'
        try:
            with io.open(backup, 'w', encoding='utf-8') as bf:
                bf.write(src)
            print(f"[BACKUP] {backup}")
        except Exception as e:
            print(f"[WARN] Could not write backup for {path}: {e}")
    try:
        with io.open(path, 'w', encoding='utf-8') as f:
            f.write(cleaned)
        print(f"[CLEANED] {path}")
    except Exception as e:
        print(f"[ERROR] Could not write {path}: {e}")


def walk_and_clean(root):
    for dirpath, dirnames, filenames in os.walk(root):
        for name in filenames:
            if name.endswith('.dart'):
                full = os.path.join(dirpath, name)
                process_file(full)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python tools/strip_comments.py <path-to-clean>')
        sys.exit(1)
    target = sys.argv[1]
    if os.path.isfile(target) and target.endswith('.dart'):
        process_file(target)
    elif os.path.isdir(target):
        walk_and_clean(target)
    else:
        print('Path not found or not a Dart file')

