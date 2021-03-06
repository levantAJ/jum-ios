//
//  UIButton+Property.m
//  jumps
//
//  Created by AJ on 4/9/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "UIButton+Property.h"
#import <objc/runtime.h>

@implementation UIButton(Property)
static char UIB_PROPERTY_KEY;

@dynamic property;

-(void)setProperty:(NSObject *)property
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject *)property
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

@end
