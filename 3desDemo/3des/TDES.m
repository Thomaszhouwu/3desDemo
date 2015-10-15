//
//  TDES.m
//  mPOS
//
//  Created by 德益富 on 15/5/15.
//  Copyright (c) 2015年 Dyf. All rights reserved.
//

#import "TDES.h"
#include <stdlib.h>

@implementation TDES

unsigned char CCC[17][28], D[17][28], K[17][48], c, ch;
int ls_count[16] = {1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1};

int e_r[48] =
{
    32, 1 , 2 , 3 , 4 , 5 , 4 , 5 ,
    6 , 7 , 8 , 9 , 8 , 9 , 10, 11,
    12, 13, 12, 13, 14, 15, 16, 17,
    16, 17, 18, 19, 20, 21, 20, 21,
    22, 23, 24, 25, 24, 25, 26, 27,
    28, 29, 28, 29, 30, 31, 32, 1
};

int P[32] =
{
    16, 7, 20, 21, 29, 12, 28, 17,
    1 , 15, 23, 26, 5 , 18, 31, 10,
    2, 8 , 24, 14, 32, 27, 3 , 9 ,
    19, 13, 30, 6 , 22, 11, 4 , 25
};

int SSS[16][4][16] =
{
    14, 4, 13, 1, 2, 15, 11, 8, 3, 10, 6, 12, 5, 9, 0, 7,
    0, 15, 7, 4, 14, 2, 13, 1, 10, 6, 12, 11, 9, 5, 3, 8, /* err on */
    4, 1, 14, 8, 13, 6, 2, 11, 15, 12, 9, 7, 3, 10, 5, 0,
    15, 12, 8, 2, 4, 9, 1, 7, 5, 11, 3, 14, 10, 0, 6, 13,
    
    15, 1, 8, 14, 6, 11, 3, 4, 9, 7, 2, 13, 12, 0, 5, 10,
    3, 13, 4, 7, 15, 2, 8, 14, 12, 0, 1, 10, 6, 9, 11, 5,
    0, 14, 7, 11, 10, 4, 13, 1, 5, 8, 12, 6, 9, 3, 2, 15,
    13, 8, 10, 1, 3, 15, 4, 2, 11, 6, 7, 12, 0, 5, 14, 9,
    
    10, 0, 9, 14, 6, 3, 15, 5, 1, 13, 12, 7, 11, 4, 2, 8,
    13, 7, 0, 9, 3, 4, 6, 10, 2, 8, 5, 14, 12, 11, 15, 1,
    13, 6, 4, 9, 8, 15, 3, 0, 11, 1, 2, 12, 5, 10, 14, 7,
    1, 10, 13, 0, 6, 9, 8, 7, 4, 15, 14, 3, 11, 5, 2, 12,
    
    7, 13, 14, 3, 0, 6, 9, 10, 1, 2, 8, 5, 11, 12, 4, 15,
    13, 8, 11, 5, 6, 15, 0, 3, 4, 7, 2, 12, 1, 10, 14, 9,
    10, 6, 9, 0, 12, 11, 7, 13, 15, 1, 3, 14, 5, 2, 8, 4,
    3, 15, 0, 6, 10, 1, 13, 8, 9, 4, 5, 11, 12, 7, 2, 14, /* err on */
    
    2, 12, 4, 1, 7, 10, 11, 6, 8, 5, 3, 15, 13, 0, 14, 9,
    14, 11, 2, 12, 4, 7, 13, 1, 5, 0, 15, 10, 3, 9, 8, 6, /* err on */
    4, 2, 1, 11, 10, 13, 7, 8, 15, 9, 12, 5, 6, 3, 0, 14,
    11, 8, 12, 7, 1, 14, 2, 13, 6, 15, 0, 9, 10, 4, 5, 3,
    
    12, 1, 10, 15, 9, 2, 6, 8, 0, 13, 3, 4, 14, 7, 5, 11,
    10, 15, 4, 2, 7, 12, 9, 5, 6, 1, 13, 14, 0, 11, 3, 8,
    9, 14, 15, 5, 2, 8, 12, 3, 7, 0, 4, 10, 1, 13, 11, 6,
    4, 3, 2, 12, 9, 5, 15, 10, 11, 14, 1, 7, 6, 0, 8, 13,
    
    4, 11, 2, 14, 15, 0, 8, 13, 3, 12, 9, 7, 5, 10, 6, 1,
    13, 0, 11, 7, 4, 9, 1, 10, 14, 3, 5, 12, 2, 15, 8, 6,
    1, 4, 11, 13, 12, 3, 7, 14, 10, 15, 6, 8, 0, 5, 9, 2,
    6, 11, 13, 8, 1, 4, 10, 7, 9, 5, 0, 15, 14, 2, 3, 12,
    
    13, 2, 8, 4, 6, 15, 11, 1, 10, 9, 3, 14, 5, 0, 12, 7,
    1, 15, 13, 8, 10, 3, 7, 4, 12, 5, 6, 11, 0, 14, 9, 2,
    7, 11, 4, 1, 9, 12, 14, 2, 0, 6, 10, 13, 15, 3, 5, 8,
    2, 1, 14, 7, 4, 10, 8, 13, 15, 12, 9, 0, 3, 5, 6, 11
};

