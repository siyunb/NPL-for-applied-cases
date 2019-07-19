library(ggplot2)
library(plyr)
library(dplyr)
library(showtext)                                #使作图的字体更加丰富
library(plyr)
library(dplyr)
library(mice)
library(stringr)   #字符串处理
library(grid)
library(lubridate)
library(Cairo)
 #增加字体
font_add("kaishu", "simkai.ttf")                    
link = "https://dl.dafont.com/dl/?f=lassus"
download.file(link, "lassus.zip", mode = "wb")
unzip("lassus.zip");
font_add("lassus", "lassus.ttF")
#
unzip("dj_icons.zip");
font_add("dj_icons", "DJ Icons.ttF")
unzip("superstar_x.zip");
font_add("Superstar X", "Superstar X.ttF")
unzip("trump.zip");
font_add("Trump-Regular", "Trump-Regular.ttf")
unzip("look_for_america.zip");
font_add("LOOKA", "LOOKA___.TTF")
unzip("moolah.zip");
font_add("Moolah", "Moolah.ttF")
font.families()


setwd("D:/bigdatahw/Case contest/data")              #设置工作路径
data = read.csv('描述性.csv',head=TRUE) 
md.pattern(data)                                     #检查缺失值
data$year = year(data$date)
data$month = month(data$date)
data$day = day(data$date)

##中美贸易战季节趋势
season_data<-data %>%
  select(season,source) %>%
  group_by(season) %>%
  summarize(season_count = n()) %>%
  arrange(desc(season_count))

CairoPNG("season.png", 600, 600)              #打开一个图形设备
showtext.begin()                                    #开始使用showtext
season_data$season = factor(season_data$season,levels=c('三月下旬','四月上旬','四月中旬','四月下旬'))
ggplot(season_data, aes(x = season, y = season_count,fill=season)) +
  geom_bar(stat = "identity",width = 0.7) +
  scale_x_discrete("季度") +
  scale_y_continuous("新闻数目(10条)") +
  theme(axis.text.x=element_text( angle = 270,family="kaishu"),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=28,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        plot.background = element_rect(fill="ivory1")) +
  ggtitle("每季度中美贸易战新闻数目")
showtext_end()
dev.off()
################
gdat = ddply(season_data, "season", function(d) {
  male = d$season_count/10;
  data.frame(gender = c(rep("m", male)),x = 1:male)});
gdat$char = ifelse(gdat$gender == "m", "p", "u");
yinfuzhu=c('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X',
           'Y','Z','a','b','c','d','f','g','h','i','r')

samples<- c(rep(1:54))
for(i in samples){
  if (i==1){
    j=1
  }
  gdat$char[i]=yinfuzhu[j]
  j=j+1
  if(gdat$season[i]!=gdat$season[i+1]){
    j=1
  }
}
gdat$char[55]='n'


CairoPNG("edu-stat.png", 1500, 550);
showtext.begin();
theme_set(theme_grey(base_size = 20));
ggplot(gdat, aes(x = x, y = season)) +geom_text(aes(label = char, colour = season),family = "Trump-Regular", size = 15) +
  scale_x_continuous("新闻数目") +scale_y_discrete("季度",labels = c('三月下旬','四月上旬','四月中旬','四月下旬')) +
  theme(axis.text.x=element_text( family="kaishu",size=22,color="red"),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=33,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank(),
        plot.background = element_rect(fill="ivory1"))+
  ggtitle("每季度中美贸易战新闻数目(10条)");
showtext_end()
dev.off()

write.csv(data,"D:/bigdatahw/Case contest/data/中美.csv",row.names = TRUE)  #输出实验总体集

library(wordcloud2)
word_count_33 = read.csv('word_count_season33.csv',head=FALSE)  #读取测试集的总体数据
word_count_41 = read.csv('word_count_season41.csv',head=FALSE)  #读取测试集的总体数据
word_count_42 = read.csv('word_count_season42.csv',head=FALSE)  #读取测试集的总体数据
word_count_43 = read.csv('word_count_season43.csv',head=FALSE)  #读取测试集的总体数据

CairoPNG("season33.png", 600, 600);
showtext.begin();
wordcloud2(word_count_2012, color = "random-light",shape='star', backgroundColor = "aliceblue")
showtext.end();
dev.off()


plot_shape <- function(filename, char){ 
  CairoPNG(filename, 2000, 1300) 
  showtext.begin() 
  plot.new() 
  offset = par(mar = par()$mar) 
  op = par(mar = c(0,0,0,0)) 
  text(0.5, 0.5, char, family='LOOKA', cex=125) 
  par(offset) 
  showtext.end() 
  dev.off() }
