source('loadPackages.R', encoding = 'UTF-8')
source('utils.R')

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

# aggregate posts for profiles
pubpost <- aggregate(nposts$msgBiz, list(msgBiz = nposts$msgBiz), length)
pub2 <- aggregate(nposts[c('readNum', 'likeNum')],
                  list(msgBiz = nposts$msgBiz),
                  mean)
func_wpi <- function (posts, msgBiz) {
  return(data.frame(msgBiz = msgBiz, wpi = wpi(posts)))
}
pub3 <- bind_rows(group_map(group_by(nposts, msgBiz), func_wpi))
pubpost = merge(pubpost, pub2, by = 'msgBiz')
pubpost = merge(pubpost, pub3, by = 'msgBiz')
pubpost = merge(pubpost,
                profiles[c('msgBiz', 'title', 'type')],
                by = 'msgBiz',
                all.x = TRUE)
pubpost = na.omit(pubpost)

# plot
## arrange in plot
ord <- order(pubpost$type, pubpost$x)
pubpost$title = factor(pubpost$title, levels = pubpost$title[ord])
pubpost$type = factor(pubpost$type, levels = c('政府发布', '官方媒体', '机构媒体', '内容运营'))
## draw
ggplot(pubpost, aes(title, x, fill=wpi), na.rm= TRUE) +
  coord_flip() +
  geom_bar(stat = 'identity', na.rm= TRUE) +
  labs(x = '公众号名称', y = '推送文章数', title = '各公众号推送文章获取情况') +
  guides(fill = guide_legend(title = 'WPI')) +
  scale_fill_gradient(low = '#00B1F7', high = '#aa2B43') +
  facet_grid(type ~., scales = 'free_y', space="free_y", drop = TRUE) +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave("outputs/profiles.svg", width = 6, height = 8)
