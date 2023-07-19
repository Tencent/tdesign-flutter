# 小程序自动化

小程序自动化 JS 版 SDK。

## 安装

```bash
npm i miniprogram-automator
```

## 使用

```javascript
const automator = require('miniprogram-automator')

;(async () => {
  const miniProgram = await automator.launch({
    cliPath: 'path/to/cli',
    projectPath: 'path/to/project',
  })

  const page = await miniProgram.reLaunch('/page/component/index')
  await page.waitFor(500)
  const element = await page.$('.kind-list-item-hd')
  console.log(await element.attribute('class'))
  await element.tap()
  await page.waitFor(200)
  console.log(await element.attribute('class'))

  await miniProgram.close()
})()
```