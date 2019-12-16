# set types of profiles according to the csv file

library("mongolite")
library("ggplot2")
library("ggpubr")

# mongodb
mongourl <- "mongodb://192.10.10.108:27017/wechat_spider"
mpubs <- mongo("profiles", url = mongourl)
mpubs$count('{}')

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

write.csv(profiles, 'outputs/profiles.csv')

ep <- read.csv('outputs/profiles.csv', stringsAsFactors = FALSE)
attach(ep)
for (i in 1:nrow(ep)) {
  mpubs$update(
    query = sprintf('{ "msgBiz": "%s" }', msgBiz[i]),
    update = sprintf('{"$set":{ "type": "%s" }}', type[i])
  )
}
detach(ep)
