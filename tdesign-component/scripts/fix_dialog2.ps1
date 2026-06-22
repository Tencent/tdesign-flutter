$file = "e:/tdesign-flutter-v1/tdesign-component/example/lib/page/t_dialog_page.dart"
$content = Get-Content $file -Raw -Encoding UTF8

# Revert TButton theme: → colorScheme: (was wrongly changed)
$content = $content -replace 'variant: TButtonVariant\.(\w+),\s*\n\s*theme: TButtonColorScheme\.', 'variant: TButtonVariant.${1},`r`n      colorScheme: TButtonColorScheme.'

# Also handle TButton without variant
$content = $content -replace '(\s+)theme: TButtonColorScheme\.(primary)', '${1}colorScheme: TButtonColorScheme.${2}'

# Fix ButtonStyle with old TButtonStyle parameters
# Remove the custom style block (TButtonStyle params don't match ButtonStyle)
$content = $content -replace 'buttonStyleCustom: ButtonStyle\(\s*\n\s*backgroundColor: [^,]+,\s*\n\s*textColor: [^,]+,\s*\n\s*frameWidth: [^,]+,\s*\n\s*frameColor: [^\)]+\),', ''

[System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
Write-Host "Fixed!"
