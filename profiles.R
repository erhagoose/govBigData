source('loadPackages.R', encoding = 'UTF-8')

# mongodb
mongourl <- "mongodb://192.10.10.108:27017/wechat_spider"
mposts <- mongo("posts", url = mongourl)
mpubs <- mongo("profiles", url = mongourl)
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

pubpost <- aggregate(nposts$msgBiz, list(msgBiz = nposts$msgBiz), length)
pub2 <- aggregate(nposts[c('readNum', 'likeNum')],
                  list(msgBiz = nposts$msgBiz),
                  mean)
pubpost = merge(pubpost, pub2, by = 'msgBiz')
pubpost = merge(pubpost,
             profiles[c('msgBiz', 'title', 'type')],
             by = 'msgBiz',
             all.x = TRUE)
pubpost = na.omit(pubpost)
ord <- order(pubpost$type, pubpost$x)
## arrange in plot
pubpost$title = factor(pubpost$title, levels = pubpost$title[ord])
pubpost$type = factor(pubpost$type, levels = c('政府发布', '官方媒体', '机构媒体', '内容运营'))

ggplot(pubpost, aes(title, x, fill=readNum), na.rm= TRUE) +
  coord_flip() +
  geom_bar(stat = 'identity', na.rm= TRUE) +
  labs(x = '公众号名称', y = '推送文章数') +
  guides(fill = guide_legend(title = '阅读量')) +
  facet_grid(type ~., scales = 'free_y', space="free_y", drop = TRUE) +
  theme(text = element_text(family='Kai'))
  