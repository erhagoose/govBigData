# show one pub with topic words

source('loadPackages.R', encoding = 'UTF-8')
source('utils.R')
source('loadData.R', encoding = 'UTF-8')
library('jiebaR')
library('text2vec')
library('glmnet')
library('stargazer')

govposts <- pbps[pbps['type'] == '政府发布',]
gmposts <- pbps[pbps['type'] == '官方媒体',]