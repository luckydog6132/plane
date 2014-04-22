//
//  GameLayer.m
//  MyPlayPlane
//
//  Created by luckydog on 13-9-2.
//  Copyright (c) 2013年 luckydog. All rights reserved.
//

#import "GameLayer.h"

#import "PubDef.h"
#import "EnemySprite.h"

// 层分类
#define LAYER_PLAYER    3
#define LAYER_BG        0
#define LAYER_SCORE     4
#define LAYER_ENEMY     3

@implementation GameLayer

+(CCScene *) gameScene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [array_Enemys removeAllObjects];
    [array_Enemys release];
    array_Enemys = nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
		/*  
         *  读取图片需要调用
         *  [[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:@"gameArts.plist"];
         *  已经在AppDelegate.m中读取资源
         */
        array_Enemys = [CCArray array];
        [array_Enemys retain];
        
        [self initData];
        // 加载背景
        [self loadBackground];
        // 加载玩家飞机
        [self loadPlayer];
        // 加载子弹
        [self makePlayerBullet];
        
        // 游戏的线程控制
        [self scheduleUpdate];
        
        // touch事件代理
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
	return self;
}
#pragma mark -
#pragma mark 游戏进度
// 游戏结束
-(void)gameOver
{
    isGameOver = YES;
    // 遍历所有节点停止动画
    CCNode *node;
    CCARRAY_FOREACH([self children], node){
        [node stopAllActions];
    }
    
    gameOverLabel = [CCLabelTTF labelWithString:@"GameOver" fontName:@"MarkerFelt-Thin" fontSize:35];
    [gameOverLabel setPosition:ccp(160, 300)];
    [self addChild:gameOverLabel z:LAYER_SCORE];
    
    CCMenuItemFont *gameOverItem = [CCMenuItemFont itemWithString:@"restart" target:self selector:@selector(gameRestart)];
    [gameOverItem setFontName:@"MarkerFelt-Thin"];
    [gameOverItem setFontSize:30];
    restart = [CCMenu menuWithItems:gameOverItem, nil];
    [restart setPosition:ccp(160, 200)];
    [self addChild:restart z:LAYER_SCORE];
}
// 重置游戏
-(void)gameRestart
{
    [self removeAllChildren];
    [array_Enemys removeAllObjects];
    [self initData];
    // 加载背景
    [self loadBackground];
    // 加载玩家飞机
    [self loadPlayer];
    // 加载子弹
    [self makePlayerBullet];
    
}
// 游戏暂停
-(void)gamePause
{
    
}
// 游戏的线程控制
- (void) update:(ccTime)delta
{
    if (!isGameOver && !isPause)
    {
        // 背景滚动
        [self backgrouneScroll];
        
        // 玩家子弹的运动
        [self movePlayerBullet];
        
        // 特殊子弹到期
        [player bulletTimeOut];
        
        // 生成敌人
        [self createEnemyAndProp];
        
        // 移动敌人
        [self moveEnemy];
        
        // 碰撞检测
        [self collisionDetection];
        
        // 难度提高
        [self lvlUp];
    }
}
// 提高难度
-(void)lvlUp
{
    if (game_lvl < 10) {
        t_lvl ++;
        if (t_lvl == TIME_BIG * 5) {
            game_lvl++;
            t_lvl = 0;
        }
    }
}
#pragma mark -
#pragma mark 初始化参数
// 初始化一些参数
- (void) initData {
    
    adjustmentBG = 0;
    isGameOver = NO;
    isPause = NO;

    count_Small = 0;
    count_Mid = 0;
    count_Big = 0;
    
    
    t_smallEP = 0;
    t_midEP = 0;
    t_bigEP = 0;
    t_prop = 0;
    t_lvl = 0;
    game_lvl = 1;
}

