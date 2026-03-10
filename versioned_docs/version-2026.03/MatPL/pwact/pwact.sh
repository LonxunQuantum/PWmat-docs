#!/bin/bash

echo "正在合并并转换为PDF..."

current_date=$(date +"%Y-%m-%d")
output_file="pwact_完整手册_${current_date}.pdf"

echo "正在转换文件..."
echo "文件列表:"
echo "1. README.md"
echo "2. init_param_zh.md"
echo "3. run_param_zh.md"
echo "4. resource_zh.md"
echo "5. example_si_init_zh.md"
echo "6. example_si_direct_bigmodel.md"
echo "7. example_auag_init_zh.md"
echo ""

# 执行pandoc转换
pandoc README.md init_param_zh.md run_param_zh.md resource_zh.md example_si_init_zh.md example_si_direct_bigmodel.md example_auag_init_zh.md -o "$output_file" \
  --pdf-engine=xelatex \
  --template eisvogel \
  -V title="pwact 主动学习完整手册" \
  -V author="MatPL" \
  -V date="$current_date" \
  -V geometry="top=2.5cm, bottom=2.5cm, left=2.5cm, right=2.5cm" \
  -V fontsize=12pt \
  -V CJKmainfont="Microsoft YaHei" \
  --toc \
  --number-sections \
  --syntax-highlighting=pygments \
  --wrap=preserve


if [ -f "$output_file" ]; then
    echo "✅ 转换成功: $output_file"
    echo "文件大小: $(du -h "$output_file" | cut -f1)"
else
    echo "❌ 转换失败"
fi