int pc_1_c[28] =
{
    57, 49, 41, 33, 25, 17, 9 ,
    1 , 58, 50, 42, 34, 26, 18,
    10, 2 , 59, 51, 43, 35, 27,
    19, 11, 3 , 60, 52, 44, 36
};

int pc_1_d[28] =
{
    63, 55, 47, 39, 31, 23, 15,
    7 , 62, 54, 46, 38, 30, 22,
    14, 6 , 61, 53, 45, 37, 29,
    21, 13, 5 , 28, 20, 12, 4
};

int pc_2[48] =
{
    14, 17, 11, 24, 1 , 5 , 3 , 28,
    15, 6 , 21, 10, 23, 19, 12, 4 ,
    26, 8 , 16, 7 , 27, 20, 13, 2 ,
    41, 52, 31, 37, 47, 55, 30, 40,
    51, 45, 33, 48, 44, 49, 39, 56,
    34, 53, 46, 42, 50, 36, 29, 32
};

int ip_tab[64] =
{
    58, 50, 42, 34, 26, 18, 10, 2,
    60, 52, 44, 36, 28, 20, 12, 4,
    62, 54, 46, 38, 30, 22, 14, 6,
    64, 56, 48, 40, 32, 24, 16, 8,
    57, 49, 41, 33, 25, 17, 9 , 1,
    59, 51, 43, 35, 27, 19, 11, 3,
    61, 53, 45, 37, 29, 21, 13, 5,
    63, 55, 47, 39, 31, 23, 15, 7
};

int _ip_tab[64] =
{
    40, 8, 48, 16, 56, 24, 64, 32,
    39, 7, 47, 15, 55, 23, 63, 31,
    38, 6, 46, 14, 54, 22, 62, 30,
    37, 5, 45, 13, 53, 21, 61, 29,
    36, 4, 44, 12, 52, 20, 60, 28,
    35, 3, 43, 11, 51, 19, 59, 27,
    34, 2, 42, 10, 50, 18, 58, 26,
    33, 1, 41, 9, 49, 17, 57, 25
};

char hextoasc11(int xxc)
{
    xxc &= 0x0f;
    
    if(xxc < 0x0a)
    {
        xxc += '0';
    }
    else
    {
        xxc += 0x37;
    }
    
    return (char)xxc;
}

char hexlowtoasc11(int xxc)
{
    xxc &= 0x0f;
    
    if(xxc < 0x0a)
    {
        xxc += '0';
    }
    else
    {
        xxc += 0x37;
    }
    
    return (char)xxc;
}

char hexhightoasc11(int xxc)
{
    xxc &= 0xf0;
    xxc = xxc >> 4;
    
    if(xxc < 0x0a)
    {
        xxc += '0';
    }
    else
    {
        xxc += 0x37;
    }
    
    return (char)xxc;
}