// 加载背景
-(void)loadBackground
{
    BG1 = [CCSprite spriteWithSpriteFrameName:@"background_2.png"];
    [BG1 setAnchorPoint:ccp(0.5, 0)];
    [BG1 setPosition:ccp(WINDOW_WIDTH / 2.0, BG1.contentSize.height)];
    [self addChild:BG1 z:LAYER_BG];
    
    BG2 = [CCSprite spriteWithSpriteFrameName:@"background_2.png"];
    [BG2 setAnchorPoint:ccp(0.5, 0)];
    [BG2 setPosition:ccp(WINDOW_WIDTH / 2.0, BG1.contentSize.height * 2.0)];
    [self addChild:BG2 z:LAYER_BG];
    
    //
    adjustmentBG = BG1.contentSize.height;
    
    scoreLabel=[CCLabelTTF labelWithString:[self calculateTheScore] fontName:@"MarkerFelt-Thin" fontSize:18];
    [scoreLabel setColor:ccc3(0, 0, 0)];
    scoreLabel.anchorPoint=ccp(0,1);
    scoreLabel.position=ccp(10,WINDOW_HEIGHT-10);
    [self addChild:scoreLabel z:LAYER_SCORE];
}
// 背景滚动
- (void) backgrouneScroll {
    adjustmentBG--;
    
    if (adjustmentBG<=0) {
        adjustmentBG = BG1.contentSize.height;
    }
    
    [BG1 setPosition:ccp(160, adjustmentBG)];
    [BG2 setPosition:ccp(160, adjustmentBG-BG1.contentSize.height)];
    
}

// 加载玩家
-(void)loadPlayer
{
    NSMutableArray *playerActionArray = [NSMutableArray array];
    
    for (int i = 1 ; i <= 2; i++) {
        NSString *playerFrameName = [NSString stringWithFormat:@"hero_fly_%i.png",i];
        //从 内存池中取出Frame
        CCSpriteFrame* playerFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:playerFrameName];
        // 添加到序列中
        [playerActionArray addObject:playerFrame];
    }
    
    //将数组转化为动画序列,换帧间隔0.1秒
    CCAnimation *playerAnimation = [CCAnimation animationWithSpriteFrames:playerActionArray delay:0.1f];
    
    CCAnimate *actPlayer = [CCAnimate actionWithAnimation:playerAnimation];
    
    player = [PlayerSprite spriteWithSpriteFrameName:@"hero_fly_1.png"];
    
    player.position = ccp(WINDOW_WIDTH / 2.0, 50);
    
    [self addChild:player z:LAYER_PLAYER];
    [player runAction:[CCRepeatForever actionWithAction:actPlayer]];
}
#pragma mark -
#pragma mark 敌人相关
// 生成敌人
-(void) createEnemyAndProp
{
    t_smallEP++;
    t_midEP++;
    t_bigEP++;
    t_prop++;

    // 生成小飞机
    if (t_smallEP > (TIME_SMALL / (1 + 0.1*game_lvl))) {
        EnemySprite *smallEP = [EnemySprite makeSmallEnemyPlaneWithlvl:(float)game_lvl];
        
        [array_Enemys addObject:smallEP];
        
        [self addChild:smallEP z:LAYER_ENEMY];
        t_smallEP = 0;
    }
    // 生成中飞机
    if (t_midEP > (TIME_MIDDLE / (1 + 0.1*game_lvl))) {
        EnemySprite *midEP = [EnemySprite makeMiddleEnemyPlaneWithlvl:(float)game_lvl];
        
        [array_Enemys addObject:midEP];
        
        [self addChild:midEP z:LAYER_ENEMY];
        t_midEP = 0;
    }
    // 生成大飞机
    if (t_bigEP > (TIME_BIG / (1 + 0.1*game_lvl))) {
        EnemySprite *bigEP = [EnemySprite makeBigEnemyPlaneWithlvl:(float)game_lvl];
        
        [array_Enemys addObject:bigEP];
        
        [self addChild:bigEP z:LAYER_ENEMY];
        t_bigEP = 0;
    }
    
}


