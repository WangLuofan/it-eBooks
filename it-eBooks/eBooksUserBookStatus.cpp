//
//  eBooksUserBookStatus.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksUserBookStatus.hpp"

eBooksUserBookStatus::eBooksUserBookStatus()
    :m_singleBookStatus(eBooksUserBookState::STATE_NONE)
{}

eBooksUserBookStatus::eBooksUserBookStatus(int id,std::string title)
    :m_bookID(id),m_bookTitle(title),m_singleBookStatus(eBooksUserBookState::STATE_NONE) {}

eBooksUserBookStatus::eBooksUserBookStatus(int id,const char* title)
    :m_bookID(id),m_bookTitle(std::string(title)),m_singleBookStatus(eBooksUserBookState::STATE_NONE) {}

bool eBooksUserBookStatus::isExistsStatus(int status)
{
    if((status & this->m_singleBookStatus) == 0)
        return false;
    return true;
}

void eBooksUserBookStatus::addSingleBookStatus(int status)
{
    this->m_singleBookStatus |= status;
    return ;
}

int eBooksUserBookStatus::getSingleBookStatus(void)
{
    return this->m_singleBookStatus;
}

int eBooksUserBookStatus::getBookID(void)
{
    return this->m_bookID;
}

void eBooksUserBookStatus::setBookID(int id)
{
    this->m_bookID = id;
    return ;
}

std::string eBooksUserBookStatus::getBookTitle(void)
{
    return this->m_bookTitle;
}

void eBooksUserBookStatus::setBookTitle(std::string title)
{
    this->m_bookTitle = title;
    return ;
}

double eBooksUserBookStatus::getDownloadPersent(void)
{
    return this->m_downloadPersent;
}

void eBooksUserBookStatus::setDownloadPersent(double value)
{
    this->m_downloadPersent = value;
}