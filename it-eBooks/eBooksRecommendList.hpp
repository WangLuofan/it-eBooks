//
//  eBooksRecommendList.hpp
//  it-eBooks
//
//  Created by 王落凡 on 15/11/8.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksRecommendList_hpp
#define eBooksRecommendList_hpp

#include <vector>
#include "eBooksSingleBookDetailInfo.hpp"

class eBooksRecommendList {
public:
    eBooksSingleBookDetailInfo& getItemAtIndex(int);
    int getListSize(void);
    void clearAllItems(void);
    void addItem(eBooksSingleBookDetailInfo);
private:
    std::vector<eBooksSingleBookDetailInfo> m_RecommendList;
};

#endif /* eBooksRecommendList_hpp */
