# 基于文本数据挖掘的官媒主题效力分析
分析以微信公众号为代表的官媒中，文本内容与传播效力之间的关系，以此指导官媒优化内容结构，更好地发挥自身作用。

## Version
1. R 3.6.1
1. RStudio 1.2.1335
1. Python 3.7

## File List

1. `fitNums.R`: 做分布拟合实验，未完成
1. `generateTex.py`: 生成插图Tex代码，用到`handleProfiles.R`中间结果
1. `govposts.R`: 分析官媒数据
1. `handleProfiles.R`: 处理公众号，手动加入类别type
1. `loadData.R`: 载入数据
1. `loadPackages.R`: 载入全部包
1. `non10w.R`: 分析非10w+推送分布
1. `obj2csv.py`: 在json数据中选取有用的字段生成新的json数据
1. `profiles.R`: 分析公众号的分布
1. `pubposts.R`: 分析各个公众号的推送分布
1. `qq.R`: qq plot
1. `report`: 报告相关全部文件
1. `singlePost.R`: 分析单个推送
1. `stop_words.txt`: 停止词列表，注意行分割为LF。
1. `testMongo.R`: 测试R-Mongo链接
1. `utils.R`: 函数库

## Contribution
[@ritou11](lht18@mails.tsinghua.edu.cn): 主要代码编写，报告撰写
[@VioYueG](ygao266@wisc.edu): 理论分析，部分代码编写，报告撰写
