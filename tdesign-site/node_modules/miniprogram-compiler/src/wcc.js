const { spawnSync } = require('child_process')
const fs = require('fs')
const path = require('path')

/**
 * 获取 wxml 编译器路径
 */
let wxmlParserPath = ''
function getWXMLParsePath() {
  if (wxmlParserPath) return wxmlParserPath

  const fileName = process.platform === 'darwin' ? '../bin/mac/wcc' : process.platform === 'linux' ? '../bin/linux/wcc' : '../bin/windows/wcc.exe'
  wxmlParserPath = path.join(__dirname, fileName)

  // 尝试修改权限
  try {
    fs.chmodSync(wxmlParserPath, 0o777)
  } catch (err) {
    // ignore
  }

  return wxmlParserPath
}

/**
 * 获取自定义组件编译参数
 */
function getComponentArgs(files) {
  let args = []
  let count = 0

  files.forEach(file => {
    const fileJson = file.fileJson

    if (fileJson.usingComponents) {
      args.push(file.pagePath)
      args.push(Object.keys(fileJson.usingComponents).length)
      args = args.concat(Object.keys(fileJson.usingComponents))
      count++
    }
  })
  args.unshift(count)

  return args
}

/**
 * 获取完整文件列表
 */
function getAllFiles(rootPath, files) {
  const ret = []
  const hasCheckMap = {}

  for (let i = 0, len = files.length; i < len; i++) {
    const file = files[i]

    let fileJson = {}
    const realPath = path.join(rootPath, file)
    if (hasCheckMap[realPath]) continue
    hasCheckMap[realPath] = true
    try {
      fileJson = require(`${realPath}.json`)
    } catch(err) {
      // ignore
    }

    // 自定义组件
    if (fileJson.usingComponents) {
      Object.keys(fileJson.usingComponents).forEach(subFileKey => {
        const subFile = fileJson.usingComponents[subFileKey]

        len++

        let relativePath = path.relative(rootPath, path.join(path.dirname(realPath), subFile))
        relativePath = relativePath.replace(/\\/g, '/')
        files.push(relativePath)
      })
    }

    ret.push({
      pagePath: `${file}.wxml`,
      jsonPath: `${file}.json`,
      fileJson,
    })
  }

  return ret
}

/**
 * 编译 wxml 到 js
 */
function wxmlToJS(rootPath, files, wxsFiles, { cut, maxBuffer } = {}) {
  const type = cut ? '-xc' : '-cc'
  files = getAllFiles(rootPath, files)

  // @TODO，如果遇到参数过长被操作系统干掉的情况，可以使用 --config-path FILE 配置，参数空格换成空行
  const componentArgs = getComponentArgs(files)
  const args = ['-d', type, componentArgs.join(' ')]
    .concat(files.map(file => file.pagePath))
    .concat(wxsFiles)
    .concat(['-gn', '$gwx'])

  const wxmlParserPath = getWXMLParsePath()
  const wcc = spawnSync(wxmlParserPath, args, {
    cwd: rootPath,
    maxBuffer: maxBuffer || 1024 * 1024,
  })

  if (wcc.status === 0) {
    return wcc.stdout.toString()
  } else if (wcc.error) {
    throw wcc.error
  } else {
    throw new Error(`编译 .wxml 文件错误：${wcc.stderr.toString()}`) 
  }
}

module.exports = wxmlToJS
