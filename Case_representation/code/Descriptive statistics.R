library(ggplot2)
library(plyr)
library(dplyr)
library(showtext)                                #使作图的字体更加丰富
library(plyr)
library(dplyr)
library(mice)
library(stringr)   #字符串处理
library(grid)
font_add("kaishu", "simkai.ttf")                     #增加字体
link = "https://dl.dafont.com/dl/?f=lassus"
download.file(link, "lassus.zip", mode = "wb")
unzip("lassus.zip");
font_add("lassus", "lassus.ttF")
#
unzip("dj_icons.zip");
font_add("dj_icons", "DJ Icons.ttF")
unzip("superstar_x.zip");
font_add("Superstar X", "Superstar X.ttF")
font.families()
setwd("D:/bigdatahw/Case contest/data")              #设置工作路径
all_data1 = read.csv('clean_songdata.csv',head=TRUE)  #读取测试集的总体数据
all_data2 = read.csv('song_info.csv',head=TRUE) 
all_data=merge(all_data1,all_data2,by='url',all.x=TRUE) 
md.pattern(all_data)
data=all_data[-c(1,6,12)]
data$singer=as.factor(data$singer)

singer_data<-data %>%
  select(singer,album) %>%
  group_by(singer) %>%
  summarize(singer_count = n()) %>%
  arrange(desc(singer_count))

#上榜歌曲数量top10的歌手
singer_data_10 = singer_data[1:10,]
singer_data_10 = as.data.frame(singer_data_10)
singer_data_10$singer = as.character(singer_data_10$singer)
#singer_data_10$singer_count = round(singer_data_10$singer_count /10)

CairoPNG("singer_top10.png", 600, 600)              #打开一个图形设备
showtext.begin()                                    #开始使用showtext
singer_data_10$singer = factor(singer_data_10$singer,levels=c('Drake','Justin Bieber','Taylor Swift','One Direction','The Weeknd','Future','Kendrick Lamar','Ed Sheeran','Migos','Meek Mill'))
ggplot(singer_data_10, aes(x = singer, y = singer_count,fill=singer)) +
  geom_bar(stat = "identity",width = 0.7) +
  scale_x_discrete("歌手") +
  scale_y_continuous("上榜歌曲数(十首)") +
  theme(axis.text.x=element_text( angle = 270,family="kaishu"),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=22,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        plot.background = element_rect(fill="ivory1")) +
  ggtitle("上榜歌曲数量歌手排名")
showtext_end()
dev.off()
#########################################
singer_data_10$singer = factor(singer_data_10$singer,levels=c('Meek Mill','Migos','Ed Sheeran','Kendrick Lamar','Future','The Weeknd','One Direction','Taylor Swift','Justin Bieber','Drake'))

gdat = ddply(singer_data_10, "singer", function(d) {
  male = d$singer_count;
  data.frame(gender = c(rep("m", male)),x = 1:male)});
gdat$char = ifelse(gdat$gender == "m", "p", "u");
yinfuzhu=c('`','1','A','V','~','D','Q','F','G','W','R','T','P','a','b','c','d','f','i','m','n','o','q','p',
           '`','1','A','V','~','D','Q','F','G','W','R','T','P','a','b','c','d','f','i','m','n','o','q','p',
           '`','1','A','V','~','D','Q','F','G','W','R','T','P','a','b','c','d','f','i','m','n','o','q','p',
           '`','1','A','V','~','D','Q','F','G','W','R','T','P','a','b','c','d','f','i','m','n','o','q','p')

samples<- c(rep(1:364))
for(i in samples){
  if (i==1){
    j=1
  }
  gdat$char[i]=yinfuzhu[j]
  j=j+1
  if(gdat$singer[i]!=gdat$singer[i+1]){
    j=1
  }
}
gdat$char[365]='n'



CairoPNG("edu-stat.png", 1500, 550);
showtext.begin();
theme_set(theme_grey(base_size = 20));
ggplot(gdat, aes(x = x, y = singer)) +geom_text(aes(label = char, colour = singer),family = "lassus", size = 15) +
  scale_x_continuous("上榜歌曲数") +scale_y_discrete("歌手",labels = c('Meek Mill','Migos','Ed Sheeran','Kendrick Lamar','Future','The Weeknd','One Direction','Taylor Swift','Justin Bieber','Drake')) +
  theme(axis.text.x=element_text( family="kaishu",size=22,color="red"),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=33,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        plot.background = element_rect(fill="ivory1"))+
  ggtitle("上榜歌曲数量歌手排名");
showtext.end();
dev.off()
###############################################
write.csv(alldata,"D:/bigdatahw/Case contest/data/alldata.csv",row.names = TRUE)  #输出实验总体集

