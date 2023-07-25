const _ = require('./utils')

/**
 * Touch polyfill
 */
class Touch {
    constructor(options = {}) {
        this.clientX = 0
        this.clientY = 0
        this.identifier = 0
        this.pageX = 0
        this.pageY = 0
        this.screenX = 0
        this.screenY = 0
        this.target = null

        Object.keys(options).forEach(key => {
            this[key] = options[key]
        })
    }
}

module.exports = function() {
    if (_.getEnv() === 'nodejs') {
        try {
            global.Touch = window.Touch = Touch
        } catch (err) {
            // ignore
        }
    }
}
