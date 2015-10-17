//
//  eBooksSingleBookDetailInfo.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/7.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksSingleBookDetailInfo_hpp
#define eBooksSingleBookDetailInfo_hpp

#include <string>

class eBooksSingleBookDetailInfo
{
public:
    
    std::string getBookTitle(void);
    void setBookTitle(std::string);
    void setBookTitle(const char*);
    
    std::string getBookAuthor(void);
    void setBookAuthor(std::string);
    void setBookAuthor(const char*);
    
    unsigned int getBookPages(void);
    void setBookPages(unsigned int);
    
    std::string getBookPublisher(void);
    void setBookPublisher(std::string);
    void setBookPublisher(const char*);
    
    std::string getBookPublishDate(void);
    void setBookPublishDate(std::string);
    void setBookPublishDate(const char*);
    
    std::string getBookCategoryName(void);
    void setBookCategoryName(std::string);
    void setBookCategoryName(const char*);
    
    unsigned long getBookFileSize(void);
    void setBookFileSize(unsigned long);
    
    std::string getBookDescription(void);
    void setBookDescription(std::string);
    void setBookDescription(const char*);
    
    std::string getBookThumbImageUrl(void);
    void setBookThumbImageUrl(std::string);
    void setBookThumbImageUrl(const char*);
    
    std::string getBookDownloadUrl(void);
    void setBookDownloadUrl(std::string);
    void setBookDownloadUrl(const char*);
    
private:
    std::string m_bookTitle;                //书名
    std::string m_bookAuthor;               //作者
    unsigned int m_bookPages;               //书页
    std::string m_bookPublisher;            //出版社
    std::string m_bookPublishDate;          //出版时间
    std::string m_bookCategoryName;         //书籍所属分类
    unsigned long m_bookFileSize;           //文件大小(KB)
    std::string m_bookDescription;          //书籍描述
    std::string m_bookThumbImageUrl;        //书籍缩图地址
    std::string m_bookDownloadUrl;          //书籍下载地址
};

#endif /* eBooksSingleBookDetailInfo_hpp */