##############################################
####################词云######################
##############################################
library(wordcloud2)
wordcloud2(demoFreq)
word_count_2012 = read.csv('word_count_2012.csv',head=FALSE)  #读取测试集的总体数据
word_count_2013 = read.csv('word_count_2013.csv',head=FALSE)  #读取测试集的总体数据
word_count_2014 = read.csv('word_count_2014.csv',head=FALSE)  #读取测试集的总体数据
word_count_2015 = read.csv('word_count_2015.csv',head=FALSE)  #读取测试集的总体数据
word_count_2016 = read.csv('word_count_2016.csv',head=FALSE)  #读取测试集的总体数据
word_count_2017 = read.csv('word_count_2017.csv',head=FALSE)  #读取测试集的总体数据
word_count_2018 = read.csv('word_count_2018.csv',head=FALSE)  #读取测试集的总体数据

CairoPNG("word_count_2012.png", 600, 600);
showtext.begin();
wordcloud2(word_count_2012, color = "random-light",shape='star', backgroundColor = "aliceblue")
showtext.end();
dev.off()

plot_shape <- function(filename, char){ 
  CairoPNG(filename, 1500, 1300) 
  showtext.begin() 
  plot.new() 
  offset = par(mar = par()$mar) 
  op = par(mar = c(0,0,0,0)) 
  text(0.5, 0.5, char, family='dj_icons', cex=125) 
  par(offset) 
  showtext.end() 
  dev.off() }
plot_shape('tingge.png', 'u') 
plot_shape('tingge1.png', 'U') 
plot_shape('tingge2.png', 'X') 
plot_shape('tingge3.png', 'h') 

wordcloud2(word_count_2017[1:450,], figPath = 'tingge3.png', 
           backgroundColor = 'black', color = 'random-light')

#################
album_data<-data %>%
  select(album,singer) %>%
  group_by(album,singer) %>%
  summarize(album_count = n()) %>%
  arrange(desc(album_count))

album_data_10 = album_data[1:10,]
album_data_10 = as.data.frame(album_data_10)
album_data_10$album = as.character(album_data_10$album)
album_data_10$singer = as.character(album_data_10$singer)

gdat = ddply(album_data_10,.(album,singer), function(d) {
  male = d$album_count;
  data.frame(gender = c(rep("m", male)),x = 1:male)});
gdat$char = ifelse(gdat$gender == "m", "T", "u");



CairoPNG("album_top10.png",800, 700)              #打开一个图形设备
showtext.begin()                                    #开始使用showtext
album_data_10$album = factor(album_data_10$album,levels=c('More Life','Purpose (Deluxe)','Views','Starboy','1989 (Deluxe)','DAMN.','÷ (Deluxe)','Nothing Was The Same','Culture II','Luv Is Rage 2'))
ggplot(gdat, aes(x = album, y = x)) +geom_text(aes(label = char, colour = singer),family = "dj_icons", size = 12) +
  scale_x_discrete("专辑",labels = c('More Life','Purpose','Views','Starboy','1989','DAMN.','÷ ','Nothing','Culture II','Luv Is Rage 2')) +
  scale_y_continuous("上榜次数") +
  theme(axis.text.x=element_text( angle = 270,family="kaishu",size=15),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=24,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        plot.background = element_rect(fill="ivory1")) +
  ggtitle("上榜次数专辑排名")
showtext_end()
dev.off()

###################################

word_count_Country = read.csv('word_count_Country.csv',head=FALSE)  #读取测试集的总体数据
word_count_Pop = read.csv('word_count_Pop.csv',head=FALSE)  #读取测试集的总体数据
word_count_R_B = read.csv('word_count_R_B.csv',head=FALSE)  #读取测试集的总体数据
word_count_Rap = read.csv('word_count_Rap.csv',head=FALSE)  #读取测试集的总体数据

plot_shape <- function(filename, char){ 
  CairoPNG(filename, 1500, 1300) 
  showtext.begin() 
  plot.new() 
  offset = par(mar = par()$mar) 
  op = par(mar = c(0,0,0,0)) 
  text(0.5, 0.5, char, family='Superstar X',font=4,cex=40) 
  par(offset) 
  showtext.end() 
  dev.off() }
plot_shape('country.png', 'coun\ntry') 
plot_shape('pop.png', 'pop') 
plot_shape('rap.png', 'Rap') 
plot_shape('R&B.png', 'R&B') 


wordcloud2(word_count_Country[1:300,], figPath = 'country.png', 
           backgroundColor = 'grey', color = 'random-light')
wordcloud2(word_count_Pop[1:200,], figPath = 'pop.png', 
           backgroundColor = 'grey', color = 'random-light')
wordcloud2(word_count_R_B[1:200,], figPath = 'R&B.png', 
           backgroundColor = 'grey', color = 'random-light')
