@echo off
chcp 65001 >nul
echo 🛡️ Автоматическое обновление хэша...

:: 1. Считаем SHA-256 от файла SecretarySetup.exe
for /f "skip=1 tokens=*" %%a in ('certutil -hashfile "SecretarySetup.exe" SHA256') do (
    if not defined NEW_HASH set "NEW_HASH=%%a"
)
:: Убираем пробелы из хэша
set "NEW_HASH=%NEW_HASH: =%"

if not defined NEW_HASH (
    echo ❌ Ошибка: Файл SecretarySetup.exe не найден в этой папке!
    pause
    exit /b
)

echo ✅ Новый хэш: %NEW_HASH%

:: 2. Обновляем файл index.html через PowerShell (безопасно)
powershell -NoProfile -Command ^
    "$file = 'index.html';" ^
    "if (Test-Path $file) {" ^
    "  $content = Get-Content -Raw $file;" ^
    "  $pattern = '(?<=<code class=\"hash-code\" id=\"hash-display\">).*?(?=</code>)';" ^
    "  $newContent = $content -replace $pattern, '%NEW_HASH%';" ^
    "  Set-Content -Path $file -Value $newContent -Encoding UTF8;" ^
    "  Write-Host '✅ Хэш в index.html обновлен!' -ForegroundColor Green" ^
    "} else {" ^
    "  Write-Host '❌ Файл index.html не найден!' -ForegroundColor Red" ^
    "}"

echo.
echo Теперь можете загружать index.html на GitHub.
pause