char asctohex11(char ch1, char ch2)
{
    char ch;
    
    if(ch1 >= 'A')
    {
        ch = (char)((ch1 - 0x37) << 4);
    }
    else
    {
        ch = (char)((ch1 - '0') << 4);
    }
    
    if(ch2 >= 'A')
    {
        ch |= ch2 - 0x37;
    }
    else
    {
        ch |= ch2 - '0';
    }
    
    return ch;
}

int aschex_to_bcdhex11(char aschex[], int len, char bcdhex[])
{
    int i, j;
    char buf[512];
    memcpy(buf, aschex, len);
    
    if(len % 2 == 0)
    {
        j = len / 2;
    }
    else
    {
        j = len / 2 + 1;
    }
    
    for(i = 0; i < j; i++)
    {
        bcdhex[i] = asctohex11(aschex[2 * i], aschex[2 * i + 1]);
    }
    
    return(j);
}

int bcdhex_to_aschex11(char bcdhex[], int len, char aschex[])
{
    int i;
    
    for(i = 0; i < len; i++)
    {
        aschex[2 * i]   = hexhightoasc11(bcdhex[i]);
        aschex[2 * i + 1] = hexlowtoasc11(bcdhex[i]);
    }
    
    return(len * 2);
}

int byte2int_to_bcd11(int aa, char xx[])
{
    if(aa >= 256 * 256)
    {
        return(-1);
    }
    
    xx[0] = aa / 256;
    xx[1] = aa % 256;
    return(0);
}

int IntToBcd11(int aa, char xx[2])
{
    if(aa > 256 * 256)
    {
        return(-1);
    }
    
    xx[0] = aa / 256;
    xx[1] = aa % 256;
    
    return(0);
}

int BcdToInt11(char xx[])
{
    return(xx[0] * 256 + xx[1]);
}


void Des(unsigned char *key, unsigned char *text, unsigned char *mtext)
{
    unsigned char tmp[64];
    unsigned char keybuf[9];
    unsigned char textbuf[9];
    unsigned char mtextbuf[9];
    memset(keybuf, 0, 9);
    memset(textbuf, 0, 9);
    memset(mtextbuf, 0, 9);
    aschex_to_bcdhex11((char *)key, 16, (char *)keybuf);
    aschex_to_bcdhex11((char *)text, 16, (char *)textbuf);
    expand0(keybuf, tmp);
    setkeystar(tmp);
    encrypt0(textbuf, mtextbuf);
    bcdhex_to_aschex11((char *)mtextbuf, 8, (char *)mtext);
}

void TDes(unsigned char *key, unsigned char *text, unsigned char *mtext)
{
    unsigned char tmp[64], tmp2[64];
    memset(tmp, 0, sizeof(tmp));
    memset(tmp2, 0, sizeof(tmp2));
    Des(key, text, tmp);
    _Des(key + 16, tmp, tmp2);
    Des(key, tmp2, mtext);
}



void   _Des(unsigned char *key, unsigned char *text, unsigned char *mtext)
{
    unsigned char tmp[64];
    unsigned char keybuf[9];
    unsigned char textbuf[9];
    unsigned char mtextbuf[9];
    memset(keybuf, 0, 9);
    memset(textbuf, 0, 9);
    memset(mtextbuf, 0, 9);
    aschex_to_bcdhex11((char *)key, 16, (char *)keybuf);
    aschex_to_bcdhex11((char *)text, 16, (char *)textbuf);
    expand0(keybuf, tmp);
    setkeystar(tmp);
    discrypt0(textbuf, mtextbuf);
    bcdhex_to_aschex11((char *)mtextbuf, 8, (char *)mtext);
}

void _TDes(unsigned char *key, unsigned char *text, unsigned char *mtext)
{
    unsigned char tmp[64], tmp2[64];
    memset(tmp, 0, sizeof(tmp));
    memset(tmp2, 0, sizeof(tmp2));
    _Des(key, text, tmp);
    Des(key + 16, tmp, tmp2);
    _Des(key, tmp2, mtext);
}


