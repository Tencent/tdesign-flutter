import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const packageDirectory = path.resolve(scriptDirectory, '..');
const siteDirectory = path.join(packageDirectory, 'site');
const exampleDirectory = path.resolve(packageDirectory, '../tdesign-component/example');
const viteEntry = path.join(packageDirectory, 'node_modules/vite/bin/vite.js');
const flutterExecutable = process.platform === 'win32' ? 'flutter.bat' : 'flutter';

const children = [
  spawn(
    flutterExecutable,
    [
      'run',
      '-d',
      'web-server',
      '--web-hostname',
      '127.0.0.1',
      '--web-port',
      process.env.VITE_FLUTTER_WEB_PORT || '19001',
      '-t',
      'lib/main.dart',
    ],
    { cwd: exampleDirectory, stdio: 'inherit' },
  ),
  spawn(process.execPath, [viteEntry], {
    cwd: siteDirectory,
    stdio: 'inherit',
  }),
];

let stopping = false;

function stop(signal = 'SIGTERM') {
  if (stopping) {
    return;
  }
  stopping = true;
  for (const child of children) {
    if (!child.killed) {
      child.kill(signal);
    }
  }
}

for (const signal of ['SIGINT', 'SIGTERM']) {
  process.on(signal, () => stop(signal));
}

for (const child of children) {
  child.on('error', (error) => {
    console.error(error);
    process.exitCode = 1;
    stop();
  });
  child.on('exit', (code, signal) => {
    if (!stopping && code !== 0) {
      process.exitCode = code ?? 1;
      console.error(`Development process exited (${signal ?? code}).`);
      stop();
    }
  });
}
