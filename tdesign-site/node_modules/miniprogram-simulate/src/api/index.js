const Animation = require('./animation')
const MapContext = require('./map')
const UpdateManager = require('./update-manager')
const dataApi = require('./data')
const openApi = require('./open')
const _ = require('./utils')

let nextTickQueue = []
let nextTickTimer = null

module.exports = {
    request: _.mockAsync('request'),

    uploadFile: _.mockAsync('uploadFile'),
    downloadFile: _.mockAsync('downloadFile'),

    connectSocket: _.mockAsync('connectSocket'),
    onSocketOpen: _.mockAsync('onSocketOpen'),
    onSocketError: _.mockAsync('onSocketError'),
    sendSocketMessage: _.mockAsync('sendSocketMessage'),
    onSocketMessage: _.mockAsync('onSocketMessage'),
    closeSocket: _.mockAsync('closeSocket'),
    onSocketClose: _.mockAsync('onSocketClose'),

    chooseImage: _.mockAsync('chooseImage'),
    previewImage: _.mockAsync('previewImage'),
    getImageInfo: _.mockAsync('getImageInfo'),
    saveImageToPhotosAlbum: _.mockAsync('saveImageToPhotosAlbum'),

    startRecord: _.mockAsync('startRecord'),
    stopRecord: _.mockAsync('stopRecord'),

    getRecorderManager: _.mockAsync('getRecorderManager'),

    playVoice: _.mockAsync('playVoice'),
    pauseVoice: _.mockAsync('pauseVoice'),
    stopVoice: _.mockAsync('stopVoice'),

    getBackgroundAudioPlayerState: _.mockAsync('getBackgroundAudioPlayerState'),
    playBackgroundAudio: _.mockAsync('playBackgroundAudio'),
    pauseBackgroundAudio: _.mockAsync('pauseBackgroundAudio'),
    seekBackgroundAudio: _.mockAsync('seekBackgroundAudio'),
    stopBackgroundAudio: _.mockAsync('stopBackgroundAudio'),
    onBackgroundAudioPlay: _.mockAsync('onBackgroundAudioPlay'),
    onBackgroundAudioPause: _.mockAsync('onBackgroundAudioPause'),
    onBackgroundAudioStop: _.mockAsync('onBackgroundAudioStop'),

    getBackgroundAudioManager: _.mockAsync('getBackgroundAudioManager'),

    createAudioContext: _.mockAsync('createAudioContext'),
    createInnerAudioContext: _.mockAsync('createInnerAudioContext'),
    getAvailableAudioSources: _.mockAsync('getAvailableAudioSources'),

    chooseVideo: _.mockAsync('chooseVideo'),
    saveVideoToPhotosAlbum: _.mockAsync('saveVideoToPhotosAlbum'),

    createVideoContext: _.mockAsync('createVideoContext'),

    createCameraContext: _.mockAsync('createCameraContext'),

    createLivePlayerContext: _.mockAsync('createLivePlayerContext'),
    createLivePusherContext: _.mockAsync('createLivePusherContext'),

    loadFontFace: _.mockAsync('loadFontFace'),

    saveFile: _.mockAsync('saveFile'),
    getFileInfo: _.mockAsync('getFileInfo'),
    getSavedFileList: _.mockAsync('getSavedFileList'),
    getSavedFileInfo: _.mockAsync('getSavedFileInfo'),
    removeSavedFile: _.mockAsync('removeSavedFile'),
    openDocument: _.mockAsync('openDocument'),

    onMemoryWarning: _.mockAsync('onMemoryWarning'),

    getNetworkType: _.mockAsync('getNetworkType'),
    onNetworkStatusChange: _.mockAsync('onNetworkStatusChange'),

    onAccelerometerChange: _.mockAsync('onAccelerometerChange'),
    startAccelerometer: _.mockAsync('startAccelerometer'),
    stopAccelerometer: _.mockAsync('stopAccelerometer'),

    onCompassChange: _.mockAsync('onCompassChange'),
    startCompass: _.mockAsync('startCompass'),
    stopCompass: _.mockAsync('stopCompass'),

    makePhoneCall: _.mockAsync('makePhoneCall'),

    scanCode: _.mockAsync('scanCode'),

    setClipboardData: _.mockAsync('setClipboardData'),
    getClipboardData: _.mockAsync('getClipboardData'),

    openBluetoothAdapter: _.mockAsync('openBluetoothAdapter'),
    closeBluetoothAdapter: _.mockAsync('closeBluetoothAdapter'),
    getBluetoothAdapterState: _.mockAsync('getBluetoothAdapterState'),
    onBluetoothAdapterStateChange: _.mockAsync('onBluetoothAdapterStateChange'),
    startBluetoothDevicesDiscovery: _.mockAsync('startBluetoothDevicesDiscovery'),
    stopBluetoothDevicesDiscovery: _.mockAsync('stopBluetoothDevicesDiscovery'),
    getBluetoothDevices: _.mockAsync('getBluetoothDevices'),
    getConnectedBluetoothDevices: _.mockAsync('getConnectedBluetoothDevices'),
    onBluetoothDeviceFound: _.mockAsync('onBluetoothDeviceFound'),
    createBLEConnection: _.mockAsync('createBLEConnection'),
    closeBLEConnection: _.mockAsync('closeBLEConnection'),
    getBLEDeviceServices: _.mockAsync('getBLEDeviceServices'),
    getBLEDeviceCharacteristics: _.mockAsync('getBLEDeviceCharacteristics'),
    readBLECharacteristicValue: _.mockAsync('readBLECharacteristicValue'),
    writeBLECharacteristicValue: _.mockAsync('writeBLECharacteristicValue'),
    notifyBLECharacteristicValueChange: _.mockAsync('notifyBLECharacteristicValueChange'),
    onBLEConnectionStateChange: _.mockAsync('onBLEConnectionStateChange'),
    onBLECharacteristicValueChange: _.mockAsync('onBLECharacteristicValueChange'),

    startBeaconDiscovery: _.mockAsync('startBeaconDiscovery'),
    stopBeaconDiscovery: _.mockAsync('stopBeaconDiscovery'),
    getBeacons: _.mockAsync('getBeacons'),
    onBeaconUpdate: _.mockAsync('onBeaconUpdate'),
    onBeaconServiceChange: _.mockAsync('onBeaconServiceChange'),

    setScreenBrightness: _.mockAsync('setScreenBrightness'),
    getScreenBrightness: _.mockAsync('getScreenBrightness'),
    setKeepScreenOn: _.mockAsync('setKeepScreenOn'),

    onUserCaptureScreen: _.mockAsync('onUserCaptureScreen'),

    vibrateLong: _.mockAsync('vibrateLong'),
    vibrateShort: _.mockAsync('vibrateShort'),

    addPhoneContact: _.mockAsync('addPhoneContact'),

    getHCEState: _.mockAsync('getHCEState'),
    startHCE: _.mockAsync('startHCE'),
    stopHCE: _.mockAsync('stopHCE'),
    onHCEMessage: _.mockAsync('onHCEMessage'),
    sendHCEMessage: _.mockAsync('sendHCEMessage'),

    startWifi: _.mockAsync('startWifi'),
    stopWifi: _.mockAsync('stopWifi'),
    connectWifi: _.mockAsync('connectWifi'),
    getWifiList: _.mockAsync('getWifiList'),
    onGetWifiList: _.mockAsync('onGetWifiList'),
    setWifiList: _.mockAsync('setWifiList'),
    onWifiConnected: _.mockAsync('onWifiConnected'),
    getConnectedWifi: _.mockAsync('getConnectedWifi'),

    showToast: _.mockAsync('showToast'),
    showLoading: _.mockAsync('showLoading'),
    hideToast: _.mockAsync('hideToast'),
    hideLoading: _.mockAsync('hideLoading'),
    showModal: _.mockAsync('showModal'),
    showActionSheet: _.mockAsync('showActionSheet'),

    setNavigationBarTitle: _.mockAsync('setNavigationBarTitle'),
    showNavigationBarLoading: _.mockAsync('showNavigationBarLoading'),
    hideNavigationBarLoading: _.mockAsync('hideNavigationBarLoading'),
    setNavigationBarColor: _.mockAsync('setNavigationBarColor'),

    setTabBarBadge: _.mockAsync('setTabBarBadge'),
    removeTabBarBadge: _.mockAsync('removeTabBarBadge'),
    showTabBarRedDot: _.mockAsync('showTabBarRedDot'),
    hideTabBarRedDot: _.mockAsync('hideTabBarRedDot'),
    setTabBarStyle: _.mockAsync('setTabBarStyle'),
    setTabBarItem: _.mockAsync('setTabBarItem'),
    showTabBar: _.mockAsync('showTabBar'),
    hideTabBar: _.mockAsync('hideTabBar'),

    setBackgroundColor: _.mockAsync('setBackgroundColor'),
    setBackgroundTextStyle: _.mockAsync('setBackgroundTextStyle'),

    setTopBarText: _.mockAsync('setTopBarText'),

    createAnimation(transition = {}) {
        return new Animation(transition)
    },

    pageScrollTo: _.mockAsync('pageScrollTo'),

    createCanvasContext: _.mockAsync('createCanvasContext'),
    createContext: _.mockAsync('createContext'),
    drawCanvas: _.mockAsync('drawCanvas'),
    canvasToTempFilePath: _.mockAsync('canvasToTempFilePath'),
    canvasGetImageData: _.mockAsync('canvasGetImageData'),
    canvasPutImageData: _.mockAsync('canvasPutImageData'),

    startPullDownRefresh: _.mockAsync('startPullDownRefresh'),
    stopPullDownRefresh: _.mockAsync('stopPullDownRefresh'),

    createWorker: _.mockAsync('createWorker'),

    // network
    // TODO

    // media
    // TOOD

    // file
    // TODO

    // data
    ...dataApi,

    // location
    chooseLocation(options = {}) {
        _.runInAsync(options, {
            errMsg: 'chooseLocation:ok',
            address: '广东省广州市海珠区tit创意园品牌街',
            name: '腾讯微信总部',
            latitude: 23.1001,
            longitude: 113.32456,
        })
    },
    getLocation(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getLocation:ok',
            accuracy: 65,
            altitude: 0,
            latitude: 23.12908,
            longitude: 113.26436,
            speed: -1,
            verticalAccuracy: 65,
            horizontalAccuracy: 65,
        })
    },
    openLocation: _.mockAsync('openLocation'),

    // device
    // TODO

    // open
    ...openApi,

    // update
    getUpdateManager() {
        return new UpdateManager()
    },

    // worker
    // TODO

    // report
    reportMonitor: _.mockSync(null),

    // miniprogram
    // TODO

    // base
    canIUse: _.mockSync(true),

    // canvas
    // TODO

    // debug
    getLogManager: _.mockSync(console),
    setEnableDebug: _.mockSync(null),

    // thirdparty
    getExtConfig(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getExtConfig:ok',
            extConfig: wx.getExtConfigSync(),
        })
    },
    getExtConfigSync() {
        return {}
    },

    // map
    createMapContext(...args) {
        return new MapContext(...args)
    },

    // route
    navigateTo: _.mockAsync('navigateTo'),
    redirectTo: _.mockAsync('redirectTo'),
    switchTab: _.mockAsync('switchTab'),
    navigateBack: _.mockAsync('navigateBack'),
    reLaunch: _.mockAsync('reLaunch'),

    // share
    getShareInfo(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getShareInfo:ok',
            encryptedData: 'CiyLU1Aw2KjvrjMdj8YKliAjtP4gsMZMQmRzooG2xrDcvSnxIMXFufNstNGTyaGS9uT5geRa0W4oTOb1WT7fJlAC+oNPdbB+3hVbJSRgv+4lGOETKUQz6OYStslQ142dNCuabNPGBzlooOmB231qMM85d2/fV6ChevvXvQP8Hkue1poOFtnEtpyxVLW1zAo6/1Xx1COxFvrc2d7UL/lmHInNlxuacJXwu0fjpXfz/YqYzBIBzD6WUfTIF9GRHpOn/Hz7saL8xz+W//FRAUid1OksQaQx4CMs8LOddcQhULW4ucetDf96JcR3g0gfRK4PC7E/r7Z6xNrXd2UIeorGj5Ef7b1pJAYB6Y5anaHqZ9J6nKEBvB4DnNLIVWSgARns/8wR2SiRS7MNACwTyrGvt9ts8p12PKFdlqYTopNHR1Vf7XjfhQlVsAJdNiKdYmYVoKlaRv85IfVunYzO0IKXsyl7JCUjCpoG20f0a04COwfneQAGGwd5oa+T8yO5hzuyDb/XcxxmK01EpqOyuxINew==',
            iv: 'r7BXXKkLb8qrSNn05n0qiA==',
        })
    },
    hideShareMenu: _.mockAsync('hideShareMenu'),
    showShareMenu: _.mockAsync('showShareMenu'),
    updateShareMenu: _.mockAsync('updateShareMenu'),

    // system
    getSystemInfo(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getSystemInfo:ok',
            ...wx.getSystemInfoSync(),
        })
    },
    getSystemInfoSync() {
        return {
            SDKVersion: '2.3.0',
            batteryLevel: 100,
            benchmarkLevel: 1,
            brand: 'devtools',
            fontSizeSetting: 16,
            language: 'zh_CN',
            model: 'iPhone 7 Plus',
            pixelRatio: 3,
            platform: 'devtools',
            screenHeight: 736,
            screenWidth: 414,
            statusBarHeight: 20,
            system: 'iOS 10.0.1',
            version: '6.6.3',
            windowHeight: 672,
            windowWidth: 414,
        }
    },

    // wxml
    createSelectorQuery() {
        return {
            in(compInst) {
                return compInst.createSelectorQuery()
            },
        }
    },
    createIntersectionObserver(compInst, options) {
        return compInst.createIntersectionObserver(options)
    },
    nextTick(func) {
        nextTickQueue.push(func)

        if (nextTickTimer) return
        nextTickTimer = setTimeout(() => {
            const funcQueue = nextTickQueue
            nextTickQueue = []
            nextTickTimer = null

            for (const func of funcQueue) {
                if (func) func()
            }
        }, 0)
    },
}
