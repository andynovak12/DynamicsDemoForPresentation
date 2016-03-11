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
    [self.animator addBehavior:gravityBehavior];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end