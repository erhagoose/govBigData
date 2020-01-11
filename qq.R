# need profiles, pbps
source('loadPackages.R')
source('utils.R')
source('loadData.R', encoding = 'UTF-8')

for (pubtitle in profiles$title) {
  print(pubtitle)
  # get pubposts
  pubposts <- pbps[pbps['title.y'] == pubtitle,]
  pubposts = na.omit(pubposts)
  pubposts$ppi <- mapply(ppi, pubposts$readNum, pubposts$likeNum)
  qqplot.data(pubposts$ppi)
  ggsave(sprintf('outputs/%s-qq.png', pubtitle), width = 6, height = 6)
  # ggsave(sprintf('outputs/%s-qq.svg', pubtitle), width = 6, height = 6)
}

