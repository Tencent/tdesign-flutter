class Animation {
    constructor(option = {}) {
        this.actions = []
        this.currentTransform = []
        this.currentStepAnimates = []

        this.option = {
            transition: {
                duration: option.duration !== undefined ? option.duration : 400,
                timingFunction: option.timingFunction !== undefined ? option.timingFunction : 'linear',
                delay: option.delay !== undefined ? option.delay : 0,
            },
            transformOrigin: option.transformOrigin || '50% 50% 0',
        }
    }

    export() {
        const actions = this.actions
        this.actions = []
        return {actions}
    }

    step(option = {}) {
        this.currentStepAnimates.forEach((animate) => {
            if (animate.type !== 'style') {
                this.currentTransform[animate.type] = animate
            } else {
                this.currentTransform[`${animate.type}.${animate.args[0]}`] = animate
            }
        })

        this.actions.push({
            animates: Object.keys(this.currentTransform).reduce((prev, key) => [...prev, this.currentTransform[key]], []),
            option: {
                transformOrigin: option.transformOrigin !== undefined ? option.transformOrigin : this.option.transformOrigin,
                transition: {
                    duration: option.duration !== undefined ? option.duration : this.option.transition.duration,
                    timingFunction: option.timingFunction !== undefined ? option.timingFunction : this.option.transition.timingFunction,
                    delay: option.delay !== undefined ? option.delay : this.option.transition.delay,
                },
            },
        })

        this.currentStepAnimates = []
        return this
    }

    matrix(a = 1, b = 0, c = 0, d = 1, tx = 1, ty = 1) {
        this.currentStepAnimates.push({type: 'matrix', args: [a, b, c, d, tx, ty]})
        return this
    }

    matrix3d(a1 = 1, b1 = 0, c1 = 0, d1 = 0, a2 = 0, b2 = 1, c2 = 0, d2 = 0, a3 = 0, b3 = 0, c3 = 1, d3 = 0, a4 = 0, b4 = 0, c4 = 0, d4 = 1) {
        this.currentStepAnimates.push({type: 'matrix3d', args: [a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4]})
        this.stepping = false
        return this
    }

    rotate(angle = 0) {
        this.currentStepAnimates.push({type: 'rotate', args: [angle]})
        return this
    }

    rotate3d(x = 0, y = 0, z = 0, a = 0) {
        this.currentStepAnimates.push({type: 'rotate3d', args: [x, y, z, a]})
        this.stepping = false
        return this
    }

    rotateX(a = 0) {
        this.currentStepAnimates.push({type: 'rotateX', args: [a]})
        this.stepping = false
        return this
    }

    rotateY(a = 0) {
        this.currentStepAnimates.push({type: 'rotateY', args: [a]})
        this.stepping = false
        return this
    }

    rotateZ(a = 0) {
        this.currentStepAnimates.push({type: 'rotateZ', args: [a]})
        this.stepping = false
        return this
    }

    scale(sx = 1, sy) {
        this.currentStepAnimates.push({type: 'scale', args: [sx, sy !== undefined ? sy : sx]})
        return this
    }

    scale3d(sx = 1, sy = 1, sz = 1) {
        this.currentStepAnimates.push({type: 'scale3d', args: [sx, sy, sz]})
        return this
    }

    scaleX(s = 1) {
        this.currentStepAnimates.push({type: 'scaleX', args: [s]})
        return this
    }

    scaleY(s = 1) {
        this.currentStepAnimates.push({type: 'scaleY', args: [s]})
        return this
    }

    scaleZ(s = 1) {
        this.currentStepAnimates.push({type: 'scaleZ', args: [s]})
        return this
    }

    skew(ax = 0, ay = 0) {
        this.currentStepAnimates.push({type: 'skew', args: [ax, ay]})
        return this
    }

    skewX(a = 0) {
        this.currentStepAnimates.push({type: 'skewX', args: [a]})
        return this
    }

    skewY(a = 0) {
        this.currentStepAnimates.push({type: 'skewY', args: [a]})
        return this
    }

    translate(tx = 0, ty = 0) {
        this.currentStepAnimates.push({type: 'translate', args: [tx, ty]})
        return this
    }

    translate3d(tx = 0, ty = 0, tz = 0) {
        this.currentStepAnimates.push({type: 'translate3d', args: [tx, ty, tz]})
        return this
    }

    translateX(t = 0) {
        this.currentStepAnimates.push({type: 'translateX', args: [t]})
        return this
    }

    translateY(t = 0) {
        this.currentStepAnimates.push({type: 'translateY', args: [t]})
        return this
    }

    translateZ(t = 0) {
        this.currentStepAnimates.push({type: 'translateZ', args: [t]})
        return this
    }

    opacity(value) {
        this.currentStepAnimates.push({type: 'style', args: ['opacity', value]})
        return this
    }

    backgroundColor(value) {
        this.currentStepAnimates.push({type: 'style', args: ['background-color', value]})
        return this
    }

    width(value) {
        this.currentStepAnimates.push({type: 'style', args: ['width', typeof value === 'number' ? value + 'px' : value]})
        return this
    }

    height(value) {
        this.currentStepAnimates.push({type: 'style', args: ['height', typeof value === 'number' ? value + 'px' : value]})
        return this
    }

    left(value) {
        this.currentStepAnimates.push({type: 'style', args: ['left', typeof value === 'number' ? value + 'px' : value]})
        return this
    }

    right(value) {
        this.currentStepAnimates.push({type: 'style', args: ['right', typeof value === 'number' ? value + 'px' : value]})
        return this
    }

    top(value) {
        this.currentStepAnimates.push({type: 'style', args: ['top', typeof value === 'number' ? value + 'px' : value]})
        return this
    }

    bottom(value) {
        this.currentStepAnimates.push({type: 'style', args: ['bottom', typeof value === 'number' ? value + 'px' : value]})
        return this
    }
}

module.exports = Animation
