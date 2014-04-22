//
//  GameLayer.h
//  MyPlayPlane
//
//  Created by luckydog on 13-9-2.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "CCLayer.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "PlayerSprite.h"

@interface GameLayer : CCLayer < CCTouchOneByOneDelegate >

{
    // 结束的提示
    CCLabelTTF *gameOverLabel;
    CCMenu *restart;
    
    // 是否结束
    BOOL isGameOver;
    // 是否暂停
    BOOL isPause;
    
    // 游戏难度
    float game_lvl;
    int t_lvl;
    
    // 背景
    CCSprite *BG1;
    CCSprite *BG2;
    
    // 分数
    CCLabelTTF *scoreLabel;
    int count_Small;
    int count_Mid;
    int count_Big;
    
    
    // 背景移动的标记
    int adjustmentBG;
    
    // 玩家飞机
    PlayerSprite *player;
    
    // 敌人数组
    CCArray *array_Enemys;  // 不可使用 NSMutableArray ,会在 remove 时报错
    
    // 敌方飞机生成标记
    int t_smallEP;
    int t_midEP;
    int t_bigEP;
    
    // 道具生成标记
    int t_prop;
    
    
}

+(CCScene *) gameScene;

@end
