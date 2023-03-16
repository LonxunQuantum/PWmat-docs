# Script

以下是一些实用脚本

1. 适用于Mcolud，便捷准备赝势文件

```bash
#!/bin/bash

repo="/share/psp/allpsp"
for element in $*
do
# element=$1
files=($(find $repo -maxdepth 1 -type f -iname "$element*"))

if [ ${#files[@]} -eq 0 ]; then
  echo "** Warning: No suitable pseu for element '$element' found!! Skipped this element."
else
  echo "Multiple files found for element '$element':"
  for i in "${!files[@]}"; do
    echo "$((i+1)). ${files[$i]}"
  done
  read -p "Please select a file (1-${#files[@]}) or press 'q' to quit: " selection
  if [ "$selection" = "q" ]; then
    echo "Quit."
  elif [ "$selection" -ge 1 ] && [ "$selection" -le "${#files[@]}" ]; then
    cp "${files[$((selection-1))]}" ./
    echo "File '${files[$((selection-1))]}'' has been copied to current directory."
  else
    echo "Invalid selection."
  fi
fi
done

```

* `chmod u+x xxx.sh`
* 使用方式： `xxx.sh Pt Se ...`