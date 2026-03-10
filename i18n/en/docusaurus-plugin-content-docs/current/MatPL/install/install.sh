#!/bin/bash

echo "正在将MatPL安装文档转换为PDF..."

current_date=$(date +"%Y-%m-%d")
output_file="MatPL_安装手册_${current_date}.pdf"

echo "正在转换文件..."
echo "文件列表:"
echo "1. README.md"
echo "2. Installation-offline.md"
echo "3. Installation-online.md"
echo "4. InstallError.md"
echo "5. RuntimeError.md"
echo ""

#执行转换
pandoc README.md Installation-offline.md Installation-online.md InstallError.md RuntimeError.md -o "${output_file}" \
  --pdf-engine=xelatex \
  --template eisvogel \
  -V title="MatPL 安装手册" \
  -V author="MatPL" \
  -V date="${current_date}" \
  -V geometry="top=2.5cm, bottom=2.5cm, left=2.5cm, right=2.5cm" \
  -V fontsize=12pt \
  -V CJKmainfont="Microsoft YaHei" \
  --toc \
  --number-sections \
  --syntax-highlighting=pygments \
  --wrap=preserve \
  --resource-path=.

if [ -f "${output_file}" ]; then
    echo "✅ 转换成功: ${output_file}"
    echo "文件大小: $(du -h "${output_file}" | cut -f1)"
else
    echo "❌ 转换失败"
fi