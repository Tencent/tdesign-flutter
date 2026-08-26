#!/usr/bin/env python3
"""校验指定组件生产源码的 LCOV 行覆盖率门禁。"""

import argparse
import sys


COMPONENT_TARGETS = {
    'refresh': (
        'lib/src/components/refresh/t_pull_down_refresh.dart',
        'lib/src/components/refresh/t_pull_down_refresh_controller.dart',
        'lib/src/components/refresh/t_pull_down_refresh_texts.dart',
    ),
    'switch': (
        'lib/src/components/switch/',
    ),
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description='校验组件生产源码的 LCOV 行覆盖率门禁。',
    )
    parser.add_argument('component', choices=COMPONENT_TARGETS)
    parser.add_argument('--threshold', type=float, default=95.0)
    parser.add_argument('--lcov', default='coverage/lcov.info')
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    targets = COMPONENT_TARGETS[args.component]
    current = False
    lf = lh = 0
    matched_files = []

    try:
        with open(args.lcov, encoding='utf-8') as file:
            for raw in file:
                line = raw.rstrip('\n')
                if line.startswith('SF:'):
                    path = line[3:]
                    current = any(target in path for target in targets)
                    if current:
                        matched_files.append(path)
                    continue
                if not current:
                    continue
                if line.startswith('LF:'):
                    lf += int(line[3:])
                elif line.startswith('LH:'):
                    lh += int(line[3:])
                elif line == 'end_of_record':
                    current = False
    except OSError as error:
        print(f'ERROR: cannot read {args.lcov}: {error}')
        return 1

    print(f'{args.component} matched files:')
    for path in matched_files:
        print(f'  - {path}')

    if lf == 0:
        print(f'NO {args.component} coverage data found in {args.lcov}')
        return 1

    ratio = lh / lf * 100
    print(
        f'{args.component} production LH/LF = {lh}/{lf} = {ratio:.2f}%'
    )
    if ratio < args.threshold:
        print(
            f'ERROR: {args.component} production coverage below '
            f'{args.threshold:g}% threshold'
        )
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
