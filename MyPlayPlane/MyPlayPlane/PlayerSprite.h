//
//  PlayerSprite.h
//  MyPlayPlane
//
//  Created by luckydog on 13-9-2.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "PubDef.h"

@interface PlayerSprite : CCSprite

@property (readwrite) CGPoint fingerOldPos;
    
@property (readonly) CGPoint nextPos;

@property (readwrite) int hp;

@property (assign) CCSprite *bullet;
@property (readwrite) enum BulletType bulletType;       // 子弹类型
@property (readwrite) float bulletSpeed;                // 子弹速度
@property (readwrite) int bulletTime;                   // 特殊子弹时间

+(id)spriteWithSpriteFrameName:(NSString *)spriteFrameName;

// 特殊子弹到期
-(void)bulletTimeOut;       

-(void) adjustPos:(CGPoint)movePos;

// 被击中或碰撞
-(void)hit;

// 被消灭的动画
-(void)over;
@end
