//
//  PubDef.h
//  MyPlayPlane
//
//  Created by luckydog on 13-9-2.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import <Foundation/Foundation.h>


#define WINDOW_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH [[UIScreen mainScreen] bounds].size.width

#define BULLET_SPEED 25.0f

//随机数
#define MY_RAND(a) (arc4random()%(a))

// 敌人hp最大值
#define HP_SMALL 1
#define HP_MIDDLE 5
#define HP_BIG 20

// 消灭敌人获得分数
#define SCORE_SMALL 100
#define SCORE_MIDDLE 500
#define SCORE_BIG 1000

// 敌人出现间隔
#define TIME_SMALL  30
#define TIME_MIDDLE 150
#define TIME_BIG 500

/* 
 *  子弹类型
 *  后面的对应值为攻击力
 */
enum BulletType {
    normal_Bullet = 1,
    double_Bullet = 2
    };

/* 
 *  敌人类型
 *  后面的对应值暂无意义
 */
enum EnemyType {
    smallPlane = 0,
    midPlane = 1,
    bigPlane = 2
    };

/*
 *  道具类型
 *  后面的对应值暂无意义
 */
enum PropType {
    prop_Bomb = 0,
    prop_DoubleBullet = 1
    };

@interface PubDef : NSObject

@end