void   encrypt0(unsigned char *text, unsigned char *mtext)
{
    unsigned char ll[64], rr[64], LL[64], RR[64];
    unsigned char tmp[64];
    int i, j;
    ip(text, ll, rr);
    
    for(i = 1; i < 17; i++)
    {
        F(i, ll, rr, LL, RR);
        
        for(j = 0; j < 32; j++)
        {
            ll[j] = LL[j];
            rr[j] = RR[j];
        }
    }
    
    _ip(tmp, rr, ll);
    compress0(tmp, mtext);
}


void   discrypt0(unsigned char *mtext, unsigned char *text)
{
    unsigned char ll[64], rr[64], LL[64], RR[64];
    unsigned char tmp[64];
    int i, j;
    ip(mtext, ll, rr);
    
    for(i = 16; i > 0; i--)
    {
        F(i, ll, rr, LL, RR);
        
        for(j = 0; j < 32; j++)
        {
            ll[j] = LL[j];
            rr[j] = RR[j];
        }
    }
    
    _ip(tmp, rr, ll);
    compress0(tmp, text);
}


void expand0(unsigned char *in, unsigned char *out)
{
    int divide;
    int i, j;
    
    for(i = 0; i < 8; i++)
    {
        divide = 0x80;
        
        for(j = 0; j < 8; j++)
        {
            *out++ = (in[i] / divide) & 1;
            divide /= 2;
        }
    }
}


void compress0(unsigned char *out, unsigned char *in)
{
    int times;
    int i, j;
    
    for(i = 0; i < 8; i++)
    {
        times = 0x80;
        in[i] = 0;
        
        for(j = 0; j < 8; j++)
        {
            in[i] += (*out++) * times;
            times /= 2;
        }
    }
}

void compress016(unsigned char *out, unsigned char *in)
{
    int times;
    int i, j;
    
    for(i = 0; i < 16; i++)
    {
        times = 0x8;
        in[i] = '0';
        
        for(j = 0; j < 4; j++)
        {
            in[i] += (*out++) * times;
            times /= 2;
        }
    }
}

void setkeystar(unsigned char *bits)
{
    int i, j;
    
    for(i = 0; i < 28; i++)
    {
        CCC[0][i] = bits[pc_1_c[i] - 1];
    }
    
    for(i = 0; i < 28; i++)
    {
        D[0][i] = bits[pc_1_d[i] - 1];
    }
    
    for(j = 0; j < 16; j++)
    {
        LS(CCC[j], CCC[j + 1], ls_count[j]);
        LS(D[j], D[j + 1], ls_count[j]);
        son(CCC[j + 1], D[j + 1], K[j + 1]);
    }
}


void LS(unsigned char *bits, unsigned char *buffer, int count)
{
    int i;
    
    for(i = 0; i < 28; i++)
    {
        buffer[i] = bits[(i + count) % 28];
    }
}

void son(unsigned char *cc, unsigned char *dd, unsigned char *kk)
{
    int i;
    char buffer[56];
    
    for(i = 0; i < 28; i++)
    {
        buffer[i] = *cc++;
    }
    
    for(i = 28; i < 56; i++)
    {
        buffer[i] = *dd++;
    }
    
    for(i = 0; i < 48; i++)
    {
        *kk++ = buffer[pc_2[i] - 1];
    }
}


void ip(unsigned char *text, unsigned char *ll, unsigned char *rr)
{
    int i;
    unsigned char buffer[64];
    expand0(text, buffer);
    
    for(i = 0; i < 32; i++)
    {
        ll[i] = buffer[ip_tab[i] - 1];
    }
    
    for(i = 0; i < 32; i++)
    {
        rr[i] = buffer[ip_tab[i + 32] - 1];
    }
}

void _ip(unsigned char *text, unsigned char *ll, unsigned char *rr)
{
    int i;
    char tmp[64];
    
    for(i = 0; i < 32; i++)
    {
        tmp[i] = ll[i];
    }
    
    for(i = 32; i < 64; i++)
    {
        tmp[i] = rr[i - 32];
    }
    
    for(i = 0; i < 64; i++)
    {
        text[i] = tmp[_ip_tab[i] - 1];
    }
}



