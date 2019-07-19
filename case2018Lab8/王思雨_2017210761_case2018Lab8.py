# -*- coding: utf-8 -*-
"""
Created on Sun May 13 11:38:58 2018

@author: Bokkin Wang
"""
import sys
import pandas as pd
import numpy as np
import collections
import os
import re
import jieba
import re
import string
import operator

os.chdir("D:/bigdatahw/python objects/")



def getNgrams(input, n):
    input = cleanInput(input)
    output = {} # 构造字典
    for i in range(len(input)-n+1):
        ngramTemp = " ".join(input[i:i+n])#.encode('utf-8')
        if ngramTemp not in output: #词频统计
            output[ngramTemp] = 0 #典型的字典操作
        output[ngramTemp] += 1
    return output

content = open("1.txt").read()
ngrams = getNgrams(content, 2)
sortedNGrams = sorted(ngrams.items(), key = operator.itemgetter(1), reverse=True) #=True 降序排列
print(sortedNGrams)



