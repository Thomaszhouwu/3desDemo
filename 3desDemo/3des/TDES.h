//
//  TDES.h
//  mPOS
//
//  Created by 德益富 on 15/5/15.
//  Copyright (c) 2015年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDES : NSObject

void decrpt3DES(char *outbuf,char *data,char *myklk);
void encrpt3DES(char *outbuf,char *data,char *myklk);

void decrptDES(char *outbuf,char *data,char *myklk);
void encrptDES(char *outbuf,char *data,char *myklk);

void encrptDES(char *outbuf,char *data,char *myklk);
int IntToBcd11(int aa, char xx[2]);
void Hex2Str(char *sSrc,  char *sDest, int nSrcLen);
void Str2Hex(char *sSrc, char *sDest, int nSrcLen);

@end
