//
//  RaindropViewController.m
//  DynamicsDemoForPresentation
//
//  Created by Andy Novak on 3/11/16.
//  Copyright © 2016 Andy Novak. All rights reserved.
//

#import "RaindropViewController.h"

@interface RaindropViewController () <UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIButton *raindrop;
@property (weak, nonatomic) IBOutlet UIImageView *umbrella;
@property (nonatomic, strong) UIDynamicAnimator *animator;


@end


@implementation RaindropViewController

-(void)viewDidLoad{
    [super viewDidLoad];
//    
//    CGRect      buttonFrame = self.raindrop.frame;
//    buttonFrame.size = CGSizeMake(500, 70);
//    self.raindrop.frame = buttonFrame;

    
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}


- (IBAction)raindropTapped:(id)sender {
    while (YES) {
        // Setup the raindrop view.
        UIView *raindrop1 = [[UIView alloc] initWithFrame:CGRectMake(100.0, 100.0, 50.0, 50.0)];
        raindrop1.backgroundColor = [UIColor orangeColor];

        raindrop1.layer.borderColor = [UIColor blackColor].CGColor;
        raindrop1.layer.borderWidth = 0.0;
        [self.view addSubview:raindrop1];
//        UIGravityBehavior *gravityForInitialRaindrop = [[UIGravityBehavior alloc] initWithItems:@[raindrop1]];
//        [self.animator addBehavior:gravityForInitialRaindrop];
    }
    
    
    
    
    
    
    // gravity for initial raindrop
    UIGravityBehavior *gravityForInitialRaindrop = [[UIGravityBehavior alloc] initWithItems:@[self.raindrop]];
    [self.animator addBehavior:gravityForInitialRaindrop];

    //create collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.raindrop, self.umbrella]];
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    //make view collisionDelegate
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    //set properties of the raindrop
    UIDynamicItemBehavior *raindropBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.raindrop]];
//    raindropBehavior.elasticity = 1.0;
    raindropBehavior.resistance = 0.0;
    raindropBehavior.friction = 0.0;
    raindropBehavior.allowsRotation = YES;
    [self.animator addBehavior:raindropBehavior];

    //set properties of the umbrella
    UIDynamicItemBehavior *umbrellaBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.umbrella]];
    umbrellaBehavior.anchored = YES;
    umbrellaBehavior.allowsRotation = NO;
    [self.animator addBehavior:umbrellaBehavior];
    
}

// Pushes the button when it collides with paddle
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    if (item1 == self.raindrop && item2 == self.umbrella){
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.raindrop] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.angle = 30  ;
        pushBehavior.magnitude = 0.5;
        [self.animator addBehavior:pushBehavior];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
