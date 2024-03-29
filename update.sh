#!/bin/bash
rm -f ./hosts.txt
# pull云端到本地
git pull -f

# 下载去广告hosts合并并去重

t=./hosts.txt
f=./hosts

curl -s https://gitee.com/qiusunshine233/hikerView/raw/master/ad_v1.txt > $t

sed -i 's/\&\&/\n/g' $t

curl -s https://gitee.com/qiusunshine233/hikerView/raw/master/ad_v2.txt >> $t

sed -i '/\(\/\|@\|\*\|^\.\|\:\)/d;s/^/127.0.0.1 /g' $t && echo "海阔影视hosts导入成功"

while read i;do curl -s "$i">>$t&&echo "下载成功"||echo "下载失败";done<<EOF
https://adaway.org/hosts.txt
https://raw.githubusercontent.com/ilpl/ad-hosts/master/hosts
https://raw.githubusercontent.com/jdlingyu/ad-wars/master/sha_ad_hosts
https://raw.githubusercontent.com/521xueweihan/GitHub520/master/hosts
EOF

# 转换换行符
dos2unix *

# 保留必要host
sed -i '/^\(127\|0\|::\)/!d;s/0.0.0.0/127.0.0.1/g;s/#.*//g;s/\s\{2,\}//g;/tencent\|c\.pc\|xmcdn\|::1l\|::1i\|googletagservices\|zhwnlapi\|samizdat/d' $t

# 加入Github520
curl -s https://raw.githubusercontent.com/521xueweihan/GitHub520/master/hosts >> $t
sed -i '/GitHub520/d' $t

# 更新hosts
(echo -e "# `date '+%Y-%m-%d %T'`\n# By SamYanSan\n\n" && sort -u $t) >$f&&rm $t&&echo "更新hosts成功"||echo "更新hosts失败..."

# 推送到GitHub
git add . && git commit -m " `date '+%Y-%m-%d %T'` " && git push && echo -e " `date '+%Y-%m-%d %T' ` 更新hosts成功"||echo "更新hosts失败..."
