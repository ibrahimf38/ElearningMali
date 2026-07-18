from pathlib import Path
import re

root = Path('lib')
unit_pattern = re.compile(r'\.(?:w|h|sp|r)\b')
const_pattern = re.compile(r'\bconst\b')

changed_files = []

for path in sorted(root.rglob('*.dart')):
    text = path.read_text(encoding='utf-8')
    i = 0
    out = []
    modified = False

    while i < len(text):
        m = const_pattern.search(text, i)
        if not m:
            out.append(text[i:])
            break

        # skip if const is inside comment line only
        line_start = text.rfind('\n', 0, m.start()) + 1
        line = text[line_start:text.find('\n', line_start)]
        stripped = line.lstrip()
        if stripped.startswith('//'):
            out.append(text[i:m.end()])
            i = m.end()
            continue

        # parse the constructor/expression after const
        j = m.end()
        depth = 0
        in_string = False
        string_char = ''
        escaped = False
        while j < len(text):
            ch = text[j]
            if in_string:
                if escaped:
                    escaped = False
                elif ch == '\\':
                    escaped = True
                elif ch == string_char:
                    in_string = False
            else:
                if ch in ('"', "'"):
                    in_string = True
                    string_char = ch
                elif ch == '(':
                    depth += 1
                elif ch == ')':
                    if depth == 0:
                        j += 1
                        break
                    depth -= 1
                elif ch == ';' and depth == 0:
                    j += 1
                    break
            j += 1

        segment = text[m.end():j]
        if unit_pattern.search(segment):
            out.append(text[i:m.start()])
            modified = True
            i = m.end()
            # skip the const keyword only, keep the rest
            while i < len(text) and text[i].isspace():
                # preserve whitespace after const if any
                i += 1
            continue

        out.append(text[i:j])
        i = j

    if modified:
        path.write_text(''.join(out), encoding='utf-8')
        changed_files.append(str(path))
        print(f'fixed {path}')

print(f'changed {len(changed_files)} files')
