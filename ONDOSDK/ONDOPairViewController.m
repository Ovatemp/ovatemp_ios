//
//  ONDOPairViewController.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDOPairViewController.h"

@interface ONDOPairViewController () <UIAlertViewDelegate> {
  ONDODevice *_device;
  UIImage *_pairing1;
  UIImage *_pairing2;
  UIImage *_pairing3;
}

@property UILabel *instructionsLabel;
@property UIImageView *bluetoothImageView;
@property UIImageView *pairingImageView;
@property UILabel *statusLabel;
@property UIImageView *thermometerImageView;

@end

static CGFloat const kStandardSpacing = 20.0f;

@implementation ONDOPairViewController

- (id)init {
  self = [super init];
  if (self) {
    // Set up the main view
    CGRect rect = [UIScreen mainScreen].bounds;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (UINavigationController *)buildNavigationController {
  if (!self.navigationController) {
    // Set up the title bar
    self.title = @"Pair ONDO";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close:)];

    return [[UINavigationController alloc] initWithRootViewController:self];
  }
  return self.navigationController;
}


- (IBAction)close:(id)sender {
  [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  if (!self.statusLabel.superview) {
    // Set up the status label
    CGRect rect = CGRectInset(self.view.frame, kStandardSpacing, kStandardSpacing);
    rect.origin.y = self.navigationController.navigationBar.frame.size.height + kStandardSpacing * 2;
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    self.statusLabel.text = @"Searching...";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    rect.size.height = [self.statusLabel sizeThatFits:rect.size].height;
    self.statusLabel.frame = rect;
    [self.view addSubview:self.statusLabel];

    // Set up the instructions label
    rect.origin.y = CGRectGetMaxY(rect) + kStandardSpacing;
    rect.size.height = CGFLOAT_MAX;
    self.instructionsLabel = [[UILabel alloc] init];
    self.instructionsLabel.font = [UIFont systemFontOfSize:self.statusLabel.font.pointSize - 2];
    self.instructionsLabel.numberOfLines = 0;
    self.instructionsLabel.text = @"Press ONDO's Activation Button for 5 seconds and wait until it beeps 3 times and the LED starts blinking yellow.";
    self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
    rect.size.height = [self.instructionsLabel sizeThatFits:rect.size].height;
    self.instructionsLabel.frame = rect;
    [self.view addSubview:self.instructionsLabel];

    UIImage *thermometerImage = [UIImage imageNamed:@"OndoPicture.png"];
    self.thermometerImageView = [[UIImageView alloc] initWithImage:thermometerImage];
    self.thermometerImageView.contentMode = UIViewContentModeCenter;
    rect.origin.y = CGRectGetMaxY(rect) + kStandardSpacing;
    rect.size.height = thermometerImage.size.height;
    self.thermometerImageView.frame = rect;
    [self.view addSubview:self.thermometerImageView];

    _pairing1 = [UIImage imageNamed:@"BluetoothSignal1.png"];
    _pairing2 = [UIImage imageNamed:@"BluetoothSignal2.png"];
    _pairing3 = [UIImage imageNamed:@"BluetoothSignal3.png"];

    rect.origin.y = CGRectGetMaxY(rect) + kStandardSpacing;
    CGFloat height = MAX(_pairing1.size.height, _pairing2.size.height);
    rect.size.height = MAX(height, _pairing3.size.height);
    self.pairingImageView = [[UIImageView alloc] initWithFrame:rect];
    self.pairingImageView.contentMode = UIViewContentModeBottom;
    self.pairingImageView.image = _pairing3;
    [self.view addSubview:self.pairingImageView];

    UIImage *bluetoothImage = [UIImage imageNamed:@"BluetoothIcon.png"];
    rect.origin.y = CGRectGetMaxY(rect) + kStandardSpacing;
    rect.size.height = bluetoothImage.size.height;
    self.bluetoothImageView = [[UIImageView alloc] initWithImage:bluetoothImage];
    self.bluetoothImageView.contentMode = UIViewContentModeTop;
    self.bluetoothImageView.frame = rect;
    [self.view addSubview:self.bluetoothImageView];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [ONDO pairDeviceWithDelegate:self];
  [self startAnimating];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self stopAnimating];
}

- (void)hideWithText:(NSString *)text {
  self.statusLabel.text = text;
  self.instructionsLabel.hidden = YES;
  self.pairingImageView.hidden = YES;
}

# pragma mark - Handling animation

- (void)startAnimating {
  if (self.pairingImageView.image == _pairing1) {
    self.pairingImageView.image = _pairing2;
  } else if (self.pairingImageView.image == _pairing2) {
    self.pairingImageView.image = _pairing3;
  } else {
    self.pairingImageView.image = _pairing1;
  }
  [self performSelector:@selector(startAnimating) withObject:nil afterDelay:0.5];
}

- (void)stopAnimating {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimating) object:nil];
}

# pragma mark - Handling delegate methods

- (void)ONDOsaysBluetoothIsDisabled:(ONDO *)ondo {
  if ([self.delegate respondsToSelector:@selector(ONDOsaysBluetoothIsDisabled:)]) {
    [self.delegate ONDOsaysBluetoothIsDisabled:ondo];
  }
  [self hideWithText:@"Bluetooth is not enabled"];
}

- (void)ONDOsaysLEBluetoothIsUnavailable:(ONDO *)ondo {
  if ([self.delegate respondsToSelector:@selector(ONDOsaysLEBluetoothIsUnavailable:)]) {
    [self.delegate ONDOsaysLEBluetoothIsUnavailable:ondo];
  }
  [self hideWithText:@"Device does not support Bluetooth LE"];
}

- (void)ONDO:(ONDO *)ondo didAddDevice:(ONDODevice *)device {
  if ([self.delegate respondsToSelector:@selector(ONDO:didAddDevice:)]) {
    [self.delegate ONDO:ondo didAddDevice:device];
  } else {
    _device = device;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New ONDO found!" message:@"You can personalize your ONDO thermometer if you'd like, by giving it a unique name" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Save", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
  }
}

- (void)ONDO:(ONDO *)ondo didConnectToDevice:(ONDODevice *)device {
  [self hideWithText:@"Paired!"];
  self.navigationItem.leftBarButtonItem.enabled = NO;

  if (!_device) {
    if ([self.delegate respondsToSelector:@selector(ONDO:didConnectToDevice:)]) {
      [self.delegate ONDO:ondo didConnectToDevice:device];
    }

    NSString *message = [NSString stringWithFormat:@"Ovatemp is already paired with %@", device.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Paired"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
  }
}

# pragma mark - Handling alerts

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (_device) {
    if (buttonIndex == 1) {
      NSString *name = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      if (name.length > 0) {
        _device.name = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [_device save];
      }
    }

    if ([self.delegate respondsToSelector:@selector(ONDO:didConnectToDevice:)]) {
      [self.delegate ONDO:[ONDO sharedInstance] didConnectToDevice:_device];
    }
  }

  [self close:nil];
}

@end
