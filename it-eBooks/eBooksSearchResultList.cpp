//
//  eBooksSearchResultList.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksSearchResultList.hpp"

size_t eBooksSearchResultList::getItemCount(void)
{
    return this->m_SearchResultItemList.size();
}

void eBooksSearchResultList::clearALLItems(void)
{
    this->m_SearchResultItemList.clear();
    return ;
}

void eBooksSearchResultList::addNewItem(eBooksSearchResultItem item)
{
    this->m_SearchResultItemList.push_back(item);
    return ;
}

void eBooksSearchResultList::addNewItem(int bookID, std::string bookName, std::string bookThumb,std::string bookDesc)
{
    this->addNewItem(eBooksSearchResultItem(bookID, bookName, bookThumb, bookDesc));
    return ;
}

void eBooksSearchResultList::addNewItem(int bookID, const char * bookName, const char * bookThumb, const char* bookDesc)
{
    this->addNewItem(eBooksSearchResultItem(bookID, bookName, bookThumb, bookDesc));
    return ;
}

eBooksSearchResultItem* eBooksSearchResultList::itemAtIndex(int index)
{
    int tmpIndex = 0;
    auto iter = this->m_SearchResultItemList.begin();
    for(; iter != this->m_SearchResultItemList.end() && index != tmpIndex; ++ iter,++tmpIndex);
    if(iter == this->m_SearchResultItemList.end())
        return nullptr;
    
    return &*iter;
}

void eBooksSearchResultList::removeItemAtIndex(int index)
{
    int tmpIndex = 0;
    auto iter = this->m_SearchResultItemList.begin();
    for(; iter != this->m_SearchResultItemList.end() && index != tmpIndex; ++ iter,++tmpIndex);
    this->m_SearchResultItemList.erase(iter);
    
    return ;
}