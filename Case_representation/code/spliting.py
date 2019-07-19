# -*- coding: utf-8 -*-
"""
Created on Sat Apr 28 00:52:35 2018

@author: Bokkin Wang
"""

import pandas as pd

shanggan = pd.read_excel('C:/Users/Bokkin Wang/data/season1.xls')
yuyue = pd.read_excel('C:/Users/Bokkin Wang/data/season2.xls')


for idx in list(range(shanggan.shape[0])):
    if (len(shanggan.iloc[idx,6])>15):
        with open('C:/Users/Bokkin Wang/data/起始/'+str(idx)+'.txt','wb+') as f:
            f.write(shanggan.iloc[idx,6].encode('utf8'))

for idx in list(range(yuyue.shape[0])):
    if (len(yuyue.iloc[idx, 6]) > 15):
        with open('C:/Users/Bokkin Wang/data/末尾/' + str(idx) + '.txt', 'wb+') as f:
            f.write(yuyue.iloc[idx, 6].encode('utf8') )
