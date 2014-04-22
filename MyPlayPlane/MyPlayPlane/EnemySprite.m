//
//  EnemySprite.m
//  MyPlayPlane
//
//  Created by luckydog on 13-9-4.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "EnemySprite.h"

@implementation EnemySprite

// 造小飞机
+(EnemySprite *)makeSmallEnemyPlaneWithlvl:(float)lvl
{
    EnemySprite *sprite = [EnemySprite spriteWithSpriteFrameName:@"enemy1_fly_1.png"];
    
    [sprite setHp:HP_SMALL];
    [sprite setMaxHp:HP_SMALL];
    [sprite setType:smallPlane];
    [sprite setSpeed:(int)((MY_RAND(2)+2)+(lvl))];
    [sprite setAnchorPoint:ccp(0,0)];
    [sprite setPosition:ccp(MY_RAND((int)(WINDOW_WIDTH - sprite.contentSize.width)), WINDOW_HEIGHT + 20.0)];
    return sprite;
}
// 造中飞机
+(EnemySprite *)makeMiddleEnemyPlaneWithlvl:(float)lvl
{
    EnemySprite *sprite = [EnemySprite spriteWithSpriteFrameName:@"enemy3_fly_1.png"];
    
    [sprite setHp:HP_MIDDLE];
    [sprite setMaxHp:HP_MIDDLE];
    [sprite setType:midPlane];
    [sprite setSpeed:(int)((MY_RAND(2)+2)+(lvl*0.5))];
    [sprite setAnchorPoint:ccp(0,0)];
    [sprite setPosition:ccp(MY_RAND((int)(WINDOW_WIDTH - sprite.contentSize.width)), WINDOW_HEIGHT + 20.0)];
    return sprite;
}
// 造大飞机
+(EnemySprite *)makeBigEnemyPlaneWithlvl:(float)lvl
{
    NSMutableArray *bigFoePlaneActionArray = [NSMutableArray array];
    for (int i = 1 ; i<=2; i++) {
        NSString* key = [NSString stringWithFormat:@"enemy2_fly_%i.png", i];
        // 从内存池中取出Frame
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
        // 添加到序列中
        [bigFoePlaneActionArray addObject:frame];
    }
    
    // 将数组转化为动画序列,换帧间隔0.1秒
    CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:bigFoePlaneActionArray delay:0.1f];
    // 生成动画播放的行为对象
    id actPlayer = [CCAnimate actionWithAnimation:animPlayer];
    // 清空缓存数组
    [bigFoePlaneActionArray removeAllObjects];
    
    EnemySprite *sprite = [EnemySprite spriteWithSpriteFrameName:@"enemy2_fly_1.png"];
    [sprite runAction:[CCRepeatForever actionWithAction:actPlayer]];
    
    [sprite setHp:HP_BIG];
    [sprite setMaxHp:HP_BIG];
    [sprite setType:bigPlane];
    [sprite setSpeed:(int)((MY_RAND(2)+2)+(lvl*0.3))];
    [sprite setAnchorPoint:ccp(0,0)];
    [sprite setPosition:ccp(MY_RAND((int)(WINDOW_WIDTH - sprite.contentSize.width)), WINDOW_HEIGHT + 20.0)];
    return sprite;
}


// 移动
-(void)move
{
    [self setPosition:ccp(self.position.x, self.position.y-self.speed)];
}

// 被击中
-(void)hitByBulletWithBulletType:(enum BulletType)bulletType
{
    
    for (int i = 0; i < bulletType; i++)
    {
        self.hp -= 1;
        // 判断是否显示低hp动画
        if (self.hp == (int)(self.maxHp * 0.5)) {
            [self lowHp];
        }
    }
}

