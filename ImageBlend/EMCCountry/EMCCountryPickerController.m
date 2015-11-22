//
//  EMCChooseCountryViewControllerManual.m
//  EMCCountryPickerController
//
//  Created by Enrico Maria Crisostomo on 12/05/14.
//  Copyright (c) 2014 Enrico M. Crisostomo. All rights reserved.
//

#import "EMCCountryPickerController.h"
#import "UIImage+UIImage_EMCImageResize.h"
#import "EMCCountryManager.h"
#import "AppDelegate.h"

#if !__has_feature(objc_arc)
#error This class requires ARC support to be enabled.
#endif

static const CGFloat kEMCCountryCellControllerMinCellHeight = 25;

@interface EMCCountryPickerController () 
{
    EMCCountry * _selectedCountry;
    NSArray *_countries;
    NSArray *_countrySearchResults;
}

@property (strong, nonatomic) IBOutlet     UITableView *countryTable;

@end


@implementation EMCCountryPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self loadDefaults];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self validateSettings];
    [self loadCountries];
    
    [self.countryTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];

    
    UIButton *unlockProBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [unlockProBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [unlockProBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [unlockProBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [unlockProBtn.titleLabel setFont:[UIFont fontWithName:@"Arial-Bold" size:12.0f]];
    
    [unlockProBtn setBackgroundColor:[UIColor clearColor]];
    [unlockProBtn addTarget:self action:@selector(leftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    unlockProBtn.frame = CGRectMake(0, 0, 60, 30);
    unlockProBtn.layer.cornerRadius = 0.0f;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:unlockProBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    
    /////lgilgilgi
    self.countryTable.backgroundColor =[UIColor clearColor];
    self.countryTable.opaque = NO;
    self.countryTable.backgroundView = nil;
    
    
    
}


- (void)leftBarButtonItemTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ////
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadCountrySelection];
}

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    
//    if(!IS_IOS8)
//    {
//        self.view.superview.bounds = CGRectMake(0, 0, 512, 512);
//        self.view.layer.cornerRadius = 8.0f;
//        self.view.superview.layer.cornerRadius = 10.0f;
//    }
//}

- (void)loadCountrySelection
{
    if (!_selectedCountry)
        return;
    
    [self.countryTable reloadData];
    
    NSUInteger selectedObjectIndex = [_countries indexOfObject:_selectedCountry];
    
    if (selectedObjectIndex != NSNotFound)
    {
        NSIndexPath * ip = [NSIndexPath indexPathForItem:selectedObjectIndex inSection:0];
        [self.countryTable selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Settings Management


- (void)loadDefaults
{
    self.showFlags = true;
    self.drawFlagBorder = true;
    self.flagBorderColor = [UIColor grayColor];
    self.flagBorderWidth = 0.5f;
    ///lgilgilgi
    self.flagSize = 120.0f;
}

- (void)validateSettings
{
    if (self.flagSize <= 0)
    {
        [NSException raise:@"Invalid flag size." format:@"Invalid flag size: %f.", self.flagSize];
    }
}

#pragma mark - Table View Management

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_countrySearchResults count];
    }
    
    // Return the number of rows in the section.
    return [_countries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        _selectedCountry = [_countrySearchResults objectAtIndex:indexPath.row];
        [self loadCountrySelection];
    }
    else
    {
        _selectedCountry = [_countries objectAtIndex:indexPath.row];
        ////lgilgilgi
        
        NSString *countryCode = [_selectedCountry countryCode];
        UIImage *v_image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg", countryCode]] fitInSize:CGSizeMake(self.flagSize, self.flagSize)];
        
        [AppDelegate sharedInstance].g_flagImage = v_image;
        
        [self.navigationController popViewControllerAnimated:NO];

        if( self.delegate != nil )
        {
            if( [self.delegate respondsToSelector:@selector(countryController:didSelectCountry:)] )
                [self.delegate countryController:self didSelectCountry:v_image];
        }     

    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    
    EMCCountry *currentCountry;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        currentCountry = [_countrySearchResults objectAtIndex:indexPath.row];
    }
    else
    {
        currentCountry = [_countries objectAtIndex:indexPath.row];
    }
    
    NSString *countryCode = [currentCountry countryCode];
    
    if (self.countryNameDisplayLocale)
    {
        cell.textLabel.text = [currentCountry countryNameWithLocale:self.countryNameDisplayLocale];
    }
    else
    {
        cell.textLabel.text = [currentCountry countryName];
    }
    
    
    // Resize flag
    if (self.showFlags)
    {
        cell.imageView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg", countryCode]] fitInSize:CGSizeMake(self.flagSize, self.flagSize)];
    }
    
    // Draw a border around the flag view if requested
    if (self.drawFlagBorder)
    {
        cell.imageView.layer.borderColor = self.flagBorderColor.CGColor;
        cell.imageView.layer.borderWidth = self.flagBorderWidth;
    }
    
    if (_selectedCountry && [_selectedCountry isEqual:currentCountry])
    {
        NSLog(@"Selection is %ld:%ld.", (long)tableView.indexPathForSelectedRow.section, (long)tableView.indexPathForSelectedRow.row);
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.flagSize < tableView.rowHeight)
    {
        return MAX(self.flagSize, kEMCCountryCellControllerMinCellHeight);
    }
    
    return MAX(tableView.rowHeight, self.flagSize);
}


#pragma mark - Country Management

- (void)chooseCountry:(EMCCountry *)chosenCountry;
{
    _selectedCountry = chosenCountry;
}

- (NSArray *)filterAvailableCountries:(NSSet *)countryCodes
{
    EMCCountryManager *countryManager = [EMCCountryManager countryManager];
    NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:[countryCodes count]];
    
    for (id code in self.availableCountryCodes)
    {
        if ([countryManager existsCountryWithCode:code])
        {
            [countries addObject:[countryManager countryWithCode:code]];
        }
        else
        {
            [NSException raise:@"Unknown country code"
                        format:@"Unknown country code %@", code];
        }
    }
    
    return countries;
}

- (void)loadCountries
{
    NSArray *availableCountries;
    
    if (self.availableCountryCodes)
    {
        availableCountries = [self filterAvailableCountries:self.availableCountryCodes];
    }
    else
    {
        availableCountries = [[EMCCountryManager countryManager] allCountries];
    }
    
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"countryName" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];
    _countries = [availableCountries sortedArrayUsingDescriptors:descriptors];
}

//- (IBAction)onClose:(id)sender
//{
//    /////
//    if( self.delegate != nil )
//    {
//        if( [self.delegate respondsToSelector:@selector(disappearSelectionActionDialog:)] )
//            [self.delegate disappearSelectionActionDialog:self];
//    }
//    
//}
//
//- (IBAction)onDone:(id)sender
//{
//    /////
//    if( self.delegate != nil )
//    {
//        if( [self.delegate respondsToSelector:@selector(countryController:didSelectCountry:)] )
//            [self.delegate countryController:self didSelectCountry:_selectedCountry];
//    }
//}



@end
