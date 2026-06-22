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

    # Fix: child: Text('XXX', → child: Text('XXX'),
    # This adds the missing closing paren for Text widget
    $content = $content -replace "(child: Text\('[^']*')(,)", '${1})${2}'

    [System.IO.File]::WriteAllText($file, $content, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Fixed: $file"
}

Write-Host "Done!"