// 低hp动画
-(void)lowHp
{
    switch (self.type) {
        case smallPlane:
        {
            break;
        }
        case midPlane:
        {
            NSMutableArray *playerActionArray = [NSMutableArray array];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy3_fly_1.png"];
            [playerActionArray addObject:frame];
            for (int i = 1 ; i<=2; i++) {
                NSString* key = [NSString stringWithFormat:@"enemy3_hit_%d.png",i];
                // 从内存池中取出Frame
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                // 添加到序列中
                [playerActionArray addObject:frame];
            }
            
            // 将数组转化为动画序列,换帧间隔0.1秒
            CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:playerActionArray delay:0.1f];
            // 生成动画播放的行为对象
            id actPlayer = [CCAnimate actionWithAnimation:animPlayer];
            // 清空缓存数组
            [playerActionArray removeAllObjects];
            [self stopAllActions];
            [self runAction:[CCRepeatForever actionWithAction:actPlayer]];
            break;
        }
        case bigPlane:
        {
            NSMutableArray *playerActionArray = [NSMutableArray array];
            
            for (int i = 1; i<=2; i++) {
                NSString* key = [NSString stringWithFormat:@"enemy2_fly_%i.png",i];
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                [playerActionArray addObject:frame];
            }
            
            for (int i = 1 ; i<=1; i++) {
                NSString* key = [NSString stringWithFormat:@"enemy2_hit_%d.png",i];
                // 从内存池中取出Frame
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                // 添加到序列中
                [playerActionArray addObject:frame];
            }
            
            // 将数组转化为动画序列,换帧间隔0.1秒
            CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:playerActionArray delay:0.1f];
            // 生成动画播放的行为对象
            id actPlayer = [CCAnimate actionWithAnimation:animPlayer];
            // 清空缓存数组
            [playerActionArray removeAllObjects];
            [self stopAllActions];
            [self runAction:[CCRepeatForever actionWithAction:actPlayer]];
            break;
        }
        default:
            break;
    }
}

// 被消灭
-(void)over
{
    switch (self.type) {
        case smallPlane:
        {
            NSMutableArray *actionArray = [NSMutableArray array];
            
            for (int i = 1; i<=4 ; i++ ) {
                NSString* key = [NSString stringWithFormat:@"enemy1_blowup_%i.png", i];
                // 从内存池中取出Frame
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                // 添加到序列中
                [actionArray addObject:frame];
            }
            
            // 将数组转化为动画序列,换帧间隔0.1秒
            CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:actionArray delay:0.1f];
            // 生成动画播放的行为对象
            id actPlane = [CCAnimate actionWithAnimation:animPlayer];
            // 播放完动画删除
            id end = [CCCallFuncN actionWithTarget:self selector:@selector(removeFromParent)];
            // 清空缓存数组
            [actionArray removeAllObjects];
            
            [self stopAllActions];
            [self runAction:[CCSequence actions:actPlane, end, nil]];
            break;
        }
        case midPlane:
        {
            NSMutableArray *actionArray = [NSMutableArray array];
            
            for (int i = 1; i<=4 ; i++ ) {
                NSString* key = [NSString stringWithFormat:@"enemy3_blowup_%i.png", i];
                // 从内存池中取出Frame
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                // 添加到序列中
                [actionArray addObject:frame];
            }
            
            // 将数组转化为动画序列,换帧间隔0.1秒
            CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:actionArray delay:0.1f];
            // 生成动画播放的行为对象
            id actPlane = [CCAnimate actionWithAnimation:animPlayer];
            // 播放完动画删除
            id end = [CCCallFuncN actionWithTarget:self selector:@selector(removeFromParent)];
            // 清空缓存数组
            [actionArray removeAllObjects];
            
            [self stopAllActions];
            [self runAction:[CCSequence actions:actPlane, end, nil]];
            break;
        }
        case bigPlane:
        {
            NSMutableArray *actionArray = [NSMutableArray array];
            
            for (int i = 1; i<=7 ; i++ ) {
                NSString* key = [NSString stringWithFormat:@"enemy2_blowup_%i.png", i];
                // 从内存池中取出Frame
                CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
                // 添加到序列中
                [actionArray addObject:frame];
            }
            
            // 将数组转化为动画序列,换帧间隔0.1秒
            CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:actionArray delay:0.1f];
            // 生成动画播放的行为对象
            id actPlane = [CCAnimate actionWithAnimation:animPlayer];
            // 播放完动画删除
            id end = [CCCallFuncN actionWithTarget:self selector:@selector(removeFromParent)];
            // 清空缓存数组
            [actionArray removeAllObjects];
            
            [self runAction:[CCSequence actions:actPlane, end, nil]];
            break;
        }
        default:
            break;
    }
}
@end
