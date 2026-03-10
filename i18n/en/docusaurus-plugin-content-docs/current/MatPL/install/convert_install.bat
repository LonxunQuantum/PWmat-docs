@echo off
chcp 65001 >nul
echo 正在将MatPL安装文档转换为PDF...

for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set year=%%a
    set month=%%b
    set day=%%c
)

pandoc README.md Installation-offline.md Installation-online.md InstallError.md RuntimeError.md -o "MatPL_安装手册_%year%-%month%-%day%.pdf" ^
  --pdf-engine=xelatex ^
  --template eisvogel ^
  -V title="MatPL 安装手册" ^
  -V author="MatPL" ^
  -V date="%year%-%month%-%day%" ^
  -V geometry="top=2.5cm, bottom=2.5cm, left=2.5cm, right=2.5cm" ^
  -V fontsize=12pt ^
  -V CJKmainfont="Microsoft YaHei" ^
  --toc ^
  --number-sections ^
  --syntax-highlighting=pygments ^
  --wrap=preserve

if exist "MatPL_安装手册_%year%-%month%-%day%.pdf" (
    echo ✅ 转换成功！
) else (
    echo ❌ 转换失败！
)

pause