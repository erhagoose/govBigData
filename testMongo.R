library("mongolite")
mposts <- mongo("posts", url = "mongodb://localhost:27017/wechat_spider")
mpubs <- mongo("profiles", url = "mongodb://localhost:27017/wechat_spider")
print(mpubs)
mposts$count('{}')
mpubs$count('{}')
posts <- mposts$find(
  query = '{}', 
  fields = '{"_id": false, "msgBiz" : true, "msgMid" : true, "msgIdx" : true, "title" : true}',
  limit = 10
)
print(posts)
