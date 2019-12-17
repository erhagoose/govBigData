# show one post via wordcloud

source('loadPackages.R', encoding = 'UTF-8')
source('utils.R')
library('jiebaR')
library('text2vec')
library('glmnet')

# mongodb
mongourl <- "mongodb://localhost:27017/wechat_spider"
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
  fields = '{"msgBiz" : true,
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
pubtitle <- '深圳发布'
pbps <- merge(posts,
              profiles[c('msgBiz', 'title', 'type')],
              by = 'msgBiz',
              all.x = TRUE)
pubposts <- pbps[pbps['title.y'] == pubtitle,]

# segment & create vocab
wk <- worker(stop_word = 'stop_words.txt', bylines = TRUE)
seg <- function(k) wk[k]
it = itoken(pubposts$content,
                  tokenizer = seg,
                  ids = pubposts$`_id`, 
                  progressbar = TRUE)
vocab = create_vocabulary(it) %>% 
        prune_vocabulary(term_count_min = 5)
# vectorize
vectorizer = vocab_vectorizer(vocab)
t1 = Sys.time()
dtm = create_dtm(it, vectorizer)
print(difftime(Sys.time(), t1, units = 'sec'))
# tf-idf
tfidf = TfIdf$new()
dtm_tfidf = fit_transform(dtm, tfidf)

# fit
lda_model = LDA$new(n_topics = 10, doc_topic_prior = 0.1, topic_word_prior = 0.01)
doc_topic_distr = 
  lda_model$fit_transform(x = dtm, n_iter = 1000, 
                          convergence_tol = 0.0001, n_check_convergence = 25, 
                          progressbar = TRUE)
wds <- lda_model$get_top_words(n = 10, lambda = 0.3)
topwords <- wds[1,]

# plot lda
lda_model$plot()

# plot dist
doc_topic_rdnum <- as.data.frame(doc_topic_distr * pubposts$readNum)
topic_vals <- tidyr::gather(doc_topic_rdnum, 'label')
mp <- setNames(topwords, colnames(doc_topic_rdnum))
topic_vals$label = mp[topic_vals$label]

ggplot(topic_vals, aes(label, value), na.rm= TRUE) +
  geom_boxplot(outlier.size=0) +
  labs(x = '主题首要词', y = '折算传播力度', title = sprintf('%s主题情况', pubtitle)) +
  coord_cartesian(ylim = c(0, 400)) +
  theme(text = element_text(family='Kai'),
        plot.title = element_text(hjust = 0.5))
ggsave(sprintf("outputs/%s.svg", pubtitle), width = 8, height = 6)
