#!/bin/bash
## wuxing
date=$(date +"%Y-%m-%d")
output="MatPL-2026.3-userdoc.pdf"

echo "创建合并文档..."

# 清理之前的临时文件
rm -f temp.md latex_header.tex

# 创建LaTeX头文件，使用简单方法设置页码
cat > latex_header.tex << 'EOF'
\usepackage{graphicx}
\usepackage{geometry}
\usepackage{atbegshi}
\usepackage{etoolbox}

\graphicspath{{./pictures/}{install/pictures/}{pwact/pictures/}{models/pictures/}{models/nep/pictures/}{models/dp/pictures/}{models/nn/pictures/}{examples/pictures/}{pwdata/pictures/}}

\AtBeginDocument{\pagenumbering{roman}}
\apptocmd{\tableofcontents}{%
    \clearpage
    \pagenumbering{arabic}
    \setcounter{page}{1}%
}{}{}
EOF

# 创建临时Markdown文件
echo "% MatPL 用户手册" > temp.md
echo "% MatPL Team" >> temp.md
echo "% $date" >> temp.md
echo "" >> temp.md

# # 添加frontmatter命令
# echo "\frontmatter" >> temp.md
# echo "" >> temp.md

# # 添加目录（会自动生成）
# # 这里不需要手动添加，pandoc的--toc选项会自动生成

# # 在目录后切换到正文页码
# echo "\mainmatter" >> temp.md
# echo "" >> temp.md


# 首页
echo "处理: README.md"
# 移除matpl-cmd.md中的front matter（以---包围的部分）
awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' README.md >> temp.md
echo "\newpage" >> temp.md
echo "" >> temp.md

# 安装手册
for f in README.md Installation-offline.md Installation-online.md InstallError.md RuntimeError.md; do
    if [ -f "install/$f" ]; then
        echo "处理: install/$f"
        # 复制文件内容，修复图片路径
        awk '{
            gsub(/\r$/, "")
            if (NR == 1) sub(/^\xef\xbb\xbf/, "")
            if (/^---$/) {
                if (++count == 2) { in_front = 0; next }
                else { in_front = 1; next }
            }
            if (!in_front) print
        }' "install/$f" | sed 's|\./pictures/|install/pictures/|g' >> temp.md
        echo "" >> temp.md
    fi
done

echo "\newpage" >> temp.md
echo "" >> temp.md

# 命令
echo "处理: matpl-cmd.md"
# 移除matpl-cmd.md中的front matter（以---包围的部分）
awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' matpl-cmd.md >> temp.md
echo "\newpage" >> temp.md
echo "" >> temp.md

# 参数
echo "处理: parameterdetail.md"
# 移除parameterdetail.md中的front matter（以---包围的部分）
awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' parameterdetail.md >> temp.md
echo "" >> temp.md

# 第二部分：模型手册 
# models目录下的README.md
echo "处理: models/README.md"
awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "models/README.md" | \
    sed 's|\./pictures/|models/pictures/|g' >> temp.md
echo "" >> temp.md

# nep模型
echo "处理 nep 模型..."
nep_files=("README.md" "nep-tutorial.md")
for f in "${nep_files[@]}"; do
    echo "处理: models/nep/$f"
    awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "models/nep/$f" | \
        sed 's|\./pictures/|models/nep/pictures/|g' >> temp.md
    echo "" >> temp.md
done

# dp模型
echo "处理 dp 模型..."
dp_files=("README.md" "dp-tutorial.md")
for f in "${dp_files[@]}"; do
    echo "处理: models/dp/$f"
    awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "models/dp/$f" | \
        sed 's|\./pictures/|models/dp/pictures/|g' >> temp.md
    echo "" >> temp.md
done

# nn模型
echo "处理 nn 模型..."
nn_files=("README.md" "nn-tutorial.md")
for f in "${nn_files[@]}"; do
    echo "处理: models/nn/$f"
    awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "models/nn/$f" | \
        sed 's|\./pictures/|models/nn/pictures/|g' >> temp.md
    echo "" >> temp.md
done

# linear模型
echo "处理 linear 模型..."
linear_files=("README.md" "linear-tutorial.md")
for f in "${linear_files[@]}"; do
    echo "处理: models/linear/$f"
    awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "models/linear/$f" >> temp.md
    echo "" >> temp.md
done

echo "\newpage" >> temp.md

# pwact手册部分
pwact_files=("README.md" "init_param_zh.md" "run_param_zh.md" "resource_zh.md" "example_si_init_zh.md" "example_si_direct_bigmodel.md" "example_auag_init_zh.md")
for f in "${pwact_files[@]}"; do
    if [ -f "pwact/$f" ]; then
        echo "处理: pwact/$f"
        # 复制文件内容，修复图片路径
        awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "pwact/$f" | \
            sed 's|\./pictures/|pwact/pictures/|g' >> temp.md
            echo "" >> temp.md
    fi
done
echo "\newpage" >> temp.md

# pwdata手册部分
pwdata_files=("README.md")
for f in "${pwdata_files[@]}"; do
    if [ -f "pwdata/$f" ]; then
        echo "处理: pwdata/$f"
        # 复制文件内容，修复图片路径
        awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "pwdata/$f" | \
            sed 's|\./pictures/|pwdata/pictures/|g' >> temp.md
            echo "" >> temp.md
    fi
done
echo "\newpage" >> temp.md

# 案例手册部分
examples_files=("README.md" "features.md" "Si.md" "Fe.md" "Li.md" "Mg_Cu.md" "Si_temp.md")
for f in "${examples_files[@]}"; do
    if [ -f "examples/$f" ]; then
        echo "处理: examples/$f"
        # 复制文件内容，修复图片路径
        awk '/^---$/ {if (++count == 2) next} count < 2 {next} 1' "examples/$f" | \
            sed 's|\./pictures/|examples/pictures/|g' >> temp.md
            echo "" >> temp.md
    fi
done
echo "\newpage" >> temp.md

echo "转换为PDF..."

pandoc temp.md -o "$output" \
  --pdf-engine=xelatex \
  --template eisvogel \
  -V title="MatPL用户手册" \
  -V author="wuxingxing@pwmat.com" \
  -V date="$date" \
  -V geometry="top=2.5cm,bottom=2.5cm,left=2.5cm,right=2.5cm" \
  -V fontsize=12pt \
  -V CJKmainfont="Microsoft YaHei" \
  --include-in-header=latex_header.tex \
  --toc \
  --number-sections \
  --syntax-highlighting=pygments \
  --wrap=preserve \
  --resource-path=.

# 清理临时文件
# rm -f temp.md latex_header.tex

if [ -f "$output" ]; then
    echo "✅ 成功: $output"
    echo "文件大小: $(du -h "$output" | cut -f1)"
else
    echo "❌ 失败"
fi

