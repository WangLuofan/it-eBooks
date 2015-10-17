//
//  eBooksUserInfo.cpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#include "eBooksUserInfo.hpp"

eBooksUserInfo* eBooksUserInfo::instance = nullptr;

eBooksUserInfo* eBooksUserInfo::sharedInstance(void)
{
    if(instance == nullptr)
        instance = new eBooksUserInfo();
    return instance;
}

std::string eBooksUserInfo::getNickName(void)
{
    return this->m_sNickName;
}

void eBooksUserInfo::setNickName(std::string nickname)
{
    this->m_sNickName = nickname;
    return ;
}

void eBooksUserInfo::setNickName(const char* nickname)
{
    return this->setNickName(std::string(nickname));
}

eBooksUserInfo::eBooksUserInfo(eBooksUserInfo&){}

eBooksUserInfo::eBooksUserInfo() : m_bIsLogin(false)
{
}

std::string eBooksUserInfo::getConstellation(void) {
    return m_sConstellation;
}

void eBooksUserInfo::setConstellation(std::string constellation)
{
    this->m_sConstellation = constellation;
    return ;
}

void eBooksUserInfo::setConstellation(const char * constellation)
{
    return this->setConstellation(std::string(constellation));
}

std::string eBooksUserInfo::getUserName(void)
{
    return this->m_sUserName;
}

void eBooksUserInfo::setUserName(std::string username)
{
    this->m_sUserName = username;
    return ;
}

void eBooksUserInfo::setUserName(const char* username)
{
    return this->setUserName(std::string(username));
}

std::string eBooksUserInfo::getUserMessage(void)
{
    return this->m_sUserMessage;
}

void eBooksUserInfo::setUserMessage(std::string message)
{
    this->m_sUserMessage = message;
    return ;
}

void eBooksUserInfo::setUserMessage(const char* message)
{
    return this->setUserMessage(std::string(message));
}

std::string eBooksUserInfo::getUserBirthday(void)
{
    return this->m_sBirthday;
}

void eBooksUserInfo::setUserBirthday(std::string birthday)
{
    this->m_sBirthday = birthday;
    return ;
}

void eBooksUserInfo::setUserBirthday(const char* birthday)
{
    return this->setUserBirthday(std::string(birthday));
}

std::string eBooksUserInfo::getUserMail(void)
{
    return this->m_sMail;
}

void eBooksUserInfo::setUserMail(std::string mail)
{
    this->m_sMail = mail;
    return ;
}

void eBooksUserInfo::setUserMail(const char* mail)
{
    return this->setUserMail(std::string(mail));
}

std::string eBooksUserInfo::getUserPhone(void)
{
    return this->m_sCellPhone;
}

void eBooksUserInfo::setUserPhone(std::string phone)
{
    this->m_sCellPhone = phone;
    return ;
}

void eBooksUserInfo::setUserPhone(const char* phone)
{
    return this->setUserPhone(std::string(phone));
}

std::string eBooksUserInfo::getUserDescription(void)
{
    return this->m_sDescription;
}

void eBooksUserInfo::setUserDescription(std::string description)
{
    this->m_sDescription = description;
    return ;
}

void eBooksUserInfo::setUserDescription(const char* description)
{
    return this->setUserDescription(std::string(description));
}

std::string eBooksUserInfo::getProfesstion(void)
{
    return this->m_sProfesstion;
}

void eBooksUserInfo::setProfesstion(std::string profession)
{
    this->m_sProfesstion = profession;
    return ;
}

void eBooksUserInfo::setProfesstion(const char* profession)
{
    return this->setProfesstion(std::string(profession));
}

bool eBooksUserInfo::getUserGender(void)
{
    return this->m_bGender;
}

void eBooksUserInfo::setUserGender(bool gender)
{
    this->m_bGender = gender;
    return ;
}

int eBooksUserInfo::getUserAge(void)
{
    return this->m_nUserAge;
}

void eBooksUserInfo::setUserAge(int age)
{
    this->m_nUserAge = age;
    return ;
}

bool eBooksUserInfo::isUserLogin(void)
{
    return this->m_bIsLogin;
}

void eBooksUserInfo::changeLoginState(bool login)
{
    this->m_bIsLogin = login;
    return ;
}