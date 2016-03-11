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
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}


- (IBAction)raindropTapped:(id)sender {
    // gravity for initial raindrop
    UIGravityBehavior *gravityForInitialRaindrop = [[UIGravityBehavior alloc] initWithItems:@[self.raindrop]];
    [self.animator addBehavior:gravityForInitialRaindrop];

    //create collisions
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.raindrop, self.umbrella]];
    //makes our main view’s bounds work as boundaries for the items that will collide.
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//    [collisionBehavior addBoundaryWithIdentifier:@"tabbar" fromPoint:self.tabBarController.tabBar.frame.origin toPoint:CGPointMake(self.tabBarController.tabBar.frame.origin.x + self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.origin.y)];
    //dictates that all edges of items that participate to a collision will have the desired behavior.
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    //make view collisionDelegate
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
