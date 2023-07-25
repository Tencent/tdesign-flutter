/**
 * Convert Windows backslash paths to slash paths: foo\\bar ➔ foo/bar
 *
 * @param  path
 * @return  slashed path
 */
exports.slash = (path) => {
    const isExtendedLengthPath = /^\\\\\?\\/.test(path);

    if (isExtendedLengthPath) {
        return path;
    }

    return path.replace(/\\/g, '/');
};
