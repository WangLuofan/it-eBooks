//
//  eBooksSearchResultList.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksSearchResultList_hpp
#define eBooksSearchResultList_hpp

#include <list>
#include "eBooksSearchResultItem.hpp"

class eBooksSearchResultList
{
public:
    void addNewItem(eBooksSearchResultItem);
    void addNewItem(int,const char*,const char*,const char*);
    void addNewItem(int,std::string,std::string,std::string);
    
    eBooksSearchResultItem* itemAtIndex(int);
    
    void removeItemAtIndex(int);
    size_t getItemCount(void);
    
    void clearALLItems(void);
private:
    std::list<eBooksSearchResultItem> m_SearchResultItemList;
};

#endif /* eBooksSearchResultList_hpp */
