//
//  GameConfig.h
//  VolcanoPongProto2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright MegaBlasterSuperHeroes 2012. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#define GAME_AUTOROTATION kGameAutorotationUIViewController

#endif // __GAME_CONFIG_H

