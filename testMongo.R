library("mongolite")

# mongodb
mongourl <- "mongodb://192.10.10.108:27017/wechat_spider"
mposts <- mongo("posts", url = mongourl)
mpubs <- mongo("profiles", url = mongourl)
mposts$count('{}')
mpubs$count('{}')
