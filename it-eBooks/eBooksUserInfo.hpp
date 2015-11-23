//
//  eBooksUserInfo.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/11.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksUserInfo_hpp
#define eBooksUserInfo_hpp

#include <string>
#include <list>

class eBooksUserInfo {
public:
    std::string getUserName(void);
    void setUserName(std::string);
    void setUserName(const char*);
    
    std::string getNickName(void);
    void setNickName(std::string);
    void setNickName(const char*);
    
    bool getUserGender(void);               //true 男       false    女
    void setUserGender(bool);
    
    std::string getConstellation(void);
    void setConstellation(std::string);
    void setConstellation(const char*);
    
    std::string getUserBirthday(void);
    void setUserBirthday(std::string);
    void setUserBirthday(const char*);
    
    std::string getProfesstion(void);
    void setProfesstion(std::string);
    void setProfesstion(const char*);
    
    std::string getUserMail(void);
    void setUserMail(std::string);
    void setUserMail(const char*);
    
    std::string getUserPhone(void);
    void setUserPhone(std::string);
    void setUserPhone(const char*);
    
    std::string getUserMessage(void);
    void setUserMessage(std::string);
    void setUserMessage(const char*);
    
    std::string getUserDescription(void);
    void setUserDescription(std::string);
    void setUserDescription(const char*);
    
    std::string getUserHeaderImage(void);
    void setUserHeaderImage(std::string);
    void setUserHeaderImage(const char*);
    
    int getUserAge(void);
    void setUserAge(int);
    
    int getUserID(void);
    void setUserID(int);
    
    static eBooksUserInfo* sharedInstance(void);
    
    bool isUserLogin(void);
    void changeLoginState(bool);
    
    void userLogoff(void);
    
private:
    std::string m_sUserName;              //用户名
    std::string m_sNickName;                //外号
    bool m_bGender;                        //性别
    std::string m_sConstellation;         //星座
    int m_nUserAge;                        //年龄
    int m_nUserID;                          //用户ID
    std::string m_sBirthday;               //生日
    std::string m_sProfesstion;             //职业
    std::string m_sMail;                //邮箱
    std::string m_sCellPhone;           //手机
    std::string m_sUserMessage;         //签名
    std::string m_sDescription;         //个人描述
    std::string m_sUserHeaderImage;     //用户头像
    
    bool m_bIsLogin;
    static eBooksUserInfo* instance;
    
private:
    eBooksUserInfo();
    eBooksUserInfo(eBooksUserInfo&);
};

#endif /* eBooksUserInfo_hpp */
