#!/usr/bin/env python3
"""校验 TPullDownRefresh 生产源码的 LCOV 覆盖率门禁（LH/LF >= 95%）。

从 `flutter test --coverage` 生成的 `coverage/lcov.info` 中，过滤出 refresh
生产源码文件，累加其 LF（lines found）与 LH（lines hit），计算行覆盖率，
低于阈值（默认 95%）则以非零退出码结束（供 CI 门禁使用）。
"""
import sys

TARGETS = (
    'lib/src/components/refresh/t_pull_down_refresh.dart',
    'lib/src/components/refresh/t_pull_down_refresh_controller.dart',
    'lib/src/components/refresh/t_pull_down_refresh_texts.dart',
)

THRESHOLD = 95.0


def main() -> int:
    lcov_path = 'coverage/lcov.info'
    current = False
    lf = lh = 0
    matched_files = []
    try:
        with open(lcov_path, encoding='utf-8') as f:
            for raw in f:
                line = raw.rstrip('\n')
                if line.startswith('SF:'):
                    path = line[3:]
                    current = any(path.endswith(t) for t in TARGETS)
                    if current:
                        matched_files.append(path)
                    continue
                if not current:
                    if line.startswith('end_of_record'):
                        current = False
                    continue
                if line.startswith('LF:'):
                    lf += int(line[3:])
                elif line.startswith('LH:'):
                    lh += int(line[3:])
                elif line.startswith('end_of_record'):
                    current = False
    except OSError as e:
        print(f'ERROR: cannot read {lcov_path}: {e}')
        return 1

    print('refresh matched files:')
    for p in matched_files:
        print(f'  - {p}')

    if lf == 0:
        print('NO refresh coverage data found in lcov.info')
        return 1
    ratio = lh / lf * 100
    print(f'refresh production LH/LF = {lh}/{lf} = {ratio:.1f}%')
    if ratio < THRESHOLD:
        print(f'ERROR: refresh production coverage below {THRESHOLD:.0f}% threshold')
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
