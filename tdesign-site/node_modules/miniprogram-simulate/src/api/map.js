/* eslint-disable class-methods-use-this */
const _ = require('./utils')

class MapContext {
    constructor(id, parent) {
        this._exparserNode = parent.selectComponent(`#${id}`)
    }

    getCenterLocation(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getMapCenterLocation:ok',
            latitude: 39.92,
            longitude: 116.46,
        })
    }

    getRegion(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getMapRegion:ok',
            northeast: {
                latitude: 39.92493685384383,
                longitude: 116.47287460327148,
            },
            southwest: {
                latitude: 39.91506279020459,
                longitude: 116.44712539672851,
            },
        })
    }

    getScale(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getMapScale:ok',
            scale: 14,
        })
    }

    get includePoints() {
        return _.mockAsync('includePoints')
    }

    get moveToLocation() {
        return _.mockSync(null)
    }

    get translateMarker() {
        return _.mockAsync('translateMarker')
    }
}

module.exports = MapContext
