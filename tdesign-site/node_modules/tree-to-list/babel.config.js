module.exports = {
    presets: [
        ['@babel/env', {
            modules: false,
        }],
    ],
    plugins: [
        ['@babel/transform-object-assign'],
    ],
};
