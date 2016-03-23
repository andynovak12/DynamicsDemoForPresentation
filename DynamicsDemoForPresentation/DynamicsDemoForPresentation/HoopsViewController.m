//
//  HoopsViewController.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/11/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "HoopsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <FBDigitalFont/FBBitmapFont.h>
#import <FBDigitalFont/FBBitmapFontView.h>

@interface HoopsViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *basketball;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (weak, nonatomic) IBOutlet UIView *frontOfRim;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSUInteger score;
@property (weak, nonatomic) IBOutlet UIImageView *hoop;
@property (nonatomic) BOOL justScorred;
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (strong, nonatomic) UIDynamicItemBehavior *ballDynamic;
@property (weak, nonatomic) IBOutlet UIView *backOfRim;
@property (strong, nonatomic) FBBitmapFontView *theNewGameView;
@property (nonatomic) CFAbsoluteTime lastTime;
@end


@implementation HoopsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.basketball.layer.cornerRadius = self.basketball.frame.size.height/2;
    self.basketball.clipsToBounds = YES;
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //setup scoreboard
    [self setupScoreboard];
    [self setupNewGame];
    
    //create touch gesture for newgame label
    UITapGestureRecognizer *newGameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newGameViewTapped:)];
    [self.theNewGameView addGestureRecognizer:newGameTap];
    self.theNewGameView.userInteractionEnabled = YES;

    
    //gravity for ball
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.basketball]];
    gravityBehavior.magnitude = 1.5;
    [self.animator addBehavior:gravityBehavior];
    
    //create collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.basketball, self.frontOfRim, self.backOfRim]];
    
    //makes our main view’s bounds work as boundaries for the items that will collide.
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    //dictates that all edges of items that participate to a collision will have the desired behavior.
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;

    //make view collisionDelegate
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];

    //set the basketballs properties
    self.ballDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.basketball]];
    self.ballDynamic.elasticity = 0.6;
    self.ballDynamic.resistance = 0.1;
    self.ballDynamic.friction = 0.5;
    self.ballDynamic.allowsRotation = YES;
    [self.animator addBehavior:self.ballDynamic];
    
    //set the hoops properties
    UIDynamicItemBehavior *hoopDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.frontOfRim, self.backOfRim]];
    hoopDynamic.anchored = YES;
    
    [self.animator addBehavior:hoopDynamic];
    
    gravityBehavior.action = ^{
        [self updateScore];
    };
}

- (IBAction)ballSwipped:(UIPanGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"SELF JUST SCORRED IS BEING SET TO NO!!!!");
        self.justScorred = NO;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        
        CGPoint velocity = [recognizer velocityInView:[recognizer.view superview]];
        CGFloat angle = atan2f(velocity.y, velocity.x);
        CGFloat velocityAsFloat = sqrt(pow(velocity.y,2)+pow(velocity.x, 2));
        
        //push the ball
        [self pushTheBallWithAngle:angle WithVelocity:velocityAsFloat];
    }
}



-(void)pushTheBallWithAngle:(CGFloat)angle WithVelocity:(CGFloat)velocity{
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.basketball] mode:UIPushBehaviorModeInstantaneous];

    self.pushBehavior.magnitude = velocity/700;
    self.pushBehavior.angle = angle;
    
    [self.animator addBehavior:self.pushBehavior];

}

-(BOOL)ballCrossedHoop{
    
    CGFloat delta = self.basketball.center.y - (self.hoop.center.y - self.hoop.frame.size.height/4);
    CGFloat deltaNonNegative = delta < 0 ? delta * -1 : delta;
    BOOL ballCrossedCenterY = deltaNonNegative < 10 ? YES : NO;
    
    BOOL ballLessThanRightHoop = (self.basketball.center.x < self.hoop.center.x +self.hoop.frame.size.width/2);
    BOOL ballGreaterThanLeftHoop = (self.basketball.center.x > self.hoop.center.x - self.hoop.frame.size.width/2);
    
    //check if ball is moving down or up when crosses
    CGPoint basketballVelocity = [self.ballDynamic linearVelocityForItem:self.basketball];
//    NSLog(@"x:%.3f  y:%.3f", basketballVelocity.x ,basketballVelocity.y);
    BOOL ballIsMovingDown = basketballVelocity.y > 0;
    
    if (self.justScorred) {
        return  NO;
    } else {
        BOOL crossedCorrectSpot = ballCrossedCenterY &&  ballLessThanRightHoop &&  ballGreaterThanLeftHoop;
        if (crossedCorrectSpot) {
            if (ballIsMovingDown) {
//                NSLog(@"GOALLL");
            }
            else {
                //dont count basket by making justScorred true
                self.justScorred = YES;
            }
            return ballIsMovingDown;
        }
        return crossedCorrectSpot;
    }
}

-(void)updateScore{
    
    
    BOOL ballCrossedHoopBool = [self ballCrossedHoop];
    if (ballCrossedHoopBool) {

        self.justScorred = YES;
        self.score ++;
        [self setupScoreboard];
    }
}

-(void)newGameViewTapped:(UITapGestureRecognizer *)recognizer{
    NSLog(@"new game tapped");
    self.score = 0;
    [self setupScoreboard];
}

- (void)setupScoreboard
{
    CGRect frame = CGRectMake(10, 60, 300, 50);
    FBBitmapFontView *v = [[FBBitmapFontView alloc] initWithFrame:frame];
    v.text = [NSString stringWithFormat: @"SCORE: %.2lu", self.score];
    v.numberOfBottomPaddingDot = 1;
    v.numberOfTopPaddingDot    = 1;
    v.numberOfLeftPaddingDot   = 2;
    v.numberOfRightPaddingDot  = 2;
    v.glowSize = 20.0;
    v.innerGlowSize = 3.0;
    v.edgeLength = 5.0;
    [self.view insertSubview:v belowSubview:self.basketball];
    [v resetSize];
}

- (void)setupNewGame
{
    CGRect frame = CGRectMake(10, 10, 300, 50);
    self.theNewGameView = [[FBBitmapFontView alloc] initWithFrame:frame];
    self.theNewGameView.text = @"RESET";
    self.theNewGameView.numberOfBottomPaddingDot = 1;
    self.theNewGameView.numberOfTopPaddingDot    = 1;
    self.theNewGameView.numberOfLeftPaddingDot   = 2;
    self.theNewGameView.numberOfRightPaddingDot  = 2;
    self.theNewGameView.glowSize = 20.0;
    self.theNewGameView.innerGlowSize = 3.0;
    self.theNewGameView.edgeLength = 1.0;
    [self.view insertSubview:self.theNewGameView belowSubview:self.basketball];
    [self.theNewGameView resetSize];
}



@end
