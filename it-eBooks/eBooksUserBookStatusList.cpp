//
//  eBooksUserBookStatusList.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksUserBookStatusList.hpp"

static eBooksUserBookStatusList* m_Instance = nullptr;

eBooksUserBookStatusList::eBooksUserBookStatusList(){}

eBooksUserBookStatusList* eBooksUserBookStatusList::getInstance(void)
{
    if(m_Instance == nullptr)
        m_Instance = new eBooksUserBookStatusList();
    return m_Instance;
}

void eBooksUserBookStatusList::addItem(eBooksUserBookStatus & item)
{
    this->m_StatusList.push_back(item);
    return ;
}

void eBooksUserBookStatusList::clearAll(void)
{
    this->m_StatusList.clear();
    return ;
}

bool eBooksUserBookStatusList::existItem(int bookID)
{
    for (int i = 0; i != this->m_StatusList.size(); ++i) {
        eBooksUserBookStatus item = this->m_StatusList[i];
        if(item.getBookID() == bookID)
            return true;
    }
    
    return false;
}

eBooksUserBookStatus eBooksUserBookStatusList::getItemAtIndex(int index)
{
    return this->m_StatusList[index];
}

size_t eBooksUserBookStatusList::getSize(void)
{
    return this->m_StatusList.size();
}

void eBooksUserBookStatusList::removeItem(int bookID)
{
    for(auto iter = this->m_StatusList.begin(); iter != this->m_StatusList.end(); ++iter)
        if(iter->getBookID() == bookID) {
            this->m_StatusList.erase(iter);
            break;
        }
    
    return ;
}

eBooksUserBookStatus eBooksUserBookStatusList::getItemByID(int bookID)
{
    eBooksUserBookStatus status;
    for(auto iter = this->m_StatusList.begin(); iter != this->m_StatusList.end(); ++iter)
        if(iter->getBookID() == bookID) {
            status = *iter;
        }
    return status;
}