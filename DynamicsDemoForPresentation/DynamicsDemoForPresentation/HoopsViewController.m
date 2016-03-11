//
//  HoopsViewController.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/11/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "HoopsViewController.h"


@interface HoopsViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *basketball;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@end


@implementation HoopsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //gravity for ball
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.basketball]];
    [self.animator addBehavior:gravityBehavior];

    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    [self repositionBall];
}


- (IBAction)ballSwipped:(UIPanGestureRecognizer*)recognizer {
    if (UIGestureRecognizerStateBegan) {
        NSLog(@"started");
    }
    if (UIGestureRecognizerStateEnded){
        CGPoint velocity = [recognizer velocityInView:[recognizer.view superview]];
        // If needed: CGFloat slope = velocity.y / velocity.x;
        CGFloat angle = atan2f(velocity.y, velocity.x);
        
        [self pushTheBall:angle];
        NSLog(@"%f", angle);
    }
}
- (IBAction)resetTapped:(id)sender {
    NSLog(@"tapped");
    [self.animator removeBehavior:self.pushBehavior];
    
    [self repositionBall];
}

-(void)pushTheBall:(CGFloat)angle{
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.basketball] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.005;
    self.pushBehavior.angle = angle;
    [self.animator addBehavior:self.pushBehavior];
}

-(void)repositionBall{
    [self.view removeConstraints:self.view.constraints];
    self.basketball.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.basketball.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.basketball.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.basketball.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10].active = YES;
    [self.basketball.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:30].active = YES;
    
}

@end
