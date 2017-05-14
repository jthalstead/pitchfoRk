### init
rm(list = ls())

library(xml2)
library(jsonlite)
library(stringr)

### pitchfork
npage = 3
url_list = NULL
reviews = 'http://pitchfork.com/reviews/albums/'
for (i in 1:npage){
  print(i)
  l = paste(reviews, '?page=', i, sep = '')
  links = xml_attr(xml_find_all(read_html(l), "//a"), "href")
  list = links[grep('/reviews/albums/[[:digit:]]', links)]
  url_list = c(list, url_list)
}

all = NULL
for (j in 1:length(url_list)){
  print(j)
  html = as_list(read_html(paste('http://pitchfork.com', url_list[j], sep = '')))
  info = html$head$script[[1]]
  head = fromJSON(info)$headline
  data = data.frame(artist = trimws(str_sub(head, 1, regexpr('\\:', head)-1)), 
                    album = trimws(str_sub(head, regexpr('\\:', head)+1, regexpr('\\|', head)-1)), 
                    genre = fromJSON(info)$keywords[2],
                    rating = trimws(str_sub(head, regexpr('\\|', head)+1)),
                    date = as.Date(fromJSON(info)$dateCreated))
  all = rbind(data, all)
}



