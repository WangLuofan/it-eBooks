//
//  eBooksCategoryList.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/10/5.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksCategoryList_hpp
#define eBooksCategoryList_hpp

#include <vector>
#include <string>

class eBooksCategoryList
{
public:
    std::string itemAtIndex(int);
    void addNewItem(std::string);
    void addNewItem(const char*);
    void removeItemAtIndex(int);
    void clearAllItems(void);
    size_t getItemCount(void);

    //辅助方法
    void printItemList(void) const;
private:
    std::vector<std::string> m_CategoryVect;
};

#endif /* eBooksCategoryList_hpp */
