source('loadPackages.R', encoding = 'UTF-8')
# mongodb
mongourl <- "mongodb://192.10.10.108:27017/wechat_spider"
mposts <- mongo("posts", url = mongourl)
mpubs <- mongo("profiles", url = mongourl)
mposts$count('{}')
mpubs$count('{}')


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
nposts = na.omit(posts)
## Drop readNum < 10
nposts = nposts[nposts$readNum >= 10,]
summary(nposts)

hist(nposts$readNum, main='All Posts: readNum', xlab='Times')
hist(nposts$likeNum, main='All Posts: likeNum', xlab='Times')

ggplot(nposts, aes(readNum)) +
  geom_histogram(bins = 100, color = 'white') +
  labs(x = '阅读量', y = '推送文章数', title = '全部有效文章阅读量分布') +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave("outputs/allR.png", width = 7, height = 5, dpi = 600)
ggsave("outputs/allR.svg", width = 7, height = 5)

ggplot(nposts, aes(likeNum)) +
  geom_histogram(binwidth = 100, color = 'white') +
  scale_x_continuous(limits = c(NA, 3000)) +
  labs(x = '在看量', y = '推送文章数', title = '全部有效文章在看量分布') +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave("outputs/allL.png", width = 7, height = 5, dpi = 600)
ggsave("outputs/allL.svg", width = 7, height = 5)

non10wR = nposts[(nposts$readNum <= 1e5) & (nposts$readNum > 0),]
non10wL = nposts[(nposts$likeNum <= 1e5) & (nposts$readNum > 0),]

ggplot(non10wR, aes(readNum)) +
  geom_histogram(bins = 100, color = 'white') +
  labs(x = '阅读量', y = '推送文章数', title = '非10万+文章阅读量分布') +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave("outputs/non10wR.png", width = 7, height = 5, dpi = 600)
ggsave("outputs/non10wR.svg", width = 7, height = 5)

ggplot(non10wL, aes(likeNum)) +
  geom_histogram(binwidth = 100, color = 'white') +
  scale_x_continuous(limits = c(NA, 3000)) +
  labs(x = '在看量', y = '推送文章数', title = '非10万+文章在看量分布') +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave("outputs/non10wL.png", width = 7, height = 5, dpi = 600)
ggsave("outputs/non10wL.svg", width = 7, height = 5)

# v <- rep(0, 100000)
# t <- as.data.frame(table(non10wR$readNum))
# v[as.numeric(levels(t$Var1)[t$Var1])] = t$Freq
# r <- poisson.fit(v, length(nposts$readNum) - length(non10wR$readNum))
