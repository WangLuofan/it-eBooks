//
//  eBooksSearchResultItem.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksSearchResultItem.hpp"

eBooksSearchResultItem::eBooksSearchResultItem()
    :m_bookID(-1),m_bookName(""),m_bookThumbImageUrl(""),m_bookDescription("")
{
}

eBooksSearchResultItem::eBooksSearchResultItem(int bookID,std::string bookName,std::string bookThumb,std::string bookDesc)
    :m_bookID(bookID),m_bookName(bookName),m_bookThumbImageUrl(bookThumb),m_bookDescription(bookDesc)
{
}

eBooksSearchResultItem::eBooksSearchResultItem(int bookID,const char* bookName,const char* bookThumb,const char* bookDesc)
    :m_bookID(bookID),m_bookName(bookName),m_bookThumbImageUrl(bookThumb),m_bookDescription(bookDesc)
{
}

int eBooksSearchResultItem::getID(void)
{
    return this->m_bookID;
}

std::string eBooksSearchResultItem::getName(void)
{
    return this->m_bookName;
}

std::string eBooksSearchResultItem::getThumbImageUrl(void)
{
    return this->m_bookThumbImageUrl;
}

void eBooksSearchResultItem::setID(int bookID)
{
    this->m_bookID = bookID;
    return ;
}

std::string eBooksSearchResultItem::getDescription(void)
{
    return this->m_bookDescription;
}

void eBooksSearchResultItem::setDescription(std::string bookDesc)
{
    this->m_bookDescription = bookDesc;
    return ;
}

void eBooksSearchResultItem::setDescription(const char * bookDesc)
{
    return this->setDescription(std::string(bookDesc));
}

void eBooksSearchResultItem::setName(std::string bookName)
{
    this->m_bookName = bookName;
    return ;
}

void eBooksSearchResultItem::setName(const char * bookName)
{
    this->setName(std::string(bookName));
    return ;
}

void eBooksSearchResultItem::setThumbImageUrl(std::string bookThumb)
{
    this->m_bookThumbImageUrl = bookThumb;
    return ;
}

void eBooksSearchResultItem::setThumbImageUrl(const char * bookThumb)
{
    this->setThumbImageUrl(std::string(bookThumb));
    return ;
}