plot_shape('meichao.png', 'L') 
plot_shape('do.png', 'D') 
plot_shape('tingge2.png', 'D') 
plot_shape('tingge3.png', 'h') 

wordcloud2(word_count_42[1:450,], figPath = 'tingge2.png', 
           backgroundColor = 'black', color = 'random-light')
##################
media_data<-data %>%
  select(source,season) %>%
  group_by(source) %>%
  summarize(source_count = n()) %>%
  arrange(desc(source_count))

media_data_10 = media_data[2:10,]

gdat = ddply(media_data_10,"source",function(d) {
  male = d$source_count;
  data.frame(gender = c(rep("m", male)),x = 1:male)});
gdat$char = ifelse(gdat$gender == "m", "T", "L")
gdat$char = 'T'

CairoPNG("media_top9.png",800, 700)              #打开一个图形设备
showtext.begin()                                    #开始使用showtext
#album_data_10$album = factor(album_data_10$album,levels=c('More Life','Purpose (Deluxe)','Views','Starboy','1989 (Deluxe)','DAMN.','÷ (Deluxe)','Nothing Was The Same','Culture II','Luv Is Rage 2'))
ggplot(gdat, aes(x = source, y = x)) +geom_text(aes(label = char ),colour = 'gold',family = "Moolah", size = 12) +
  scale_x_discrete("媒体") +
  scale_y_continuous("发表新闻次数") +
  theme(axis.text.x=element_text( angle = 270,family="kaishu",size=15),
        plot.title = element_text(hjust = 0.5, family="wqy-microhei",size=24,color="blue"),
        panel.background=element_rect(fill='aliceblue',color='black'),
        panel.grid.minor = element_blank(),
        panel.grid.major =element_blank()) +
  ggtitle("中美贸易战新闻数量媒体排名")
showtext_end()
dev.off()


word_count_33$V3=word_count_33$V2/41
word_count_41$V3=word_count_41$V2/320
word_count_42$V3=word_count_42$V2/151
word_count_43$V3=word_count_43$V2/47

word_count_33=word_count_33[3:12,]
word_count_41=word_count_41[3:12,]
word_count_42=word_count_42[3:12,]
word_count_43=word_count_43[3:12,]
word_count_33$V1 = factor(word_count_33$V1,levels=c('贸易战','贸易','关税','中','特朗普','市场','上','表示','会','美'))
word_count_41$V1 = factor(word_count_41$V1,levels=c('贸易战','市场','中','贸易','特朗普','关税','会','美','经济','上'))
word_count_42$V1 = factor(word_count_42$V1,levels=c('市场','中','贸易战','贸易','企业','上','影响','中兴','经济','不'))
word_count_43$V1 = factor(word_count_43$V1,levels=c('中','市场','贸易战','上','可能','会','公司','经济','华为','企业'))



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

p1 <- ggplot(word_count_33, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("词料") +
  scale_y_discrete("每个新闻平均出现次数",limits = c(0,10)) +
  ggtitle("三月下旬新闻常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x =word_count_33$V1,y=word_count_33$V3,label=as.character(round(word_count_33$V3,2)),size=4,vjust = -1)+
  theme_opts

p2 <- ggplot(word_count_41, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("单词") +
  scale_y_discrete("每个新闻平均出现次数",limits = c(0,10)) +
  ggtitle("四月上旬新闻常用词汇")+
  guides(fill=FALSE)+ 
  annotate(geom="text",x = word_count_41$V1,y=word_count_41$V3,label=as.character(round(word_count_41$V3,2)),size=4,vjust = -1)+
  theme_opts

p3 <- ggplot(word_count_42, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("词料") +
  scale_y_discrete("每个新闻平均出现次数",limits = c(0,10)) +
  ggtitle("四月中旬新闻常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x = word_count_42$V1,y=word_count_42$V3,label=as.character(round(word_count_42$V3,2)),size=4,vjust = -1)+
  theme_opts

p4 <- ggplot(word_count_43, aes(x = V1, y = V3,fill='lightpink1')) +
  geom_bar(stat = "identity",width = 0.7,alpha=0.6) +
  scale_x_discrete("词料") +
  scale_y_discrete("每个新闻平均出现次数",limits = c(0,10)) +
  ggtitle("四月下旬新闻常用词汇")+
  guides(fill=FALSE)+
  annotate(geom="text",x = word_count_43$V1,y=word_count_43$V3,label=as.character(round(word_count_43$V3,2)),size=4,vjust = -1)+
  theme_opts   

print(p1, vp = vp(1, 1))
print(p2, vp = vp(1, 2))
print(p3, vp = vp(2, 1))
print(p4, vp = vp(2, 2))

