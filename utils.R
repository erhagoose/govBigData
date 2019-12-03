## Post Propagation Index

ppi <- function (readNum, likeNum) {
  if (readNum > 100000) readNum = readNum * 1.5
  if (likeNum > 100000) likeNum = likeNum * 1.5
  return(0.85 * log(1 + readNum)  + 0.15 * log(1 + likeNum))
}

## Weixin Propagation Index

wpi <- function (posts) {
  mr <- max(posts$readNum, na.rm = TRUE)
  ml <- max(posts$likeNum, na.rm = TRUE)
  return (ppi(mr, ml))
}

