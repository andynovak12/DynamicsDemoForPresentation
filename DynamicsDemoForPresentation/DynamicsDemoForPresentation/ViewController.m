#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *basketball;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the animator.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (IBAction)basketballTapped:(id)sender {
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.basketball]];
//    gravityBehavior.magnitude = 40;
    
     UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[self.basketball]];
    
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    collision.collisionMode = UICollisionBehaviorModeEverything;
    
    collision.collisionDelegate = self;
    
    UIDynamicItemBehavior *ballDynamic = [[UIDynamicItemBehavior alloc]initWithItems:@[self.basketball]];
    
    ballDynamic.elasticity = 1.0;
    
    [self.animator addBehavior:ballDynamic];
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:collision];
}

@end