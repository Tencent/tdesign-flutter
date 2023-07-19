/* eslint-disable class-methods-use-this */
class UpdateManager {
    constructor() {
        this.updateCallback = null
    }

    applyUpdate() {
        setTimeout(() => {
            if (this.updateCallback && typeof this.updateCallback === 'function') {
                this.updateCallback()
            }
        }, 0)
    }

    onCheckForUpdate(callback) {
        setTimeout(() => {
            if (callback && typeof callback === 'function') {
                callback({hasUpdate: true})
            }
        }, 0)
    }

    onUpdateFailed() {}

    onUpdateReady(callback) {
        this.updateCallback = callback
    }
}

module.exports = UpdateManager
