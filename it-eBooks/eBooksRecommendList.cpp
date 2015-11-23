//
//  eBooksRecommendList.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksRecommendList.hpp"

eBooksSingleBookDetailInfo& eBooksRecommendList::getItemAtIndex(int index)
{
    return this->m_RecommendList[index];
}

void eBooksRecommendList::addItem(eBooksSingleBookDetailInfo item)
{
    this->m_RecommendList.push_back(item);
    return ;
}

int eBooksRecommendList::getListSize(void)
{
    return (int)this->m_RecommendList.size();
}

void eBooksRecommendList::clearAllItems(void)
{
    return this->m_RecommendList.clear();
}