# show one post via wordcloud

source('loadPackages.R', encoding = 'UTF-8')
source('utils.R')
library('jiebaR')
library('text2vec')

# mongodb
mongourl <- "mongodb://192.10.10.108:27017/wechat_spider"
mposts <- mongo("posts", url = mongourl)
mpubs <- mongo("profiles", url = mongourl)

# load data from mongo
profiles <- mpubs$find(
  query = '{}', 
  fields = '{"_id": false,
            "msgBiz" : true,
            "title" : true,
            "openHistoryPageAt" :true,
            "updatedAt": true,
            "type": true
          }'
)
profiles = na.omit(profiles)
posts <- mposts$find(
  query = '{}', 
  fields = '{"_id": false,
            "msgBiz" : true,
            "msgMid" : true,
            "msgIdx" : true,
            "title" : true,
            "publishAt" :true,
            "readNum": true,
            "likeNum": true,
            "content": true
          }',
  sort = '{ "publishAt": -1 }'
)
posts <- na.omit(posts)
summary(posts)

# cross query
pbps <- merge(posts,
              profiles[c('msgBiz', 'title', 'type')],
              by = 'msgBiz',
              all.x = TRUE)
pubposts <- pbps[pbps['title.y'] == '深圳发布',]

# segment
wk <- worker(stop_word = 'stop_words.txt', bylines = TRUE)
seg <- function(k) wk[k]

