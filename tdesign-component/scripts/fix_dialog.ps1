$file = "e:/tdesign-flutter-v1/tdesign-component/example/lib/page/t_dialog_page.dart"
$content = Get-Content $file -Raw -Encoding UTF8

# Fix TTextSpan
$content = $content -replace 'TTextSpan\(child: Text\(''([^'']+)''\), textColor:', 'TTextSpan(text: ''${1}'', textColor:'

# Fix TButtonStyle -> ButtonStyle (all remaining occurrences in this file)
$content = $content -replace 'TButtonStyle\(', 'ButtonStyle('

# Fix TDialogButtonOptions colorScheme -> theme
# The script already changed type references.
# Now we just need to change parameter names back.
# Simple approach: replace colorScheme: TButtonColorScheme.xxx in TDialogButtonOptions context
$content = $content -replace 'colorScheme: TButtonColorScheme\.', 'theme: TButtonColorScheme.'

[System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
Write-Host "Fixed t_dialog_page.dart"
