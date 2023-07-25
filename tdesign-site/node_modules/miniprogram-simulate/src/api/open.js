const _ = require('./utils')

module.exports = {
    getAccountInfoSync: _.mockSync({
        miniProgram: {appId: 'wx4f4bc4dec97d474b'},
    }),
    chooseAddress(options = {}) {
        _.runInAsync(options, {
            errMsg: 'chooseAddress:ok',
            cityName: '广州市',
            countyName: '海珠区',
            detailInfo: '新港中路397号',
            nationalCode: '510000',
            postalCode: '510000',
            provinceName: '广东省',
            telNumber: '020-81167888',
            userName: '张三',
        })
    },
    authorize: _.mockAsync('authorize'),
    addCard(options = {}) {
        const cardList = (options.cardList || []).map(item => ({
            code: 'this is a mock code',
            isSuccess: true,
            ...item,
        }))

        _.runInAsync(options, {
            errMsg: 'addCard:ok',
            cardList
        })
    },
    openCard: _.mockAsync('openCard'),
    reportAnalytics: _.mockSync(null),
    chooseInvoice(options = {}) {
        _.runInAsync(options, {
            errMsg: 'chooseInvoice:ok',
            invoiceInfo: {
                cardId: 'pjZ8Yt5crPbAouhFqFf6JFgZv4Lc',
                encryptCode: 'fbdt/fWy1VitQwhbKtSjNeR3BJyfpeJXfZjjGsdCXiM=',
                publisherAppId: 'wx00000000000000',
            },
        })
    },
    chooseInvoiceTitle(options = {}) {
        _.runInAsync(options, {
            errMsg: 'chooseInvoiceTitle:ok',
            bankAccount: '1209 0928 2210 301',
            bankName: '招商银行股份有限公司广州市体育东路支行',
            companyAddress: '广州市海珠区新港中路397号自编72号(商业街F5-1)',
            taxNumber: '91440101327598294H',
            telephone: '020-81167888',
            title: '广州腾讯科技有限公司',
            type: 0,
        })
    },
    checkSession: _.mockAsync('checkSession'),
    login(options = {}) {
        _.runInAsync(options, {
            errMsg: 'login:ok',
            code: '033UAswz1j8Fjb0lT4yz1Wmrwz1UAsw9',
        })
    },
    navigateBackMiniProgram: _.mockAsync('navigateBackMiniProgram'),
    navigateToMiniProgram: _.mockAsync('navigateToMiniProgram'),
    requestPayment: _.mockAsync('requestPayment'),
    getSetting(options = {}) {
        _.runInAsync(options, {
            errMsg: 'getSetting:ok',
            authSetting: {
                'scope.address': true,
                'scope.invoice': true,
                'scope.invoiceTitle': true,
                'scope.subscribemsg': true,
            },
        })
    },
    openSetting(options = {}) {
        _.runInAsync(options, {
            errMsg: 'openSetting:ok',
            authSetting: {
                'scope.address': true,
                'scope.invoice': true,
                'scope.invoiceTitle': true,
                'scope.subscribemsg': true,
            },
        })
    },
    checkIsSoterEnrolledInDevice(options = {}) {
        _.runInAsync(options, {
            errMsg: 'checkIsSoterEnrolledInDevice:ok',
            isEnrolled: true,
        })
    },
    checkIsSupportSoterAuthentication(options = {}) {
        _.runInAsync(options, {
            errMsg: 'checkIsSupportSoterAuthentication:ok',
            supportMode: ['fingerPrint'],
        })
    },
    startSoterAuthentication: _.mockAsync('startSoterAuthentication'),
    getUserInfo(options) {
        _.runInAsync(options, {
            errMsg: 'getUserInfo:ok',
            userInfo: {
                nickName: 'Band',
                gender: 1,
                language: 'zh_CN',
                city: 'Guangzhou',
                province: 'Guangdong',
                country: 'CN',
                avatarUrl: 'http://wx.qlogo.cn/mmopen/vi_32/aSKcBBPpibyKNicHNTMM0qJVh8Kjgiak2AHWr8MHM4WgMEm7GFhsf8OYrySdbvAMvTsw3mo8ibKicsnfN5pRjl1p8HQ/0',
            },
            rawData: '{"nickName":"Band","gender":1,"language":"zh_CN","city":"Guangzhou","province":"Guangdong","country":"CN","avatarUrl":"http://wx.qlogo.cn/mmopen/vi_32/1vZvI39NWFQ9XM4LtQpFrQJ1xlgZxx3w7bQxKARol6503Iuswjjn6nIGBiaycAjAtpujxyzYsrztuuICqIM5ibXQ/0"}HyVFkGl5F5OQWJZZaNzBBg==',
            signature: '75e81ceda165f4ffa64f4068af58c64b8f54b88c',
            encryptedData: 'CiyLU1Aw2KjvrjMdj8YKliAjtP4gsMZMQmRzooG2xrDcvSnxIMXFufNstNGTyaGS9uT5geRa0W4oTOb1WT7fJlAC+oNPdbB+3hVbJSRgv+4lGOETKUQz6OYStslQ142dNCuabNPGBzlooOmB231qMM85d2/fV6ChevvXvQP8Hkue1poOFtnEtpyxVLW1zAo6/1Xx1COxFvrc2d7UL/lmHInNlxuacJXwu0fjpXfz/YqYzBIBzD6WUfTIF9GRHpOn/Hz7saL8xz+W//FRAUid1OksQaQx4CMs8LOddcQhULW4ucetDf96JcR3g0gfRK4PC7E/r7Z6xNrXd2UIeorGj5Ef7b1pJAYB6Y5anaHqZ9J6nKEBvB4DnNLIVWSgARns/8wR2SiRS7MNACwTyrGvt9ts8p12PKFdlqYTopNHR1Vf7XjfhQlVsAJdNiKdYmYVoKlaRv85IfVunYzO0IKXsyl7JCUjCpoG20f0a04COwfneQAGGwd5oa+T8yO5hzuyDb/XcxxmK01EpqOyuxINew==',
            iv: 'r7BXXKkLb8qrSNn05n0qiA==',
        })
    },
    getWeRunData(options) {
        _.runInAsync(options, {
            errMsg: 'getUserInfo:ok',
            encryptedData: 'XoLUxF76jN/OsfTGUqF/ZqRn+2PtO66lAMg/g0D3bg1L2/Nds8gTQrH7fGmbTgGtUC2R9lbJh7fLEaO9boeCqru1Em2BD/IbfN6lI/nu55himuBvypESz+H9uV7izLP/',
            iv: 'r7BXXKkLb8qrSNn05n0qiA==',
        })
    },
}
