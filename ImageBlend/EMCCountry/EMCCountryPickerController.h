//
//  EMCChooseCountryViewControllerManual.h
//  EMCCountryPickerController
//
//  Created by Enrico Maria Crisostomo on 12/05/14.
//  Copyright (c) 2014 Enrico M. Crisostomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMCCountryDelegate.h"
#import "EMCCountry.h"

@protocol EMCCountryPickerControllerDelegate;

@interface EMCCountryPickerController : UIViewController<UITableViewDataSource, UITableViewDelegate>

- (void)chooseCountry:(EMCCountry *)chosenCountry;

@property (nonatomic, assign) id<EMCCountryPickerControllerDelegate> delegate;

@property (copy) NSSet *availableCountryCodes;
@property NSLocale *countryNameDisplayLocale;
@property BOOL showFlags;
@property BOOL drawFlagBorder;
@property CGFloat flagSize;
@property UIColor *flagBorderColor;
@property CGFloat flagBorderWidth;

@end

@protocol EMCCountryPickerControllerDelegate <NSObject>
@optional
- (void)appearSelectionActionDialog:(EMCCountryPickerController *)countryController;
- (void)disappearSelectionActionDialog:(EMCCountryPickerController *)countryController;
- (void)countryController:(id)sender didSelectCountry:(UIImage*)countryFlag;
@end