void F(int n, unsigned char *ll, unsigned char *rr, unsigned char *LL, unsigned char *RR)
{
    int i;
    unsigned char buffer[64], tmp[64];
    
    for(i = 0; i < 48; i++)
    {
        buffer[i] = rr[e_r[i] - 1];
    }
    
    for(i = 0; i < 48; i++)
    {
        buffer[i] = (buffer[i] + K[n][i]) & 1;
    }
    
    s_box(buffer, tmp);
    
    for(i = 0; i < 32; i++)
    {
        buffer[i] = tmp[P[i] - 1];
    }
    
    for(i = 0; i < 32; i++)
    {
        RR[i] = (buffer[i] + ll[i]) & 1;
    }
    
    for(i = 0; i < 32; i++)
    {
        LL[i] = rr[i];
    }
}

void s_box(unsigned char *aa, unsigned char *bb)
{
    int i, j, k, m;
    int y, z;
    unsigned char ss[8];
    m = 0;
    
    for(i = 0; i < 8; i++)
    {
        j = 6 * i;
        y = aa[j] * 2 + aa[j + 5];
        z = aa[j + 1] * 8 + aa[j + 2] * 4 + aa[j + 3] * 2 + aa[j + 4];
        ss[i] = SSS[i][y][z];
        y = 0x08;
        
        for(k = 0; k < 4; k++)
        {
            bb[m++] = (ss[i] / y) & 1;
            y /= 2;
        }
    }
}
void  xor11(char *a,  char *b,  char *out, int bytes)
{
    char abuf[9];
    char bbuf[9];
    char outbuf[9];
    char *aa, *bb, *outout;
    memset(abuf, 0, 9);
    memset(bbuf, 0, 9);
    memset(outbuf, 0, 9);
    aschex_to_bcdhex11(a, 16, abuf);
    aschex_to_bcdhex11(b, 16, bbuf);
    aa = abuf;
    bb = bbuf;
    outout = outbuf;
    
    while(bytes--)
    {
        *outout++ = (*aa++) ^ (*bb++);
    }
    
    bcdhex_to_aschex11(outbuf, 8, out);
}


#define  KEY "3131313131313131"

/*int  main(int argc, char *argv[])
 {
 unsigned char r[17];
 unsigned char r1[17];
 unsigned char r2[17];
 
 unsigned char src[256];
 unsigned char sHex[512];
 unsigned char sDest[512];
 int i;
 int nSrcLen;
 int nHexLen;
 
 memset(r,0,17);
 memset(r2,0,17);
 memset(src, 0, sizeof(src));
 memset(sHex, 0, sizeof(sHex));
 memset(sDest, 0, sizeof(sDest));
 
 if (argc < 3)
 {
 printf("Usage:%s  src 0|1\n", argv[0]);
 return 1;
 }
 
 strcpy(src, argv[1]);
 nSrcLen = strlen(src);
 printf("nSrcLen=%d  src[%s]\n", nSrcLen, src);
 
 if ( argv[2][0] == '0')
 {
 for(i=0; i< nSrcLen; i++)
 sprintf(sHex+2*i, "%02x", src[i]);
 
 nHexLen = 2*nSrcLen;
 printf("nHexLen=%d  sHex[%s]\n", nHexLen, sHex);
 }else if ( argv[2][0] == '1')
 {
 nHexLen = nSrcLen;
 memcpy(sHex, src, nHexLen);
 }
 
 printf("Des KEY ==%s== \n", KEY);
 for(i=0; i<nHexLen; i+=16)
 {
 printf("---------i=%d----------\n", i);
 memset(r, 0, sizeof(r));
 memset(r1, 0, sizeof(r1));
 
 if ( (nHexLen-i) < 16 )
 {
 memset(r, '0', 16);
 memcpy(r, sHex+i, nHexLen-i);
 }else
 memcpy(r, sHex+i, 16);
 printf("Des ==%s== \n",r);
 
 if (argv[2][0] == '0' )
 Des(KEY, r, r1);
 else if (argv[2][0] == '1' )
 _Des(KEY, r, r1);
 
 printf("Des result ==%s== \n",r1);
 
 memcpy(sDest+i, r1, 16);
 
 //memset(r2, 0, sizeof(r2));
 //_Des(KEY, r1, r2);
 //printf("Des r2 ==%s== \n",r2);
 
 }
 printf("sDest[%s]\n", sDest);
 
 
 
 
 return 0;
 }*/

