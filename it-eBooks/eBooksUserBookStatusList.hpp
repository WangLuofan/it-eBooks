//
//  eBooksUserBookStatusList.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksUserBookStatusList_hpp
#define eBooksUserBookStatusList_hpp

#include "eBooksUserBookStatusList.hpp"
#include "eBooksUserBookStatus.hpp"
#include <vector>

class eBooksUserBookStatusList
{
public:
    static eBooksUserBookStatusList* getInstance(void);
    eBooksUserBookStatus getItemAtIndex(int);
    eBooksUserBookStatus getItemByID(int);
    bool existItem(int);
    void addItem(eBooksUserBookStatus&);
    void removeItem(int);
    void clearAll(void);
    size_t getSize(void);
private:
    eBooksUserBookStatusList();
    std::vector<eBooksUserBookStatus> m_StatusList;
};

#endif /* eBooksUserBookStatusList_hpp */
