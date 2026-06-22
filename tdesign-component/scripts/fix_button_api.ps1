$root = "e:/tdesign-flutter-v1/tdesign-component/example/lib"

$files = @(
    "$root/home.dart",
    "$root/base/example_widget.dart",
    "$root/page/t_dialog_page.dart",
    "$root/page/t_drawer_page.dart",
    "$root/page/t_empty_page.dart",
    "$root/page/t_form_page.dart",
    "$root/page/t_image_viewer_page.dart",
    "$root/page/t_indexes_page.dart",
    "$root/page/t_input_page.dart",
    "$root/page/t_loading_page.dart",
    "$root/page/t_message_page.dart",
    "$root/page/t_notice_bar_page.dart",
    "$root/page/t_popover_page.dart",
    "$root/page/t_popup_page.dart",
    "$root/page/t_result_page.dart",
    "$root/page/t_stepper_page.dart",
    "$root/page/t_theme_page.dart",
    "$root/page/t_time_counter_page.dart",
    "$root/page/t_toast_page.dart",
    "$root/page/t_calendar_page.dart",
    "$root/page/t_backtop_page.dart",
    "$root/page/t_badge_page.dart",
    "$root/page/t_action_sheet_page.dart",
    "$root/sidebar/t_sidebar_page.dart"
)

foreach ($file in $files) {
    if (-not (Test-Path $file)) { continue }
    
    $content = Get-Content $file -Raw -Encoding UTF8
    $changed = $false
    
    # Replace onTap: → onPressed:
    if ($content -match 'onTap:') {
        $content = $content -replace 'onTap:', 'onPressed:'
        $changed = $true
    }
    
    # Replace type: TButtonType. → variant: TButtonVariant.
    if ($content -match 'type:\s*TButtonType\.') {
        $content = $content -replace 'type:\s*TButtonType\.', 'variant: TButtonVariant.'
        $changed = $true
    }
    
    # Replace theme: TButtonTheme. → colorScheme: TButtonColorScheme.
    if ($content -match 'theme:\s*TButtonTheme\.') {
        $content = $content -replace 'theme:\s*TButtonTheme\.', 'colorScheme: TButtonColorScheme.'
        $changed = $true
    }
    
    # Replace text: ' → child: Text('
    if ($content -match "text:\s*'") {
        $content = $content -replace "text:\s*'", "child: Text('"
        $changed = $true
    }
    
    # Replace text: " → child: Text("
    if ($content -match 'text:\s*"') {
        $content = $content -replace 'text:\s*"', 'child: Text("'
        $changed = $true
    }
    
    # Replace standalone TButtonType references
    if ($content -match '\bTButtonType\b') {
        $content = $content -replace '\bTButtonType\b', 'TButtonVariant'
        $changed = $true
    }
    
    # Replace standalone TButtonTheme references (not TButtonThemeData)
    if ($content -match '\bTButtonTheme\b(?!Data)') {
        $content = $content -replace '\bTButtonTheme\b(?!Data)', 'TButtonColorScheme'
        $changed = $true
    }
    
    # Replace TButtonShape references
    if ($content -match '\bTButtonShape\b') {
        $content = $content -replace '\bTButtonShape\b', 'TButtonShape'
        $changed = $true
    }
    
    # Replace isBlock: true, → remove and wrap? Handle manually
    # Replace disabled: → onPressed: null
    if ($content -match 'disabled:\s*true') {
        $content = $content -replace 'disabled:\s*true,\s*\n', "onPressed: null,`n"
        $content = $content -replace 'disabled:\s*!(\w+),\s*\n', ''
        $changed = $true
    }

    if ($changed) {
        [System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
        Write-Host "Fixed: $file"
    }
}

Write-Host "Done!"
