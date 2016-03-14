//
//  HoopsViewController.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/11/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "HoopsViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import <ScoreboardLabel/ScoreboardLabel.swift>


@interface HoopsViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *basketball;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (weak, nonatomic) IBOutlet UIView *frontOfRim;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSUInteger score;
@property (weak, nonatomic) IBOutlet UIImageView *hoop;
@property (nonatomic) BOOL justScorred;

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
    
   
    
    //gravity for ball
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.basketball]];
    gravityBehavior.magnitude = 1.5;
    [self.animator addBehavior:gravityBehavior];
    
    //create collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.basketball, self.frontOfRim]];
    //makes our main view’s bounds work as boundaries for the items that will collide.
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //dictates that all edges of items that participate to a collision will have the desired behavior.
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;

//    collisionBehavior.collisionMode = UICollisionBehaviorModeItems;
    //make view collisionDelegate
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    


    //set the basketballs properties
    UIDynamicItemBehavior *ballDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.basketball]];
    ballDynamic.elasticity = 0.6;
    ballDynamic.resistance = 0;
    ballDynamic.allowsRotation = YES;
    [self.animator addBehavior:ballDynamic];
    
    //set the hoops properties
    UIDynamicItemBehavior *hoopDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.frontOfRim]];
    hoopDynamic.anchored = YES;
    [self.animator addBehavior:hoopDynamic];
    
//    [self repositionBall];
//    NSLog(@"BALL CCROSSED: %d, ", [self ballCrossedHoop]);
    
    gravityBehavior.action = ^{
        [self updateScore];
    };
    
    
    
    
}


- (IBAction)ballSwipped:(UIPanGestureRecognizer*)recognizer {
    if (UIGestureRecognizerStateBegan) {
        
        NSLog(@"SELF JUST SCORRED IS BEING SET TO NO!!!!");
        self.justScorred = NO;
        
        NSLog(@"started");
    }
    if (UIGestureRecognizerStateEnded){
        
        
        NSLog(@"GETTING CALLED!!!!!!!!!!!!!!!!!!!!!!!! stateEnded");
        
        CGPoint velocity = [recognizer velocityInView:[recognizer.view superview]];
        // If needed: CGFloat slope = velocity.y / velocity.x;
        CGFloat angle = atan2f(velocity.y, velocity.x);
        CGFloat velocityAsFloat = sqrt(pow(velocity.y,2)+pow(velocity.x, 2));
        
        //push the ball
        [self pushTheBallWithAngle:angle WithVelocity:velocityAsFloat];
        NSLog(@"%f", angle);
    }

}

-(void)pushTheBallWithAngle:(CGFloat)angle WithVelocity:(CGFloat)velocity{
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.basketball] mode:UIPushBehaviorModeInstantaneous];

    self.pushBehavior.magnitude = velocity/4000;
    self.pushBehavior.angle = angle;
    
//    [self.animator addBehavior:self.pushBehavior];
    [self.animator addBehavior:self.pushBehavior];

    NSLog(@"pushed");
    
}



-(BOOL)ballCrossedHoop{
    
    CGFloat delta = self.basketball.center.y - (self.hoop.center.y - self.hoop.frame.size.height/4);
    CGFloat deltaNonNegative = delta < 0 ? delta * -1 : delta;
    BOOL ballCrossedCenterY = deltaNonNegative < 30 ? YES : NO;
    
    BOOL ballLessThanRightHoop = (self.basketball.center.x < self.hoop.center.x +self.hoop.frame.size.width/2);
    BOOL ballGreaterThanLeftHoop = (self.basketball.center.x > self.hoop.center.x - self.hoop.frame.size.width/2);
    

    
    
    if (_justScorred) {
        
        NSLog(@"JUST SCORED IS YESSSSSS\n\n\n\n");
        
        return  NO;
        
    } else {
        

    BOOL scoreeeee = ballCrossedCenterY &&  ballLessThanRightHoop &&  ballGreaterThanLeftHoop;
        
        if (scoreeeee) {
            
            NSLog(@"GOALLL");
        }
    return scoreeeee;
        
    }
    
    
}

-(void)updateScore{
    
    
    BOOL ballCrossedHoopBool = [self ballCrossedHoop];
    if (ballCrossedHoopBool) {

        
        NSLog(@"SCOREEEEEEE");
        self.justScorred = YES;
        self.score ++;
        self.scoreLabel.text = [NSString stringWithFormat: @"%lu", self.score];
    }
}

@end
