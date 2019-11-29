library("mongolite")
mongourl <- "mongodb://localhost:27017/wechat_spider"
mposts <- mongo("posts", url = mongourl)
mpubs <- mongo("profiles", url = mongourl)

mposts$count('{}')
mpubs$count('{}')
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
# summary(posts)
nposts = na.omit(posts)
summary(nposts)
boxplot(nposts$readNum, main="All Posts: readNum", ylab="Times")
boxplot(nposts$likeNum, main="All Posts: likeNum", ylab="Times")
hist(nposts$readNum, main="All Posts: readNum", xlab="Times")
hist(nposts$likeNum, main="All Posts: likeNum", xlab="Times")

library("ggplot2")
ggplot(data=nposts, aes(x=readNum, y=likeNum)) + geom_point()