wordcloud2(word_count_Rap[1:200,], figPath = 'rap.png', 
           backgroundColor = 'grey', color = 'random-light')

word_count_Country$V3=word_count_Country$V2/293
word_count_Pop$V3=word_count_Pop$V2/675
word_count_R_B$V3=word_count_R_B$V2/137
word_count_Rap$V3=word_count_Rap$V2/574

word_count_Country=word_count_Country[1:10,]
word_count_Pop=word_count_Pop[1:10,]
word_count_R_B=word_count_R_B[1:10,]
word_count_Rap=word_count_Rap[1:10,]
word_count_Country$V1 = factor(word_count_Country$V1,levels=c('like','and','got','you','know','girl','baby','love','little','yeah'))
word_count_Pop$V1 = factor(word_count_Pop$V1,levels=c('love','you','know','and','like','got','baby','but','let','yeah'))
word_count_R_B$V1 = factor(word_count_R_B$V1,levels=c('know','love','you','like','got','baby','yeah','girl','and','get'))
word_count_Rap$V1 = factor(word_count_Rap$V1,levels=c('like','got','yeah','know','get','you','and','nia','bch','nigga'))

theme_opts<-list(theme(axis.text.x=element_text(),
      plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=18,color="blue"),
      panel.background=element_rect(fill='aliceblue',color='black'),
      panel.grid.minor = element_blank(),
      panel.grid.major =element_blank(),
      plot.background = element_rect(fill="ivory1")))




vp <- function(x, y) {
  viewport(layout.pos.row = x, layout.pos.col = y)
}
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))

p1 <- ggplot(word_count_Country, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("单词") +
  scale_y_continuous("每首歌平均出现次数",limits = c(0,3.5)) +
  ggtitle("country风格歌曲常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x = word_count_Country$V1,y=word_count_Country$V3,label=as.character(round(word_count_Country$V3,2)),size=4,vjust = -1)+
  theme_opts

p2 <- ggplot(word_count_Pop, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("单词") +
  scale_y_continuous("每首歌平均出现次数",limits = c(0,4.5)) +
  ggtitle("pop风格歌曲常用词汇")+
  guides(fill=FALSE)+ 
  annotate(geom="text",x = word_count_Pop$V1,y=word_count_Pop$V3,label=as.character(round(word_count_Pop$V3,2)),size=4,vjust = -1)+
  theme_opts

p3 <- ggplot(word_count_R_B, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("单词") +
  scale_y_continuous("每首歌平均出现次数",limits = c(0,5.5)) +
  ggtitle("R&B风格歌曲常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x = word_count_R_B$V1,y=word_count_R_B$V3,label=as.character(round(word_count_R_B$V3,2)),size=4,vjust = -1)+
  theme_opts

p4 <- ggplot(word_count_Rap, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("单词") +
  scale_y_continuous("每首歌平均出现次数",limits = c(0,6.5)) +
  ggtitle("Rap风格歌曲常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x = word_count_Rap$V1,y=word_count_Rap$V3,label=as.character(round(word_count_Rap$V3,2)),size=4,vjust = -1)+
  theme_opts   

print(p1, vp = vp(1, 1))
print(p2, vp = vp(1, 2))
print(p3, vp = vp(2, 1))
print(p4, vp = vp(2, 2))

####################################
data_company = read.csv('公司1.csv',head=TRUE)  #读取测试集的总体数据
ggplot(data_company, aes(company))+geom_bar(aes(fill=genre),position="fill")+
  coord_polar(theta = "y")+
  ggtitle('音乐公司与上榜歌曲风格')+
  theme(plot.title = element_text(hjust = 0.5,family="myFont",size=18,color="black"),      
        panel.background=element_rect(fill='aliceblue',color='black'))

####################################
ggplot(data_company,aes(x=factor(1),fill=genre))+
  geom_bar(aes(fill=genre),position="fill")+coord_polar(theta="y")+
  ggtitle('音乐公司与上榜歌曲风格')+
  theme(plot.title = element_text(hjust = 0.5,family="myFont",size=18,color="black"),      
        panel.background=element_rect(fill='aliceblue',color='black'))+facet_wrap(~company) 

###############################
data_singer$genre = factor(data_singer$genre,levels=c('Country','RAB','Rock','Rap/Hip Hop','Pop','Soundtrack'))
data_singer = read.csv('歌手.csv',head=TRUE)  #读取测试集的总体数据
ggplot(data_singer, aes(singer))+geom_bar(aes(fill=genre),position="fill")+
  coord_polar(theta = "y")+
  ggtitle('歌手与上榜歌曲风格')+
  theme(plot.title = element_text(hjust = 0.5,family="myFont",size=18,color="black"),      
        panel.background=element_rect(fill='aliceblue',color='black'))

