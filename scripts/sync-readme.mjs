// Compatibility entry used by the existing repository and site workflows.
import { syncDocuments } from './documentation.mjs';

const args = process.argv.slice(2);
if (args.some(arg => arg !== '--check')) throw new Error('Usage: node scripts/sync-readme.mjs [--check]');
try {
  syncDocuments({ check: args.includes('--check') });
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