/*
 int main (void)
 {
 char *data = "646F4D5A969CFDA5";
 int dataLen = strlen (data);
 char data1[30];
 memset (data1,0x00,30);
 int dataLen1 = 0;
 DB_DES (data,dataLen,data1,&dataLen1,1);
 printf ("data1 = %s",data1);
 }
 
 
 void Str2Hex( char *sSrc, char *sDest, int nSrcLen )
 {
 int i, nHighBits, nLowBits;
 
 for( i = 0; i < nSrcLen; i += 2 )
 {
 nHighBits = sSrc[i];
 nLowBits  = sSrc[i + 1];
 
 if( nHighBits > 0x39 )
 nHighBits -= 0x37;
 else
 nHighBits -= 0x30;
 
 if( i == nSrcLen - 1 )
 nLowBits = 0;
 else if( nLowBits > 0x39 )
 nLowBits -= 0x37;
 else
 nLowBits -= 0x30;
 
 sDest[i / 2] = (nHighBits << 4) | (nLowBits & 0x0f);
 }
 return ;
 }
 
 */


/*modify by yuchao 2014/09/01*/
/*
 int main(int argc,char * argv[])
 {
 int inlen = 0;
 int outlen = 0;
 int flag = 0;
 char inbuf[9] = {'\0'};
 char outbuf[9] = {'\0'};
 if(argc < 5){
 return -1;
 }
 inlen = atoi(argv[1]);
 outlen = atoi(argv[3]);
 flag = atoi(argv[4]);
 memcpy(inbuf,argv[0],sizeof(argv[0])-1);
 DB_DES(&inbuf[0],inlen,&outbuf[0],&outlen,flag);
 return 0;
 }
 */

#if 0
int  DB_DES(char *inbuf, int inlen, char *outbuf, int *outlen, int flag)
{
    unsigned char r[17];
    unsigned char r1[17];
    unsigned char r2[17];
    unsigned char src[256];
    unsigned char sHex[512];
    unsigned char sDest[512];
    int i;
    int nSrcLen;
    int nHexLen;
    memset(r, 0, 17);
    memset(r2, 0, 17);
    memset(src, 0, sizeof(src));
    memset(sHex, 0, sizeof(sHex));
    memset(sDest, 0, sizeof(sDest));
    
    if(inlen > 255)
    {
        return -1;
    }
    
    memcpy(src, inbuf, inlen);
    nSrcLen = strlen(src);
    
    if(flag == 0)   /* Encrypt */
    {
        for(i = 0; i < nSrcLen; i++)
        {
            sprintf(sHex + 2 * i, "%02x", src[i]);
        }
        
        nHexLen = 2 * nSrcLen;
    }
    else if(flag == 1)     /* DisEncrypt */
    {
        nHexLen = nSrcLen;
        memcpy(sHex, src, nHexLen);
    }
    
    for(i = 0; i < nHexLen; i += 16)
    {
        memset(r, 0, sizeof(r));
        memset(r1, 0, sizeof(r1));
        
        if((nHexLen - i) < 16)
        {
            memset(r, '0', 16);
            memcpy(r, sHex + i, nHexLen - i);
        }
        else
        {
            memcpy(r, sHex + i, 16);
        }
        
        if(flag == 0)
        {
            Des(KEY, r, r1);
        }
        else if(flag == 1)
        {
            _Des(KEY, r, r1);
        }
        
        memcpy(sDest + i, r1, 16);
        //memset(r2, 0, sizeof(r2));
        //_Des(KEY, r1, r2);
        //printf("Des r2 ==%s== \n",r2);
    }
    
    *outlen = strlen(sDest);
    memcpy(outbuf, sDest, *outlen);
    
    if(flag == 1)
    {
        memset(outbuf, 0, sizeof(outbuf));
        Str2Hex(sDest, outbuf, *outlen);
        *outlen = *outlen / 2;
    }
    return 0;
}
#endif

