//
//  eBooksCategoryList.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksCategoryList.hpp"
#include <iostream>

size_t eBooksCategoryList::getItemCount(void)
{
    return this->m_CategoryVect.size();
}

void eBooksCategoryList::clearAllItems(void)
{
    this->m_CategoryVect.clear();
    return ;
}

void eBooksCategoryList::addNewItem(std::string itemName)
{
    this->m_CategoryVect.push_back(itemName);
    return ;
}

void eBooksCategoryList::addNewItem(const char * itemName)
{
    std::string str(itemName);
    this->addNewItem(str);
    
    return ;
}

std::string eBooksCategoryList::itemAtIndex(int index)
{
    return this->m_CategoryVect.at(index);
}

void eBooksCategoryList::removeItemAtIndex(int index)
{
    auto iter = this->m_CategoryVect.begin();
    int tmpIndex = 0;
    
    for(;iter != this->m_CategoryVect.end() && tmpIndex != index ; ++tmpIndex,++iter);
    if(iter != this->m_CategoryVect.end())
        this->m_CategoryVect.erase(iter);
    return ;
}

void eBooksCategoryList::printItemList(void) const
{
    for(auto item : this->m_CategoryVect)
        std::cout<<item<<std::endl;
    
    return ;
}