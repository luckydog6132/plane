//
//  EnemySprite.h
//  MyPlayPlane
//
//  Created by luckydog on 13-9-4.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "PubDef.h"

@interface EnemySprite : CCSprite

@property (readwrite) enum EnemyType type;

@property (readwrite) int hp;
@property (readwrite) int maxHp;

@property (readwrite) float speed;

// 造小飞机
+(EnemySprite *)makeSmallEnemyPlaneWithlvl:(float)lvl;
// 造中飞机
+(EnemySprite *)makeMiddleEnemyPlaneWithlvl:(float)lvl;
// 造大飞机
+(EnemySprite *)makeBigEnemyPlaneWithlvl:(float)lvl;


// 移动
-(void)move;

// 被击中
-(void)hitByBulletWithBulletType:(enum BulletType)bulletType;

// 低hp动画
-(void)lowHp;

// 被消灭
-(void)over;

@end
