//
//  AppDelegate.h
//  ImageBlend
//
//  Created by Lion0324 on 11/19/15.
//  Copyright © 2015 Lion0324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIImage *g_photoImage;
@property (strong, nonatomic) UIImage *g_flagImage;


+(AppDelegate*) sharedInstance;

@end

