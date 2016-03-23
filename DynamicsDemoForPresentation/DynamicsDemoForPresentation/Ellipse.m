//
//  Ellipse.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/22/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "Ellipse.h"

@implementation Ellipse

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIDynamicItemCollisionBoundsType) collisionBoundsType
{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
