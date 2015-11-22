//
//  ViewController.m
//  ImageBlend
//
//  Created by Lion0324 on 11/19/15.
//  Copyright © 2015 Lion0324. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+OrientationFix.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"



@interface ViewController () <UIImagePickerControllerDelegate>
{
    MBProgressHUD           *mProgress;

}
/// The interstitial ad.

@property (strong, nonatomic) UIImagePickerController * imagePickerController;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Blending";
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Accessors

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) { /* Lazy Loading */
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - IBActions

- (IBAction)takePhotoBtn:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)chooseFromGalleryBtn:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Private

- (void)setupWithImage:(UIImage*)image {
    UIImage * fixedImage = [image imageWithFixedOrientation];
    [AppDelegate sharedInstance].g_photoImage = fixedImage;
    
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(goEditingView) userInfo:nil repeats:NO];
    
    [self goEditingView];
}

-(void) goEditingView
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectFlagViewController"];
    [self.navigationController pushViewController:vc animated:NO];

}

#pragma mark - Protocol Conformance


#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Dismiss the imagepicker
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self setupWithImage:info[UIImagePickerControllerOriginalImage]];
}


@end