void Hex2Str(char *sSrc,  char *sDest, int nSrcLen)
{
    int  i;
    char szTmp[3];
    
    for(i = 0; i < nSrcLen; i++)
    {
        sprintf(szTmp, "%02X", (unsigned char) sSrc[i]);
        memcpy(&sDest[i * 2], szTmp, 2);
    }
    
    return ;
}

void Str2Hex(char *sSrc, char *sDest, int nSrcLen)
{
    int i, nHighBits, nLowBits;
    
    for(i = 0; i < nSrcLen; i += 2)
    {
        nHighBits = sSrc[i];
        nLowBits  = sSrc[i + 1];
        
        if(nHighBits > 0x39)
        {
            nHighBits -= 0x37;
        }
        else
        {
            nHighBits -= 0x30;
        }
        
        if(i == nSrcLen - 1)
        {
            nLowBits = 0;
        }
        else if(nLowBits > 0x39)
        {
            nLowBits -= 0x37;
        }
        else
        {
            nLowBits -= 0x30;
        }
        
        sDest[i / 2] = (nHighBits << 4) | (nLowBits & 0x0f);
    }
    return ;
}

int  DB_DES(char *inbuf, int inlen, char *outbuf, int *outlen, int flag)
{
    char in[32] = {0};
    char out[32] = {0};
    char tmp[32] = {0};
    memcpy(in, inbuf, inlen);
    
    if(flag == 0)   /* Encrypt */
    {
        if(inlen > 8)
        {
            return -1;
        }
        
        Hex2Str(in,  tmp, 8);
        Des(KEY, tmp, out);
    }
    else
    {
        /* DisEncrypt */
        if(inlen != 16)
        {
            return -1;
        }
        
        _Des(KEY, in, tmp);
        Str2Hex(tmp,  out, 16);
    }
    
    strcpy(outbuf, out);
    *outlen = strlen(outbuf);
    return 0;
}

int EncPin(char *pan, int panlen, char *out)
{
    int i = 0;
    char pinblock[32] = {0};
    char panblock[32] = {0};
    char key1[64] = {0};
    char key2[64] = {0};
    char tmp[128] = {0};
    char desin[32] = {0};
    char desout[32] = {0};
    
    strcpy(key1, "D01022D6CA7398B1205A3F86C4C4B8A5");
    strcpy(key2, "BDCC2B43D38B0BFCFA2A20E1B6C611A2");
    
    memcpy(pinblock, "\x06\x00\x00\x00\xFF\xFF\xFF\xFF", 8);
    memset(tmp, 0x00, sizeof(tmp));
    
    for(i = 0; i < 12; i++)
    {
        tmp[i] = pan[panlen - 13 + i];
    }
    
    memset(panblock, 0x00, sizeof(panblock));
    Str2Hex(tmp, &panblock[2], 12);
    
    for(i = 0; i < 8; i++)
    {
        tmp[i] = pinblock[i] ^ panblock[i];
    }
    
    Hex2Str(tmp, desin, 8);
#if 0
    TDes(key1, desin, desout);
#else
    TDes(key2, desin, desout);
#endif
    Str2Hex(desout, out, 16);
    return 0;
}

void decrpt3DES(char *outbuf,char *data,char *myklk)
{
    char desin[32] = {0};
    char key1[64] = {0};
    strcpy(desin, data);
    strcpy(key1,myklk);
    _TDes(key1, desin, outbuf);
}

void encrpt3DES(char *outbuf,char *data,char *myklk)
{
    char desin[32] = {0};
    char key1[64] = {0};
    strcpy(desin, data);
    strcpy(key1,myklk);
    TDes(key1, desin, outbuf);
}

void encrptDES(char *outbuf,char *data,char *myklk)
{
    int dataLen = strlen (data);
    memset (outbuf,0x00,30);
    Des(myklk, data, outbuf);
//    printf ("outbuf = %s\n",outbuf);
}

void decrptDES(char *outbuf,char *data,char *myklk)
{
    int dataLen = strlen (data);
    memset (outbuf,0x00,30);
    _Des(myklk, data, outbuf);
}



@end
