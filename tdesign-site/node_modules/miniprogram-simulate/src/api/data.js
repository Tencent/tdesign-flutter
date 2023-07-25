/* global localStorage */
const _ = require('./utils')

module.exports = {
    clearStorage(options) {
        const res = {errMsg: 'clearStorage:ok'}
        try {
            wx.clearStorageSync()
        } catch (err) {
            res.errMsg = `clearStorage:fail ${err.message}`
        }

        _.runInAsync(options, res)
    },
    clearStorageSync() {
        localStorage.clear()
    },
    getStorage(options) {
        const res = {errMsg: 'getStorage:ok'}
        try {
            res.data = wx.getStorageSync(options.key)
        } catch (err) {
            res.errMsg = `getStorage:fail ${err.message}`
        }

        _.runInAsync(options, res)
    },
    getStorageSync(key) {
        const res = localStorage.getItem(key)
        try {
            return JSON.parse(res)
        } catch (err) {
            return res
        }
    },
    getStorageInfo(options) {
        let res = {errMsg: 'getStorageInfo:ok'}
        try {
            const data = wx.getStorageInfoSync()
            res = Object.assign(res, data)
        } catch (err) {
            res.errMsg = `getStorageInfo:fail ${err.message}`
        }

        _.runInAsync(options, res)
    },
    getStorageInfoSync() {
        const length = localStorage.length
        const keys = []
        let currentSize = 0

        for (let i = 0; i < length; i++) {
            const key = localStorage.key(i)
            keys.push(key)
            currentSize += _.getSize(localStorage.getItem(key))
        }

        return {
            keys,
            currentSize,
            limitSize: 1024 * 10,
        }
    },
    removeStorage(options) {
        const res = {errMsg: 'removeStorage:ok'}
        try {
            wx.removeStorageSync(options.key)
        } catch (err) {
            res.errMsg = `removeStorage:fail ${err.message}`
        }

        _.runInAsync(options, res)
    },
    removeStorageSync(key) {
        localStorage.removeItem(key)
    },
    setStorage(options) {
        const res = {errMsg: 'setStorage:ok'}
        try {
            wx.setStorageSync(options.key, options.data)
        } catch (err) {
            res.errMsg = `setStorage:fail ${err.message}`
        }

        _.runInAsync(options, res)
    },
    setStorageSync(key, data) {
        localStorage.setItem(key, JSON.stringify(data))
    },
}
