# -*- coding: utf-8 -*-
"""
Created on Thu Apr 19 21:52:22 2018

@author: Bokkin Wang
"""
from selenium import webdriver                #selenium实现自动化
from urllib.parse import urlencode
from bs4 import BeautifulSoup
from multiprocessing import Pool
from lxml import etree
from collections import OrderedDict
import pandas as pd
import xlwt
import os
import requests
import re

def crawl(coff,n=15):
    comp=coff[0]
    page=coff[1]
    newsData = OrderedDict()
    for i in list(range(page,page+n)):
        url = 'http://search.sina.com.cn/?%s&range=title&c=news&num=20&col=1_7&page=%s' % (comp, str(i))
        html = requests.get(url)
        soup=BeautifulSoup(html.content,'html.parser',from_encoding="gb18030")    #解析网页
        divs = soup.findAll('div', {"class": "r-info r-info2"})
        for div in divs:
            head = div.findAll('h2')[0]
            titleinfo = head.find('a')           # 新闻标题
            title = titleinfo.get_text()
            href = titleinfo['href']              # 新闻链接
            otherinfo = head.find('span', {"class": "fgray_time"}).get_text()
            source, date, time = otherinfo.split()                             # 其他信息
            abstract = div.find('p', {"class": "content"}).get_text()          # 新闻摘要
            origin_url,detail = crawl_con(href)
            newsData[title] = [date, time,source, abstract,rm_char(detail),href,origin_url]  #这一步是关键的一步
    write_to_excel(newsData,page)

def crawl_con(href):
    site = requests.get(href)
    site=site.content
    response = etree.HTML(site)
    try:
        origin_url = response.xpath('//*[@id="top_bar"]/div/div[2]/a/@href') 
        detail = "\001".join(response.xpath('//div[@class="article"]/div/p/text()'))+"\001".join(response.xpath('//div[@class="article"]/p/text()'))
    except:
        origin_url =""
        detail =""
    return origin_url,detail
        
def rm_char(text):
    text = re.sub('\u3000', '', text)    #全角的空白符
    return text

def write_to_excel(results,temp):
    workbook = xlwt.Workbook(encoding='utf-8')       #打开一个工作簿，编码为utf-8
    worksheet = workbook.add_sheet(str(temp)+'_'+str(temp+4))
    worksheet.write(0, 0, 'title')
    worksheet.write(0, 1, 'date')
    worksheet.write(0, 2, 'time')
    worksheet.write(0, 3, 'source')
    worksheet.write(0, 4, 'abstract')
    worksheet.write(0, 5, 'detail')
    worksheet.write(0, 6, 'url')
    worksheet.write(0, 7, 'origin_url')
    flag = 1
    for key, value in results.items():
        worksheet.write(flag, 0, key)
        for j in list(range(7)):
            worksheet.write(flag, j+1, value[j])
        flag += 1
    workbook.save(os.getcwd()+'\\trade_war'+str(temp)+'_'+str(temp+4)+'.xls')


if __name__=='__main__':
    os.chdir("D:/bigdatahw/应用统计案例/case2018Lab6")
    print('请输入您想爬取内容的关键字：')
    compRawStr = input('关键字： \n')     #键盘读入
    print('正在爬取“' + compRawStr.capitalize()+ '”!')
    d = {'q': compRawStr.encode('gbk')}
    pname = urlencode(d)
	#爬取两类数据，采用多进程爬取
    first = [pname,1]
    second = [pname,16]
    third = [pname,31]
    p=Pool(3)
    p.map(crawl,[first,second,third])       #爬取15页内容
    p.close()
    p.join()





