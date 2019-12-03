library(ggplot2)
# load data
posts <- mposts$find(
  query = '{}', 
  fields = '{"_id": false,
            "msgBiz" : true,
            "msgMid" : true,
            "msgIdx" : true,
            "title" : true,
            "publishAt" :true,
            "readNum": true,
            "likeNum": true
          }',
  sort = '{ "publishAt": -1 }'
)
## summary(posts)
# filter data
nposts <- na.omit(posts)
summary(nposts)
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
nposts = merge(nposts,
             profiles[c('msgBiz', 'title')],
             by = 'msgBiz',
             all.x = TRUE)

ggplot(nposts, aes(title.y)) +
  coord_flip() +
  stat_count() +
  theme(text = element_text(family='Kai'))

  