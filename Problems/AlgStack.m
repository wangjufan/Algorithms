//
//  AlgStack.m
//  Algorithms
//
//  Created by wangjufan on 17-6-5.
//  Copyright (c) 2017年 dudu. All rights reserved.
//

#import "AlgStack.h"

#include <sys/time.h>

@implementation AlgStack


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
BOOL isReasonablePopSequenceForPushSequence(NSArray * pushSequence, NSArray * popSequence){
    
    BOOL matched = YES;
    int indexPush = 0;
    
    NSUInteger size = [popSequence count];
    
    NSMutableArray * marks = [NSMutableArray arrayWithCapacity:size];
    for (int i= 0; i<size; i++) {
        [marks insertObject:[NSNumber numberWithBool:NO] atIndex:i];
    }
    
    for (int index = 0; (index<size) && matched; index++) {
        NSUInteger popValue = [[popSequence objectAtIndex:index] integerValue];
        
        //move to previous unmarked position
        while (indexPush > 0) {
            if ([[marks objectAtIndex:indexPush] boolValue]) {
                indexPush--;
            }else{
                break;
            }
        }
        
        while (matched) {
            
            //move to the back unmarked position
            while ([[marks objectAtIndex:indexPush] boolValue]) {
                indexPush++;
                if (indexPush==size) {
                    matched = NO;
                    break;
                }
            }
            
            if (matched) {
                NSUInteger pushValue = [[pushSequence objectAtIndex:indexPush] integerValue];
                if (pushValue == popValue) {
                    [marks replaceObjectAtIndex:indexPush withObject:[NSNumber numberWithBool:YES]];
                    break;
                }else{
                    indexPush++;
                    if (indexPush ==size) {
                        matched = NO;
                        break;
                    }
                }
            }
            
        }
    }
    
    return matched;
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/*
 扩展2.1：
 对于n个入栈序列，一个push顺序，且当前栈中有0个入栈元素
 输出所有可能的n个元素的pop序列数量。
 为了简化问题，假设pop序列为1到n+m的整数序列。
 */


unsigned long long allPossiblePopOrderNumber_Recursion_Obsolete3(unsigned int unpushed, unsigned int pushed){
    unsigned long long count = 0;
    
    //    if (pushed == 0) {
    //        if (unpushed>1) {
    //            count += allPossiblePushPopNumber(unpushed-1, 1);
    //        }else{
    //            count += 1;
    //        }
    //    }else{
    //        for (int i=0; i<= pushed ; i++) {
    //            if (unpushed > 1) {
    //                count += allPossiblePushPopNumber(unpushed-1, i+1);
    //            }else{
    //                count+=1;
    //            }
    //
    //        }
    //    }
    //    等价于
    //    for (int i=0; i<= pushed ; i++) {
    //        if (unpushed > 1) {
    //            count += allPossiblePushPopNumber(unpushed-1, i+1);
    //        }else{
    //            count+=1;
    //        }
    //
    //    }
    //    等价于
    //    for (int i=0; i<= pushed ; i++) {
    //        if (unpushed == 1) {
    //            count+=1;
    //        }
    //    }
    //    for (int i=0; i<= pushed ; i++) {
    //        if (unpushed > 1) {
    //            count += allPossiblePushPopNumber(unpushed-1, i+1);
    //        }
    //    }
    //    等价于
    //    if (unpushed == 1) {
    //        for (int i=0; i<= pushed ; i++) {
    //            count+=1;
    //        }
    //    }
    //    if (unpushed > 1) {
    //        for (int i=0; i<= pushed ; i++) {
    //            count += allPossiblePushPopNumber(unpushed-1, i+1);
    //        }
    //    }
    //    等价于
    //    if (unpushed == 1) {
    //        return pushed+1;
    //    }
    //    if (unpushed > 1) {
    //        for (int i=0; i<= pushed ; i++) {
    //            count += allPossiblePushPopNumber(unpushed-1, i+1);
    //        }
    //    }
    //    等价于
    if (unpushed == 1) {
        count = pushed+1;
    }
    if (unpushed > 1) {
        for (int i=0; i<= pushed ; i++) {
            count += allPossiblePopOrderNumber_Recursion_Obsolete3(unpushed-1, i+1);
        }
    }
    
    return count;
}



unsigned long long allPossiblePopOrderNumber_NonRecursion_Obsolete2(unsigned int elementNum){
    
    if (elementNum == 1) {
        return 1;
    }
    if (elementNum == 2) {
        return 2;
    }
    unsigned int size = elementNum * sizeof(unsigned long long);
    unsigned long long  * currentCeosU = malloc(size);
    unsigned long long * nextCeosU = malloc(size);
    memset(currentCeosU, 0, size);
    memset(nextCeosU, 0, size);
    
    
    NSUInteger unpushed = elementNum-1;
    unsigned int currentNum = 0;
    
    unsigned int nextNum = 1;
    unsigned int index = 0;
    nextCeosU[1] = 1;
    
    while (unpushed > 1 || currentNum > 0) {
        
        if (currentNum == 0) {
            memcpy(currentCeosU, nextCeosU, size);
            memset(nextCeosU, 0, size);
            currentNum = nextNum;
            index = 1;
            unpushed -= 1;
            nextNum++;
            
            NSLog(@"---");
            printSysTime();
        }else{
            index++;
        }
        
        for (int i = 1; i<= index+1; i++) {
            nextCeosU[i] = nextCeosU[i] + currentCeosU[index];;
        }
        
        currentNum--;
    }
    
    unsigned long long count = 0;  //sum of (key+1)* coe
    unsigned long long pre = 0;
    for (unsigned int i = 1; i < elementNum; i++) {
        unsigned long long value = nextCeosU[i];
        count += (i+1) * value;
        pre = count;
    }
    
    free(currentCeosU);
    free(nextCeosU);
    nextCeosU = nil;
    currentCeosU = nil;
    
    printSysTime();
    
    
    return count;
}




static inline NSString * keyFor(unsigned long pushed){
    return [NSString stringWithFormat:@"%lu",(unsigned long)pushed];
}
unsigned long long allPossiblePopOrderNumber_NonRecursion_Obsolete1(unsigned int elementNum){
    
    
    NSMutableDictionary * currentCeos = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * currentKeys = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary * nextCeos = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray * nextKeys = [NSMutableArray arrayWithCapacity:0];
    
    unsigned int unpushed = elementNum;
    unsigned int pushed = 0; //key
    [nextKeys addObject:keyFor(pushed)];
    [nextCeos setObject:[NSNumber numberWithUnsignedLongLong:1] forKey:keyFor(pushed)];
    
    
    while (unpushed > 1 || [currentKeys count] > 0) {
        if ([currentKeys count] == 0) {
            currentKeys = nextKeys;
            nextKeys = [NSMutableArray arrayWithCapacity:elementNum];
            currentCeos = nextCeos;
            nextCeos = [NSMutableDictionary dictionaryWithCapacity:elementNum];
            unpushed -= 1;
        }
        
        pushed = [[currentKeys objectAtIndex:0] intValue];
        [currentKeys removeObjectAtIndex:0];
        NSUInteger ceo = [[currentCeos objectForKey:keyFor(pushed)] unsignedLongLongValue];
        [currentCeos removeObjectForKey:keyFor(pushed)];
        
        
        for (int i = 1; i<= pushed+1; i++) {
            
            NSString * key = keyFor(i);
            if ([nextKeys count] < i) {
                [nextKeys insertObject:key atIndex:i-1];
            }
            
            NSUInteger nextCeo = 0;
            if ([nextCeos objectForKey:key]) {
                nextCeo += [[nextCeos objectForKey:key] unsignedLongLongValue];
            }
            nextCeo += ceo;
            [nextCeos setObject:[NSNumber numberWithUnsignedLongLong:nextCeo] forKey:key];
        }
        
    }
    
    unsigned long long count = 0;  //sum of (key+1)* coe
    unsigned long long pre = 0;
    NSLog(@"%@", nextCeos);
    for (NSString * key in nextKeys) {
        unsigned long long value = [[nextCeos objectForKey:key] unsignedLongLongValue];
        NSUInteger keyValue = [key longLongValue] + 1;
        count += keyValue * value;
        if (pre > count) {
            NSLog(@"-overflow--pre : %lld", pre);
            NSLog(@"--overflow-count: %lld", count);
        }
        pre = count;
    }
    
    return count;
}

unsigned long long countOfAllPossiblePopSequencesByCatanat(unsigned int n){
    
    unsigned long long count = 1;
    int innerN = n;
    
    count = 1;
    unsigned int dn = 2* innerN;
    
    for (int i = 0; i < innerN; ++i){
        count *= ( dn - i);
        count /= (i + 1);
    }
    count = count / (innerN+1);
    
    return count;
}



/*
 扩展2.2：
 对于n个入栈序列，一个push顺序，且当前栈中有m个入栈元素
 输出所有可能的n+m个元素的pop序列。
 为了简化问题，假设pop序列为1到n+m的整数序列。
 */
unsigned long long countOfAllPossiblePopSequences(unsigned int unpushed, unsigned int pushed){
    
    if (unpushed == 0) {
        return 1;
    }
    if (unpushed == 1) {
        return pushed + 1;
    }
    
    unsigned int elementNum = unpushed + pushed;
    unsigned int size = elementNum * sizeof(unsigned long long);
    
    unsigned long long  * currentCeosU = malloc(size);
    unsigned long long * nextCeosU = malloc(size);
    memset(currentCeosU, 0, size);
    memset(nextCeosU, 0, size);
    
    unsigned int currentNum = 0;
    unsigned int nextNum = pushed+1;
    unsigned int index = 0;
    
    nextCeosU[1] = 1;
    unpushed -= 1;
    
    for (int i = 1; i<= pushed+1; i++) {
        nextCeosU[i] = 1;;
    }
    
    while (unpushed > 1 || currentNum > 0) {
        
        if (currentNum == 0) {
            memcpy(currentCeosU, nextCeosU, size);
            memset(nextCeosU, 0, size);
            currentNum = nextNum;
            
            index = 1;
            unpushed -= 1;
            nextNum++;
        }else{
            index++;
        }
        
        for (int i = 1; i<= index+1; i++) {
            unsigned long long vlaue = nextCeosU[i] + currentCeosU[index];
            nextCeosU[i] = vlaue;
        }
        
        currentNum--;
    }
    
    unsigned long long count = 0;  //sum of (key+1)* coe
    unsigned long long pre = 0;
    for (unsigned int i = 1; i < elementNum; i++) {
        unsigned long long value = nextCeosU[i];
        count += (i+1) * value;
        if (pre > count) {
            NSLog(@"over flow");
        }
        pre = count;
    }
    
    free(currentCeosU);
    free(nextCeosU);
    nextCeosU = nil;
    currentCeosU = nil;
    
    return count;
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/*
 remove the push sequences 
 and just keep the pop sequences
 */

// 2 ->  2,  1 1 ;
//3 -> 3,   2 1  , 1 1 1
// 4 -> 4, 3 1 , 2 2 , 2 1 1 , 1 1 1 1

/*  下面做简单的分析，详细的分析 等我拿到《计算机程序设计艺术4A》如需要添加，我会适当的添加一些
 
 1 动态编程法，逐步生成  1 2 3  ... n的生成序列
 2
 
 
 first let's see the following pop sequeces with just five 5 elements:
 
 5   C(5,0)=1
 push(0)pop(0) push(1)pop(1) push(2)pop(2) push(3)pop(3)   push(4)pop(4) 00 11 22 33 44
 
 4 1   C(4,1)=4
 push(0)push(1)pop(1)pop(0)  push(2)pop(2) push(3)pop(3)   push(4)pop(4) 0110 22 33 44
 push(0)pop(0) push(1)push(2)pop(2)pop(1) push(3)pop(3) push(4)pop(4)    00 1221 33 44
 push(0)pop(0) push(1)pop(1)  push(2)push(3)pop(3)pop(2) push(4)pop(4)   00 11 2332 44
 push(0)pop(0) push(1)pop(1) push(2)pop(2) push(3)push(4)pop(4)pop(3)    00 11 22 3443
 
 3 2  C(3,2)=3
 push(0)push(1)pop(1)pop(0) push(2)push(3)pop(3)pop(2)   push(4) pop(4)   0110 2332 44
 push(0)push(1)pop(1)pop(0) push(2) pop(2) push(3)push(4)pop(4)pop(3)     0110 22 3443
 push(0) pop(0) push(1)push(2)pop(2)pop(1) push(3)push(4)pop(3)pop(4)     00 1221 3443
 
 3 1 1 C(3,1)*C(1,1)=3
 push(0)push(1)push(2)pop(2)pop(1)pop(0)   push(3)pop(3)   push(4)pop(4)  012210 33 44
 push(0)pop(0)  push(1)push(2)push(3)pop(3)pop(2)pop(1)   push(4)pop(4)   00 123321 44
 push(0)pop(0) push(1)pop(1)  push(2)push(3)push(4)pop(4)pop(3)pop(2)     00 11 234432
 
 2 2 1 C(2,2)*C(2,1)=2
 push(0)push(1)pop(1)pop(0) push(2)push(3)push(4)pop(4)pop(3)pop(2)       0110 234432
 push(0)push(1)push(2)pop(2)pop(1)pop(0) push(3)push(4)pop(4)pop(3)       012210 3443
 
 2 1 1 1  C(2,1)*C(1,1)*C(1,1)=2
 push(0)push(1)push(2)push(3)pop(3)pop(2)pop(1)pop(0)  push(4)pop(4)     01233210 44
 push(0)pop(0)  push(1)push(2)push(3)push(4)pop(1)pop(2)pop(3)pop(4)     00 12344321
 
 1 1 1 1 1
 push(0)push(1)push(2)push(3)push(4) pop(4)pop(3)pop(2)pop(1)pop(0)      01234 43210
 
 */
void generatingAllPossiblePopSequences( long long  n){
    
    long long elements[n];
    for (int i= 0; i < n; i++) {
        elements[i] = i;
    }
    
    long long stack[n];
    long long stackIndex = 0;
    for (int i= 0; i < n; i++) {
        stack[i] = -1;
    }
    
    int elementsIndex = 0;

}



static inline void generateRepresentationNumberSequence(long long n){
    
    unsigned long long representaions[n];
    memcpy(representaions, 0, n*sizeof(unsigned long long));
    representaions[0] = n;
    
    long long length = 1;
    
    while (representaions[9] > 1) {
        
        //find the first one that great than 1
        long long indexDecrease = length -1;
        for (; indexDecrease >= 0; indexDecrease--) {
            if (representaions[indexDecrease] > 1) {
                representaions[indexDecrease] -= 1;
                break;
            }
        }
//        
//        long long indexIncrease = indexDecrease+1;
//        for (; index < length; index++) {
//            if (representaions[index] > 1) {
//                representaions[index] -= 1;
//            }
//        }
    }
    
}

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
void printSysTime(){
    struct timeval t_val;  //tv_usec 微妙
    gettimeofday(&t_val, NULL);
    printf("time sec=%ld m_sec=%d \n", t_val.tv_sec, t_val.tv_usec);
}

unsigned char biggestUnsignedLongLongForNthPower(unsigned char base){
    unsigned long long count = 0;
    unsigned long long pre = 0;
    count = base;
    unsigned char number = 0;
    while (count > pre) {
        pre = count;
        count *= base;
        number++;
    }
    return number;
}


@end



