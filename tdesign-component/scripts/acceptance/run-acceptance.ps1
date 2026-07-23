# TDesign Flutter V1.0 组件自动化验收 —— PowerShell 编排脚本
#
# 一键执行全部自动化验收检查，生成 Markdown 验收报告。
#
# 用法：
#   .\run-acceptance.ps1                    # 全量执行（含测试 + analyze）
#   .\run-acceptance.ps1 -SkipTests         # 跳过 flutter test / dart analyze
#   .\run-acceptance.ps1 -SkipBuild         # 跳过 all_build.sh
#   .\run-acceptance.ps1 -SkipTests -SkipBuild  # 仅静态扫描
#   .\run-acceptance.ps1 -RunThemeTest      # 额外执行 Theme 档2 测试
#
# 退出码：0=全部通过，1=有未通过项

param(
    [switch]$SkipTests,
    [switch]$SkipBuild,
    [switch]$RunThemeTest
)

$ErrorActionPreference = "Continue"
$projectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$acceptanceDir = Join-Path $projectRoot "scripts\acceptance"

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  TDesign Flutter V1.0 组件自动化验收" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  项目根目录: $projectRoot" -ForegroundColor Gray
Write-Host "  跳过测试:   $SkipTests" -ForegroundColor Gray
Write-Host "  跳过构建:   $SkipBuild" -ForegroundColor Gray
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# 步骤 0：前置检查
# ============================================================
Write-Host "[步骤 0] 前置检查..." -ForegroundColor Yellow

$pubspec = Join-Path $projectRoot "pubspec.yaml"
if (-not (Test-Path $pubspec)) {
    Write-Host "  错误: 未找到 pubspec.yaml，请在 tdesign-component 目录下运行" -ForegroundColor Red
    exit 1
}

# 检查 Flutter 是否可用
$flutterVersion = & flutter --version 2>&1 | Select-Object -First 1
Write-Host "  Flutter: $flutterVersion" -ForegroundColor Gray

# ============================================================
# 步骤 1：flutter pub get
# ============================================================
Write-Host ""
Write-Host "[步骤 1] flutter pub get..." -ForegroundColor Yellow
Push-Location $projectRoot
& flutter pub get 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) {
    Write-Host "  flutter pub get 失败" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "  完成" -ForegroundColor Green

# ============================================================
# 步骤 2：dart analyze（项E）
# ============================================================
if (-not $SkipTests) {
    Write-Host ""
    Write-Host "[步骤 2] dart analyze..." -ForegroundColor Yellow
    Push-Location $projectRoot
    $analyzeOutput = & dart analyze 2>&1
    $analyzeExitCode = $LASTEXITCODE
    Pop-Location

    # 统计 error 数量
    $errorCount = ($analyzeOutput | Select-String "error -" -CaseSensitive).Count
    $warningCount = ($analyzeOutput | Select-String "warning -" -CaseSensitive).Count
    $infoCount = ($analyzeOutput | Select-String "info -" -CaseSensitive).Count

    Write-Host "  ERROR: $errorCount | WARNING: $warningCount | INFO: $infoCount" -ForegroundColor Gray

    if ($errorCount -gt 0) {
        Write-Host "  发现 $errorCount 个 ERROR" -ForegroundColor Red
        $analyzeOutput | Select-String "error -" -CaseSensitive | Select-Object -First 10 | ForEach-Object {
            Write-Host "    $_" -ForegroundColor Gray
        }
    } else {
        Write-Host "  零 ERROR" -ForegroundColor Green
    }
}

# ============================================================
# 步骤 3：flutter test --coverage（核心3 + 项E）
# ============================================================
if (-not $SkipTests) {
    Write-Host ""
    Write-Host "[步骤 3] flutter test --coverage..." -ForegroundColor Yellow
    Push-Location $projectRoot
    & flutter test --coverage 2>&1 | Out-Host
    $testExitCode = $LASTEXITCODE
    Pop-Location

    if ($testExitCode -ne 0) {
        Write-Host "  flutter test 存在失败用例" -ForegroundColor Red
    } else {
        Write-Host "  全部测试通过" -ForegroundColor Green
    }

    # 覆盖率汇总
    $lcovFile = Join-Path $projectRoot "coverage\lcov.info"
    if (Test-Path $lcovFile) {
        $lcovContent = Get-Content $lcovFile -Raw
        $totalLines = ([regex]::Matches($lcovContent, "DA:\d+,\d+")).Count
        $coveredLines = ([regex]::Matches($lcovContent, "DA:\d+,[1-9]")).Count
        if ($totalLines -gt 0) {
            $rate = [math]::Round($coveredLines / $totalLines * 100, 1)
            Write-Host "  总覆盖率: $rate% ($coveredLines/$totalLines)" -ForegroundColor Gray
        }
    }
}

# ============================================================
# 步骤 4：Theme 档2 Widget 测试（可选）
# ============================================================
if ($RunThemeTest) {
    Write-Host ""
    Write-Host "[步骤 4] Theme 档2 Widget 测试..." -ForegroundColor Yellow
    Push-Location $projectRoot
    & flutter test test/acceptance/theme_acceptance_test.dart 2>&1 | Out-Host
    Pop-Location
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Theme 档2 测试通过" -ForegroundColor Green
    } else {
        Write-Host "  Theme 档2 测试失败" -ForegroundColor Red
    }
}

# ============================================================
# 步骤 5：all_build.sh 生成 API 文档（项D）
# ============================================================
if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "[步骤 5] 生成 API 文档 (all_build.sh)..." -ForegroundColor Yellow
    Push-Location $projectRoot
    # Windows 下用 bash 执行 .sh
    & bash demo_tool/all_build.sh 2>&1 | Out-Host
    $buildExitCode = $LASTEXITCODE
    Pop-Location

    if ($buildExitCode -ne 0) {
        Write-Host "  all_build.sh 执行失败（可能缺少 bash）" -ForegroundColor Yellow
        Write-Host "  跳过 API 文档一致性检查" -ForegroundColor Yellow
    } else {
        Write-Host "  API 文档生成完成" -ForegroundColor Green
    }
}

# ============================================================
# 步骤 6：运行 Dart 验收引擎（静态核查 + 文档比对 + 报告生成）
# ============================================================
Write-Host ""
Write-Host "[步骤 6] 运行验收引擎..." -ForegroundColor Yellow
Push-Location $projectRoot

$dartArgs = @("run", "scripts/acceptance/acceptance_check.dart")
if ($SkipTests) {
    $dartArgs += "--skip-tests"
}
if ($SkipBuild) {
    $dartArgs += "--skip-build"
}

& dart @dartArgs 2>&1 | Out-Host
$checkExitCode = $LASTEXITCODE
Pop-Location

# ============================================================
# 汇总
# ============================================================
Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  验收完成" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan

$reportFile = Join-Path $acceptanceDir "acceptance-report.md"
if (Test-Path $reportFile) {
    Write-Host "  验收报告: $reportFile" -ForegroundColor Green
}

if ($checkExitCode -eq 0) {
    Write-Host "  结果: 全部通过" -ForegroundColor Green
    exit 0
} else {
    Write-Host "  结果: 有未通过项，请查看报告" -ForegroundColor Red
    exit 1
}
