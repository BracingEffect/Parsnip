#import "BEInfoController.h"

#import "BEInAppPurchaser.h"
#import "BEUI.h"
#import "UIViewController+Tools.h"
#import "UIDevice+Tools.h"


@interface BEInfoController ()

@end


@implementation BEInfoController
{
    UILabel *versionLabel;
    UILabel *copyrightLabel;
    UILabel *restoredLabel;
    UIImageView *logoView;
    UIButton *restoreButton;
    UIButton *rateButton;
}

static NSString *infoTitle;

+ (void)initialize
{
    infoTitle = [BEUI.theme stringForKey:@"Info.Title"];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = infoTitle;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:self.frameForView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.view.bounds;
    UIEdgeInsets insets = self.insetsForView;

    UIImage *logo = [BEUI.theme imageForKey:@"Info.LogoView.Image"];
    UIEdgeInsets logoMargin = [BEUI.theme edgeInsetsForKey:@"Info.LogoView.Margin"];
    logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    logoView.center = CGPointMake(frame.size.width / 2.0f, insets.top + logoMargin.top + (logo.size.height / 2.0f));

    UIEdgeInsets versionMargin = [BEUI.theme edgeInsetsForKey:@"Info.VersionLabel.Margin"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionLabel = [BEUI labelWithKey:@"Info.VersionLabel"];
    versionLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    [versionLabel sizeToFit];
    versionLabel.center = CGPointMake(frame.size.width / 2.0f,
                                      logoView.frame.origin.y + logoView.frame.size.height + versionMargin.top + (versionLabel.frame.size.height / 2.0f));

    BOOL requirePurchase = [BEUI.theme boolForKey:@"RequireInAppPurchase"];
    UIEdgeInsets restoreMargin = [BEUI.theme edgeInsetsForKey:@"Info.RestoreButton.Margin"];
    CGPoint restoreCenter = CGPointMake(frame.size.width / 2.0f,
                                       versionLabel.frame.origin.y + versionLabel.frame.size.height + restoreMargin.top);
    if (requirePurchase) {
        BOOL alreadyPurchased = [BEInAppPurchaser.parsnipPurchaser isProductPurchased:BEInAppPurchaserParsnipPro];
        restoreButton = [BEUI buttonWithKey:@"Info.RestoreButton" target:self action:@selector(onRestoreButtonTouch)];
        restoreButton.hidden = alreadyPurchased;
        restoreButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        restoreCenter = CGPointMake(frame.size.width / 2.0f,
                                    versionLabel.frame.origin.y + versionLabel.frame.size.height + restoreMargin.top + (restoreButton.frame.size.height / 2.0f));
        restoreButton.center = restoreCenter;

        restoredLabel = [BEUI labelWithKey:@"Info.RestoreButton.Title"];
        restoredLabel.hidden = !alreadyPurchased;
        restoredLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        restoredLabel.textAlignment = NSTextAlignmentCenter;
        restoredLabel.text = [NSString stringWithFormat:@"%@ Enabled", [BEUI.theme stringForKey:@"UpgradeName"]];
        [restoredLabel sizeToFit];
        restoredLabel.center = restoreCenter;
    }

    UIEdgeInsets rateMargin = [BEUI.theme edgeInsetsForKey:@"Info.RateButton.Margin"];
    rateButton = [BEUI buttonWithKey:@"Info.RateButton" target:self action:@selector(onRateButtonTouch)];
    rateButton.hidden = [BEInAppPurchaser.parsnipPurchaser isProductPurchased:BEInAppPurchaserParsnipPro];
    rateButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    rateButton.center = CGPointMake(frame.size.width / 2.0f,
                                    restoreCenter.y + restoredLabel.frame.size.height + rateMargin.top + (rateButton.frame.size.height / 2.0f));

    NSString *copyright = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"NSHumanReadableCopyright"];
    copyrightLabel = [BEUI labelWithKey:@"Info.CopyrightLabel"];
    copyrightLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.text = copyright;
    copyrightLabel.center = CGPointMake(frame.size.width / 2.0f, frame.size.height - (copyrightLabel.frame.size.height / 2.0f));

    [self.view addSubview:logoView];
    [self.view addSubview:versionLabel];
    [self.view addSubview:restoreButton];
    [self.view addSubview:restoredLabel];
    [self.view addSubview:rateButton];
    [self.view addSubview:copyrightLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:BEInAppPurchaserProductPurchasedNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    if ([productIdentifier isEqualToString:BEInAppPurchaserParsnipPro]) {
        if (restoredLabel.hidden && !restoreButton.hidden) {
            restoreButton.alpha = 1.0f;
            restoredLabel.alpha = 0.0f;
            restoredLabel.hidden = NO;
            [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
                restoreButton.alpha = 0.0f;
                restoredLabel.alpha = 1.0f;
            } completion:^(BOOL finished) {
                restoreButton.hidden = YES;
            }];
        }
    }
}

- (void)onRestoreButtonTouch
{
    [BEInAppPurchaser.parsnipPurchaser restoreCompletedTransactions];
}

- (void)onRateButtonTouch
{
    [UIDevice reviewInAppStore:[BEUI.theme stringForKey:@"AppID"]];
}

@end
