//
//  PlayerSprite.m
//  MyPlayPlane
//
//  Created by luckydog on 13-9-2.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "PlayerSprite.h"


@implementation PlayerSprite

+(id)spriteWithSpriteFrameName:(NSString *)spriteFrameName
{
    PlayerSprite *sprite = [super spriteWithSpriteFrameName:spriteFrameName];
    [sprite loadPlayerData];
    return sprite;
}
-(void)loadPlayerData
{
    self.bulletType = double_Bullet;
    self.hp = 1;
    _bulletSpeed = BULLET_SPEED;
}
// 特殊子弹到期
-(void)bulletTimeOut
{
    if (self.bulletType != normal_Bullet) {
        self.bulletTime -- ;
        
        if (self.bulletTime < 0) {
            self.bulletType = normal_Bullet;
        }
    }
}
// 移动飞机的位置
-(void) adjustPos:(CGPoint)fingerMovePos
{
    // 位移量
    CGPoint pos = ccpSub(fingerMovePos,self.fingerOldPos);
    
    // 移动后的位置
    _nextPos = ccpAdd(self.position, pos);
    
    // 判断屏幕边框
    self.anchorPoint = ccp(0.5, 0.5);
    
    if (self.nextPos.x < (self.contentSize.width/2.0))
    {
        _nextPos = ccp(self.contentSize.width/2.0,self.nextPos.y);
    }else if(self.nextPos.x > (WINDOW_WIDTH - (self.contentSize.width/2.0)))
    {
        _nextPos = ccp(WINDOW_WIDTH - self.contentSize.width/2.0,self.nextPos.y);
    }
    
    if (self.nextPos.y < (self.contentSize.height/2.0))
    {
        _nextPos = ccp(self.nextPos.x,self.contentSize.height/2.0);
    }else if (self.nextPos.y > (WINDOW_HEIGHT - (self.contentSize.height/2.0)))
    {
        _nextPos = ccp(self.nextPos.x,WINDOW_HEIGHT - self.contentSize.height/2.0);
    }
    
    // 移动并保存手指的上个位置
    self.position = self.nextPos;
    
    self.fingerOldPos = fingerMovePos;
}

// 被击中或碰撞
-(void)hit
{
    self.hp -- ;
}

// 被消灭的动画
-(void)over
{
    NSMutableArray *actionArray = [NSMutableArray array];
    
    for (int i = 1; i<=4 ; i++ ) {
        NSString* key = [NSString stringWithFormat:@"hero_blowup_%i.png", i];
        //从内存池中取出Frame
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
        //添加到序列中
        [actionArray addObject:frame];
    }
    
    // 将数组转化为动画序列,换帧间隔0.1秒
    CCAnimation* animPlayer = [CCAnimation animationWithSpriteFrames:actionArray delay:0.1f];
    // 生成动画播放的行为对象
    id act = [CCAnimate actionWithAnimation:animPlayer];
    // 清空缓存数组
    [actionArray removeAllObjects];
    
    [self runAction:[CCSequence actions:act, nil]];
}
@end
