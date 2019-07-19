# -*- coding: utf-8 -*-
"""
Created on Sun Apr  1 11:33:41 2018

@author: Bokkin Wang
"""

import os
import re
import nltk
import pandas as pd
import numpy as np
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.stem import PorterStemmer
from nltk.corpus import wordnet
from sklearn.feature_extraction.text import CountVectorizer  
import wordcloud
import matplotlib.pyplot as plt
from wordcloud import WordCloud, ImageColorGenerator
import PIL.Image as Image

path_doc_root = 'D:/bigdatahw/Case contest/data'
replacement_patterns = [
(r'won\'t', 'will not'),
(r'can\'t', 'cannot'),
(r'i\'m', 'i am'),
(r'ain\'t', 'is not'),
(r'(\w+)\'ll', '\g<1> will'),
(r'(\w+)n\'t', '\g<1> not'),
(r'(\w+)\'ve', '\g<1> have'),
(r'(\w+)\'s', '\g<1> is'),
(r'(\w+)\'re', '\g<1> are'),
(r'(\w+)\'d', '\g<1> would')
]

class loadFolders(object):   # 迭代器
    def __init__(self, par_path):
        self.par_path = par_path

    def __iter__(self):
        for file in os.listdir(self.par_path):
            file_abspath = os.path.join(self.par_path, file)
            if os.path.isdir(file_abspath):  
                yield file_abspath

class loadFiles(object):
    def __init__(self, par_path):
        self.par_path = par_path
    def __iter__(self):
        folders = loadFolders(self.par_path)
        for folder in folders:              
            catg = folder.split(os.sep)[-1]
            for file in os.listdir(folder):     
                file_path = os.path.join(folder, file)
                if os.path.isfile(file_path):
                    this_file = open(file_path, 'rb')
                    content = this_file.read().decode('utf8')
                    yield catg, content
                    this_file.close()                   

class RegexpReplacer(object):
    def __init__(self, patterns=replacement_patterns):
        self.patterns = [(re.compile(regex), repl) for (regex, repl) in patterns]
    def replace(self, text):
        s = text
        for (pattern, repl) in self.patterns:
            (s, count) = re.subn(pattern, repl, s)
        return s
    
class RepeatReplacer(object):
    def __init__(self):
        self.repeat_regexp = re.compile(r'(\w*)(\w)\2(\w*)')
        self.repl = r'\1\2\3'
    def replace(self, word):
        if wordnet.synsets(word):
            return word
        repl_word = self.repeat_regexp.sub(self.repl, word)
        if repl_word != word:
            return self.replace(repl_word)
        else:
            return repl_word

def convert_doc_to_wordlist(str_doc):
    sent_list = str_doc.split('\n')
    sent_list = map(rm_char, sent_list)  # 去掉一些字符，例如\u3000
    word_list = [rm_tokens(part) for part in sent_list]  # 分词
    word2list = " ".join(word_list)
    return word2list

def rm_tokens(words):  # 去掉一些停用词和完全包含数字的字符串
    words = words.encode("utf-8").decode("utf-8")
    words = re.sub("\d","",words)
    Reg = RegexpReplacer()                           #删除缩写
    words_seg = [re.sub(u'\W', "", Reg.replace(i)) for i in nltk.word_tokenize(words)] 
    space_len = words_seg.count(u"")
    for i in list(range(space_len)):
        words_seg.remove(u'')
    filtered = [w.lower() for w in words_seg if w not in stopwords.words('english')] 
    wnl = WordNetLemmatizer()
    stemmer = PorterStemmer()
    #Rep = RepeatReplacer()
    lemmatized = [wnl.lemmatize(w) for w in filtered] #词形还原
    stems = [stemmer.stem(w) for w in lemmatized]     #词干提取
    #final = [Rep.replace(w) for w in stems]          #删除重复字符
    return " ".join(stems)

def rm_char(text):
    text = re.sub('\u3000', '', text)    #全角的空白符
    return text

def get_word_tf_mat(sparce_mat):
    arr = sparce_mat.toarray().T
    word_tf = pd.DataFrame(arr,index = vectorizer.get_feature_names())
    word_tf["tf"] = np.sum(arr,axis=1)
    word_tf = word_tf.sort_values(by="tf",ascending=False)
    return word_tf.T

if __name__ == '__main__':

    files = loadFiles(path_doc_root)
    football = pd.read_excel('D:/bigdatahw/Case contest/data/football.xls')
    words=[]
    for i, msg in enumerate(files):
        file = msg[1]
        word_list = convert_doc_to_wordlist(file)    
        words.append(word_list)
    news=pd.DataFrame({'title':football["title"].tolist(),'words':words})

    content = [t for t in news["words"]]
    vectorizer=CountVectorizer(stop_words='english',min_df=10)
    count_word = vectorizer.fit_transform(content)
    count_word.shape
    word_tf = get_word_tf_mat(count_word)
    word_tf.to_csv("word_tf.csv")     
  
    data = pd.read_csv("word_tf.csv")     
    l = football["title"].tolist()
    data["Unnamed: 0"] = l.append("tf")
    data.rename(columns={'Unnamed: 0':'title'}, inplace = True)
    data.ix[:,:20].head(10)
    print (data.ix[635,:20]) 
    
    tf = {data.columns[i]: int(data.ix[635,i+1]) for i in list(range(len(data)))} #词频统计词典
    coloring = np.array(Image.open("D:/bigdatahw/Case contest/data/tingge1.png")) #图片

    my_wordcloud = WordCloud(background_color="white", max_words=2000,
                         mask=coloring, max_font_size=60, random_state=42, scale=2,
                         font_path=os.environ.get("FONT_PATH", "C:/Windows/Fonts/simfang.ttf"))
    my_wordcloud.fit_words(tf)
    image_colors = ImageColorGenerator(coloring)
    plt.figure() 
    plt.xticks([]),plt.yticks([]) #隐藏坐标线 
    plt.axis("off")
    plt.imshow(my_wordcloud)
    plt.show()
    







                
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    