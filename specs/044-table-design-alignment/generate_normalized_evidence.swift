import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct Raster {
  let width: Int
  let height: Int
  var pixels: [UInt8]
}

func load(_ path: String, crop: CGRect) -> CGImage {
  let url = URL(fileURLWithPath: path) as CFURL
  guard
    let source = CGImageSourceCreateWithURL(url, nil),
    let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
    let cropped = image.cropping(to: crop)
  else {
    fatalError("无法读取或裁剪图片：\(path)")
  }
  return cropped
}

func rasterize(_ image: CGImage) -> Raster {
  let width = image.width
  let height = image.height
  let bytesPerRow = width * 4
  var pixels = [UInt8](repeating: 0, count: height * bytesPerRow)
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  guard
    let context = CGContext(
      data: &pixels,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: bytesPerRow,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )
  else {
    fatalError("无法创建位图上下文")
  }
  context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
  return Raster(width: width, height: height, pixels: pixels)
}

func image(from raster: Raster) -> CGImage {
  let data = Data(raster.pixels) as CFData
  let provider = CGDataProvider(data: data)!
  return CGImage(
    width: raster.width,
    height: raster.height,
    bitsPerComponent: 8,
    bitsPerPixel: 32,
    bytesPerRow: raster.width * 4,
    space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
    provider: provider,
    decode: nil,
    shouldInterpolate: false,
    intent: .defaultIntent
  )!
}

func save(_ raster: Raster, to path: String) {
  let url = URL(fileURLWithPath: path) as CFURL
  let destination = CGImageDestinationCreateWithURL(
    url,
    UTType.png.identifier as CFString,
    1,
    nil
  )!
  CGImageDestinationAddImage(destination, image(from: raster), nil)
  guard CGImageDestinationFinalize(destination) else {
    fatalError("无法写入图片：\(path)")
  }
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let evidence = root.appendingPathComponent("specs/044-table-design-alignment/evidence")
let figmaPath = evidence.appendingPathComponent("table-figma.png").path
let flutterPath = evidence.appendingPathComponent("table-after-light.png").path

// Figma：去掉顶部 44px iOS 状态栏，并在最后一张 Table 的底边结束；
// Flutter：从 NavBar 起截取相同 4484px。两侧均为 375px、DPR 1，不缩放。
let width = 375
let normalizedHeight = 4484
let figma = rasterize(
  load(figmaPath, crop: CGRect(x: 0, y: 44, width: width, height: normalizedHeight))
)
let flutter = rasterize(
  load(flutterPath, crop: CGRect(x: 0, y: 0, width: width, height: normalizedHeight))
)
let beforeImage = rasterize(
  load(
    evidence.appendingPathComponent("table-before-light.png").path,
    crop: CGRect(x: 0, y: 0, width: width, height: 2863)
  )
)

var before = Raster(
  width: width,
  height: normalizedHeight,
  pixels: [UInt8](repeating: 246, count: width * normalizedHeight * 4)
)
for y in 0..<beforeImage.height {
  let sourceOffset = y * width * 4
  let destinationOffset = y * width * 4
  before.pixels[destinationOffset..<(destinationOffset + width * 4)] =
    beforeImage.pixels[sourceOffset..<(sourceOffset + width * 4)]
}

precondition(figma.width == flutter.width && figma.height == flutter.height)

var overlay = figma
var diff = figma
var comparison = Raster(
  width: width * 3,
  height: normalizedHeight,
  pixels: [UInt8](repeating: 255, count: width * 3 * normalizedHeight * 4)
)
var beforeAfterComparison = Raster(
  width: width * 3,
  height: normalizedHeight,
  pixels: [UInt8](repeating: 246, count: width * 3 * normalizedHeight * 4)
)
var exactDifferenceCount = 0
var thresholdDifferenceCount = 0
let pixelCount = width * normalizedHeight

for pixel in 0..<pixelCount {
  let offset = pixel * 4
  var exactDifference = false
  var largestChannelDifference = 0
  for channel in 0..<3 {
    let lhs = Int(figma.pixels[offset + channel])
    let rhs = Int(flutter.pixels[offset + channel])
    exactDifference = exactDifference || lhs != rhs
    largestChannelDifference = max(largestChannelDifference, abs(lhs - rhs))
    overlay.pixels[offset + channel] = UInt8((lhs + rhs) / 2)
  }
  overlay.pixels[offset + 3] = 255
  if exactDifference {
    exactDifferenceCount += 1
  }
  if largestChannelDifference > 16 {
    thresholdDifferenceCount += 1
    diff.pixels[offset] = 239
    diff.pixels[offset + 1] = 68
    diff.pixels[offset + 2] = 68
    diff.pixels[offset + 3] = 255
  } else {
    let gray = UInt8(
      (Int(figma.pixels[offset]) + Int(figma.pixels[offset + 1])
        + Int(figma.pixels[offset + 2])) / 3
    )
    let faded = UInt8((Int(gray) + 255 * 3) / 4)
    diff.pixels[offset] = faded
    diff.pixels[offset + 1] = faded
    diff.pixels[offset + 2] = faded
    diff.pixels[offset + 3] = 255
  }

  let y = pixel / width
  let x = pixel % width
  for column in 0..<3 {
    let source = column == 0 ? figma : (column == 1 ? flutter : diff)
    let sourceOffset = (y * width + x) * 4
    let destinationOffset = (y * comparison.width + x + column * width) * 4
    comparison.pixels[destinationOffset..<(destinationOffset + 4)] =
      source.pixels[sourceOffset..<(sourceOffset + 4)]
  }

  let beforeSourceOffset = (y * width + x) * 4
  let beforeDestinationOffset = (y * beforeAfterComparison.width + x + width) * 4
  beforeAfterComparison.pixels[beforeDestinationOffset..<(beforeDestinationOffset + 4)] =
    before.pixels[beforeSourceOffset..<(beforeSourceOffset + 4)]
  let figmaDestinationOffset = (y * beforeAfterComparison.width + x) * 4
  beforeAfterComparison.pixels[figmaDestinationOffset..<(figmaDestinationOffset + 4)] =
    figma.pixels[offset..<(offset + 4)]
  let flutterDestinationOffset = (y * beforeAfterComparison.width + x + width * 2) * 4
  beforeAfterComparison.pixels[flutterDestinationOffset..<(flutterDestinationOffset + 4)] =
    flutter.pixels[offset..<(offset + 4)]
}

save(figma, to: evidence.appendingPathComponent("table-figma-normalized.png").path)
save(flutter, to: evidence.appendingPathComponent("table-after-normalized.png").path)
save(overlay, to: evidence.appendingPathComponent("table-overlay-50.png").path)
save(diff, to: evidence.appendingPathComponent("table-diff-red.png").path)
save(comparison, to: evidence.appendingPathComponent("table-comparison-1x.png").path)
save(
  beforeAfterComparison,
  to: evidence.appendingPathComponent("table-design-before-after-1x.png").path
)

let exactRatio = Double(exactDifferenceCount) / Double(pixelCount) * 100
let thresholdRatio = Double(thresholdDifferenceCount) / Double(pixelCount) * 100
print("画布：\(width)x\(normalizedHeight)，像素数：\(pixelCount)")
print(String(format: "精确差异：%d (%.4f%%)", exactDifferenceCount, exactRatio))
print(String(format: "RGB 单通道差异 > 16：%d (%.4f%%)", thresholdDifferenceCount, thresholdRatio))
