# -*- coding: utf-8 -*-
"""
Created on Fri Apr 20 17:42:28 2018

@author: Bokkin Wang
"""
from selenium import webdriver                #selenium实现自动化
from bs4 import BeautifulSoup
from multiprocessing import Pool
from lxml import etree
from collections import OrderedDict
import xlwt
import time
import os
import requests
import re

def crawl_one(html):
    soup=BeautifulSoup(html,'html.parser',from_encoding="gb18030")    #解析网页
    divs = soup.findAll('div', {"class": "r-info r-info2"})
    data = OrderedDict()
    for div in divs:
        head = div.findAll('h2')[0]
        titleinfo = head.find('a')           # 新闻标题
        title = titleinfo.get_text()
        href = titleinfo['href']              # 新闻链接
        otherinfo = head.find('span', {"class": "fgray_time"}).get_text()
        source, date, time_ = otherinfo.split()                             # 其他信息
        abstract = div.find('p', {"class": "content"}).get_text()          # 新闻摘要
        origin_url,detail = crawl_two(href)
        data[title] = [date, time_,source, abstract,rm_char(detail),href,origin_url]
    return data
    

def crawl(string,n=100):
    newsData = OrderedDict()
    url='http://search.sina.com.cn/?t=news'
    driver =webdriver.Chrome('C:/Program Files (x86)/Google/chrome/Application/chromedriver.exe')   #打开浏览器
    driver.get(url)    #输入网址
    driver.implicitly_wait(5)
    Elem=driver.find_element_by_xpath('//*[@id="tabc02"]/form/div/input[1]')       #找到id为kw的元素
    Elem.send_keys(string)   
    sub_Elem=driver.find_element_by_xpath('//*[@id="tabc02"]/form/div/input[4]')
    sub_Elem.click()   #模拟点击功能
    time.sleep(2)     #设置延迟
    html=driver.page_source
    newsData.update(crawl_one(html))
    #点击下一页进行，模拟浏览器翻页的功能
    for i in range(n):
        sub_Elem=driver.find_element_by_xpath('//*[@id="_function_code_page"]/a[@title="下一页"]')
        sub_Elem.click()   #模拟点击功能
        time.sleep(1) 
        html=driver.page_source
        newsData.update(crawl_one(html))
    write_to_excel(newsData,string)

def crawl_two(href):
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
    worksheet = workbook.add_sheet(temp)
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
    workbook.save(os.getcwd()+'\\trade_war'+'_'+temp+'.xls')
    
if __name__=='__main__':
    os.chdir("D:/bigdatahw/应用统计案例/case2018Lab6")
    print('请输入您想爬取内容的关键字：')
    compRawStr = input('关键字： \n')     #键盘读入
    print('正在爬取“' + compRawStr.capitalize()+'”有关的新闻'+ '!')
    comp = compRawStr.split()
	#爬取两类数据，采用多进程爬取
    first = comp[0]
    second = comp[1]
    third = comp[2]
    crawl(first)
#    p=Pool(3)
#    p.map(crawl,[first,second,third])       #爬取4页内容
#    p.close()
#    p.join()