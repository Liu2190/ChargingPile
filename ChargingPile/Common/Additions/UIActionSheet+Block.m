//
//  UIActionSheet+Block.m
//  ChargingPile
//
//  Created by chargingPile on 15/4/14.
//  Copyright (c) 2015年 chargingPile. All rights reserved.
//

#import "UIActionSheet+Block.h"
#import <objc/runtime.h>

static char UIActionSheet_key_clicked;

@implementation UIActionSheet (Block)

- (void)showActionSheetWithClickBlock:(CompleteBlock)block;
{
    if(block)
    {
        objc_removeAssociatedObjects(self);
    }
    objc_setAssociatedObject(self, &UIActionSheet_key_clicked, block, OBJC_ASSOCIATION_COPY);
    self.delegate = self;
    [self showInView:[[UIApplication sharedApplication]keyWindow]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, &UIActionSheet_key_clicked);
    if (block)
    {
        block(buttonIndex);
    }
}
@end