// 移动敌人
-(void)moveEnemy
{
    for (EnemySprite *sprite in array_Enemys) {
        [sprite move];
        
        if (sprite.position.y < -(sprite.contentSize.height)) {
            [array_Enemys removeObject:sprite];
            [sprite removeFromParent];
        }
    }
}
// 加分
-(void)addScore:(enum EnemyType)enemyType
{
    switch (enemyType) {
        case smallPlane:
            count_Small++;
            break;
        case midPlane:
            count_Mid++;
            break;
        case bigPlane:
            count_Big++;
            break;
        default:
            break;
    }
    // 显示分数
    [scoreLabel setString:[self calculateTheScore]];
}
// 计算分数
-(NSString *)calculateTheScore
{
    NSInteger smallScore = count_Small * SCORE_SMALL;
    NSInteger midScore = count_Mid * SCORE_MIDDLE;
    NSInteger bigScore = count_Big * SCORE_BIG;
    
    NSInteger allScore = smallScore + midScore + bigScore;
    NSString *strScore = [NSString stringWithFormat:@"%08i",allScore];
    return strScore;
}
#pragma mark -
#pragma mark 碰撞检测
// 碰撞检测
-(void)collisionDetection
{
    // 子弹跟敌机
    CGRect bulletRec = player.bullet.boundingBox;
    for (EnemySprite *enemyPlane in array_Enemys) {
        if (CGRectIntersectsRect(bulletRec, enemyPlane.boundingBox)) {
            
            // 重置子弹
            [self resetBullet];
            // 敌人被击中
            [enemyPlane hitByBulletWithBulletType:player.bulletType];
            
            if (enemyPlane.hp<=0) {
                // 加分
                [self addScore:enemyPlane.type];
                // 消失动画
                [enemyPlane over];
                [array_Enemys removeObject:enemyPlane];
            }
            
        }
    }
    
    // 飞机跟玩家
    CGRect playerRec = player.boundingBox;
    playerRec.origin.x += 25;
    playerRec.size.width -= 50;
    playerRec.origin.y -= 10;
    playerRec.size.height -= 10;
    for (EnemySprite *enemyPlane in array_Enemys) {
        if (CGRectIntersectsRect(playerRec, enemyPlane.boundingBox)) {
            [player hit];
            if (player.hp <= 0) {
                [self gameOver];
                // 被消灭的动画
                [player over];
            }
        }
    }
}
#pragma mark -
#pragma mark 子弹相关
// 生成子弹
-(void)makePlayerBullet
{
    switch (player.bulletType) {
        case normal_Bullet:
        {
            player.bullet = [CCSprite spriteWithSpriteFrameName:@"bullet1.png"];
            break;
        }
        case double_Bullet:
        {
            player.bullet = [CCSprite spriteWithSpriteFrameName:@"bullet2.png"];
            break;
        }
        default:
            break;
    }
    
    player.bullet.anchorPoint=ccp(0.5,0.5);
    [self addChild:player.bullet z:LAYER_PLAYER];
    player.bullet.position=ccp(player.position.x,player.position.y+50);
}
// 重置子弹
-(void)resetBullet
{
    [player.bullet removeFromParent];
    [self makePlayerBullet];
}
// 玩家子弹运动
-(void)movePlayerBullet
{
    player.bullet.position=ccp(player.bullet.position.x,player.bullet.position.y+player.bulletSpeed);
    
    if (player.bullet.position.y > WINDOW_HEIGHT-10.0f) {
        [self resetBullet];
    }
}
#pragma mark -
#pragma mark 触摸事件

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isGameOver && !isPause) {
        CGPoint fingerOldPos = [touch locationInView:touch.view];
        fingerOldPos = [[CCDirector sharedDirector] convertToGL:fingerOldPos];
        
        player.fingerOldPos = fingerOldPos;
        
        return YES;
    }else
    {
        return NO;
    }
    
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isGameOver && !isPause) {
        CGPoint fingerMovePos = [touch locationInView:touch.view];
        
        fingerMovePos = [[CCDirector sharedDirector] convertToGL:fingerMovePos];
        
        [player adjustPos:fingerMovePos];
    }
}

@end
