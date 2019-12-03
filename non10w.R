source('loadPackages.R', encoding = 'UTF-8')
library("ggpubr")

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

# Plot all
boxplot(nposts$readNum, main="All Posts: readNum", ylab="Times")
boxplot(nposts$likeNum, main="All Posts: likeNum", ylab="Times")
hist(nposts$readNum, main="All Posts: readNum", xlab="Times")
hist(nposts$likeNum, main="All Posts: likeNum", xlab="Times")

non10w = nposts[nposts$readNum <= 1e5,]
## hist
ggplot(data=non10w, aes(x=readNum, fill=msgIdx)) +
  geom_histogram(bins = 100) +
  labs(title = "Non 10w+: readNum on msgIdx")
ggplot(data=non10w, aes(x=likeNum, fill=msgIdx)) +
  geom_histogram(bins = 100) +
  scale_x_continuous(limits = c(0, 1500)) +
  scale_y_continuous(limits = c(0, 6000)) +
  labs(title = "Non 10w+: likeNum on msgIdx")
## scatter hist
ggplot(data=non10w, aes(x=readNum, y=likeNum)) +
  geom_point()
ggscatterhist(non10w, x="readNum", y="likeNum",
              size = 1, alpha = 0.8, group = "msgIdx", shape = 16,
              palette = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7"),
              margin.plot = "hist",
              bins = 100,
              ggtheme = theme_minimal())