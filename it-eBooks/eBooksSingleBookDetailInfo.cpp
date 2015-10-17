//
//  eBooksSingleBookDetailInfo.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/7.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksSingleBookDetailInfo.hpp"

std::string eBooksSingleBookDetailInfo::getBookTitle(void)
{
    return this->m_bookTitle;
}

void eBooksSingleBookDetailInfo::setBookTitle(std::string bookTitle)
{
    this->m_bookTitle = bookTitle;
    return ;
}

void eBooksSingleBookDetailInfo::setBookTitle(const char* bookTitle)
{
    return this->setBookTitle(std::string(bookTitle));
}

std::string eBooksSingleBookDetailInfo::getBookAuthor(void)
{
    return this->m_bookAuthor;
}

void eBooksSingleBookDetailInfo::setBookAuthor(std::string bookAuthor)
{
    this->m_bookAuthor = bookAuthor;
    return ;
}

void eBooksSingleBookDetailInfo::setBookAuthor(const char* bookAuthor)
{
    return this->setBookAuthor(std::string(bookAuthor));
}

std::string eBooksSingleBookDetailInfo::getBookCategoryName(void)
{
    return this->m_bookCategoryName;
}

void eBooksSingleBookDetailInfo::setBookCategoryName(std::string bookCategoryName)
{
    this->m_bookCategoryName = bookCategoryName;
    return ;
}

void eBooksSingleBookDetailInfo::setBookCategoryName(const char* bookCategoryName)
{
    return this->setBookCategoryName(std::string(bookCategoryName));
}

std::string eBooksSingleBookDetailInfo::getBookDescription(void)
{
    return this->m_bookDescription;
}

void eBooksSingleBookDetailInfo::setBookDescription(std::string bookDescription)
{
    this->m_bookDescription = bookDescription;
    return ;
}

void eBooksSingleBookDetailInfo::setBookDescription(const char* bookDescription)
{
    return this->setBookDescription(std::string(bookDescription));
}

std::string eBooksSingleBookDetailInfo::getBookPublisher(void)
{
    return this->m_bookPublisher;
}

void eBooksSingleBookDetailInfo::setBookPublisher(std::string bookPublisher)
{
    this->m_bookPublisher= bookPublisher;
    return ;
}

void eBooksSingleBookDetailInfo::setBookPublisher(const char* bookPublisher)
{
    return this->setBookPublisher(std::string(bookPublisher));
}

std::string eBooksSingleBookDetailInfo::getBookThumbImageUrl(void)
{
    return this->m_bookThumbImageUrl;
}

void eBooksSingleBookDetailInfo::setBookThumbImageUrl(std::string bookThumbImageUrl)
{
    this->m_bookThumbImageUrl= bookThumbImageUrl;
    return ;
}

void eBooksSingleBookDetailInfo::setBookThumbImageUrl(const char* bookThumbImageUrl)
{
    return this->setBookThumbImageUrl(std::string(bookThumbImageUrl));
}

std::string eBooksSingleBookDetailInfo::getBookDownloadUrl(void)
{
    return this->m_bookDownloadUrl;
}

void eBooksSingleBookDetailInfo::setBookDownloadUrl(std::string bookDownloadUrl)
{
    this->m_bookDownloadUrl= bookDownloadUrl;
    return ;
}

void eBooksSingleBookDetailInfo::setBookDownloadUrl(const char* bookDownloadUrl)
{
    return this->setBookDownloadUrl(std::string(bookDownloadUrl));
}

unsigned long eBooksSingleBookDetailInfo::getBookFileSize(void)
{
    return this->m_bookFileSize;
}

void eBooksSingleBookDetailInfo::setBookFileSize(unsigned long bookFileSize)
{
    this->m_bookFileSize= bookFileSize;
    return ;
}

unsigned int eBooksSingleBookDetailInfo::getBookPages(void)
{
    return this->m_bookPages;
}

void eBooksSingleBookDetailInfo::setBookPages(unsigned int bookPages)
{
    this->m_bookPages = bookPages;
    return ;
}

std::string eBooksSingleBookDetailInfo::getBookPublishDate(void)
{
    return this->m_bookPublishDate;
}

void eBooksSingleBookDetailInfo::setBookPublishDate(std::string publishDate)
{
    this->m_bookPublishDate = publishDate;
    return ;
}

void eBooksSingleBookDetailInfo::setBookPublishDate(const char * publishDate)
{
    return this->setBookPublishDate(std::string(publishDate));
}

