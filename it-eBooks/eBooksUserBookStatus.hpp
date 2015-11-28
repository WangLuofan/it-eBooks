//
//  eBooksUserBookStatus.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksUserBookStatus_hpp
#define eBooksUserBookStatus_hpp

#include "eBooksUserBookState.h"
#include <list>
#include <string>

class eBooksUserBookStatus {
public:
    eBooksUserBookStatus();
    eBooksUserBookStatus(int,std::string);
    eBooksUserBookStatus(int,const char*);
    
    bool isExistsStatus(int);
    void addSingleBookStatus(int);
    void removeSingleBookStatus(int);
    int getSingleBookStatus(void);
    int getBookID(void);
    void setBookID(int);
    std::string getBookTitle(void);
    void setBookTitle(std::string);
    void setDownloadPersent(double);
    double getDownloadPersent(void);
private:
    int m_bookID;
    double m_downloadPersent;
    int m_singleBookStatus;
    std::string m_bookTitle;
};

#endif /* eBooksUserBookStatus_hpp */
