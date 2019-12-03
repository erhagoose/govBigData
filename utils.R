## Post Propagation Index

ppi <- function (readNum, likeNum) {
  if (readNum > 100000) { readNum = readNum * 1.5 }
  if (likeNum > 100000) { likeNum = likeNum * 1.5 }
  return(0.85 * log(1 + readNum)  + 0.15 * log(1 + likeNum))
}

## Weixin Propagation Index

wpi <- function (posts) {
  mr <- max(posts$readNum, na.rm = TRUE)
  ml <- max(posts$likeNum, na.rm = TRUE)
  ar <- mean(posts$readNum, na.rm = TRUE)
  al <- mean(posts$likeNum, na.rm = TRUE)
  sumr <- sum(posts$readNum, na.rm = TRUE)
  suml <- sum(posts$likeNum, na.rm = TRUE)
  pt <- posts[posts$msgIdx == 1,]
  if (nrow(pt) == 0) {
    art <- 0
    alt <- 0
  } else {
    art <- mean(pt$readNum, na.rm = TRUE)
    alt <- mean(pt$likeNum, na.rm = TRUE)
  }
  d <- 1 + as.integer(max(posts$publishAt, na.rm = TRUE) - min(posts$publishAt, na.rm = TRUE))
  return (  0.1 * ppi(mr, ml)
          + 0.3 * (0.85 * log(1 + ar)  + 0.15 * log(1 + al))
          + 0.3 * (0.85 * log(1 + art)  + 0.15 * log(1 + alt))
          + 0.3 * (0.85 * log(1 + sumr / d)  + 0.15 * log(1 + suml / d)))
}

