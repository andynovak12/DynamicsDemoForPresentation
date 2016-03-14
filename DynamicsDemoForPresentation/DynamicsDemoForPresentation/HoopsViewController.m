//
//  HoopsViewController.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/11/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "HoopsViewController.h"
#import <QuartzCore/QuartzCore.h>



@interface HoopsViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *basketball;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (weak, nonatomic) IBOutlet UIView *frontOfRim;
@property (weak, nonatomic) IBOutlet UIView *backboard;

@property (nonatomic) CFAbsoluteTime lastTime;
@end


@implementation HoopsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.basketball.layer.cornerRadius = self.basketball.frame.size.height/2;
    self.basketball.clipsToBounds = YES;
//    [self.basketball.widthAnchor constraintEqualToConstant:50].active = YES;
//        [self.basketball.heightAnchor constraintEqualToConstant:50].active = YES;

    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    
    //create collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.basketball, self.frontOfRim, self.backboard]];
    //makes our main view’s bounds work as boundaries for the items that will collide.
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //dictates that all edges of items that participate to a collision will have the desired behavior.
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    //make view collisionDelegate
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    

    //set the basketballs properties
    UIDynamicItemBehavior *ballDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.basketball]];
    ballDynamic.elasticity = 0.8;
    ballDynamic.resistance = 0;
    ballDynamic.allowsRotation = YES;
    [self.animator addBehavior:ballDynamic];
    
    //set the hoops properties
    UIDynamicItemBehavior *hoopDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.frontOfRim, self.backboard]];
    hoopDynamic.anchored = YES;
    [self.animator addBehavior:hoopDynamic];
    
//    [self repositionBall];
}


- (IBAction)ballSwipped:(UIPanGestureRecognizer*)recognizer {
    if (UIGestureRecognizerStateBegan) {
        NSLog(@"started");
    }
    if (UIGestureRecognizerStateEnded){
        CGPoint velocity = [recognizer velocityInView:[recognizer.view superview]];
        // If needed: CGFloat slope = velocity.y / velocity.x;
        CGFloat angle = atan2f(velocity.y, velocity.x);
        CGFloat velocityAsFloat = sqrt(pow(velocity.y,2)+pow(velocity.x, 2));
        
        //push the ball
        [self pushTheBallWithAngle:angle WithVelocity:velocityAsFloat];
        NSLog(@"%f", angle);
    }

    //this only registers swipes longer than 0.1
//    UIGestureRecognizerState state = recognizer.state;
//    CGPoint gestureVelocity = [recognizer velocityInView:[recognizer.view superview]];
//    CGPoint finalSpeed = CGPointMake(0, 0);
//    
//    if ( state == UIGestureRecognizerStateBegan ){
//        self.lastTime = CFAbsoluteTimeGetCurrent();
//    }
//    else if ( state == UIGestureRecognizerStateEnded ) {
//        double curTime = CFAbsoluteTimeGetCurrent();
//        double timeElapsed = curTime - self.lastTime;
//        if ( timeElapsed > 0.05 )
//            finalSpeed = gestureVelocity;
//        else{
//            finalSpeed = CGPointZero;
//        }
//        NSLog(@"%f", timeElapsed);
//    }
//
    //if there is a final speed that is not 0
//    if ((finalSpeed.x != 0) || (finalSpeed.y != 0)) {
//        NSLog(@"SPEED %@",NSStringFromCGPoint(finalSpeed));
//        CGFloat velocityAsFloat = sqrt(pow(finalSpeed.y,2)+pow(finalSpeed.x, 2));
//        CGFloat angle = atan2f(finalSpeed.y, finalSpeed.x);
//
//        [self pushTheBallWithAngle:angle WithVelocity:velocityAsFloat];
//    }
//

}
//- (IBAction)resetTapped:(id)sender {
//    NSLog(@"tapped");
//    [self.animator removeBehavior:self.pushBehavior];
//
////    [self.animator removeAllBehaviors];
//    [self repositionBall];
//}

-(void)pushTheBallWithAngle:(CGFloat)angle WithVelocity:(CGFloat)velocity{
    //gravity for ball
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.basketball]];
    gravityBehavior.magnitude = 1.5;
    

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.basketball] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = velocity/4000;
    self.pushBehavior.angle = angle;
    
    [self.animator addBehavior:self.pushBehavior];
    [self.animator addBehavior:gravityBehavior];
    NSLog(@"pushed");
}

//-(void)repositionBall{
//    [self.view removeConstraints:self.view.constraints];
//    self.basketball.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLog(@"repositioned");
//    [self.basketball.widthAnchor constraintEqualToConstant:50].active = YES;
//    [self.basketball.heightAnchor constraintEqualToConstant:50].active = YES;
//    [self.basketball.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:100].active = YES;
//    [self.basketball.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:300].active = YES;
//    
//}

@end
