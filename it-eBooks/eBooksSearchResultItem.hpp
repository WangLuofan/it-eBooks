//
//  eBooksSearchResultItem.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksSearchResultItem_hpp
#define eBooksSearchResultItem_hpp

#include <string>

class eBooksSearchResultItem
{
public:
    eBooksSearchResultItem(int,std::string,std::string,std::string);
    eBooksSearchResultItem();
    eBooksSearchResultItem(int,const char*,const char*,const char*);
    
    int getID(void);
    std::string getName(void);
    std::string getDescription(void);
    std::string getThumbImageUrl(void);
    
    void setID(int);
    
    void setName(std::string);
    void setName(const char*);
    
    void setDescription(std::string);
    void setDescription(const char*);
    
    void setThumbImageUrl(std::string);
    void setThumbImageUrl(const char*);
    
private:
    int m_bookID;
    std::string m_bookDescription;
    std::string m_bookName;
    std::string m_bookThumbImageUrl;
};

#endif /* eBooksSearchResultItem_hpp */
