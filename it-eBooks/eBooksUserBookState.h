//
//  eBooksUserBookStateModel.h
//  it-eBooks
//
//  Created by 王落凡 on 15/11/14.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#ifndef eBooksUserBookStateModel_h
#define eBooksUserBookStateModel_h

class eBooksUserBookState {
public:
    static const int STATE_NONE = 0;                    //无状态
    static const int STATE_FAVORITED = 1;               //收藏状态
    static const int STATE_DOWNLOADING = 2;             //下载中状态
    static const int STATE_DOWNLOADPAUSE = 4;           //暂停下载
    static const int STATE_DOWNLOADED = 8;              //下载完成
};

#endif /* eBooksUserBookStateModel_h */
