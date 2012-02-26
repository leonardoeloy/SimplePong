//
//  AppDelegate.h
//  VolcanoPongProto2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright MegaBlasterSuperHeroes 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
