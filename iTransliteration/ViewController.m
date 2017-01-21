//
//  ViewController.m
//  iTransliteration
//
//  Created by Rajesh on 6/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "Connection.h"
#import "Transliteration.h"
#import "FPTextView.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    __weak IBOutlet UITextField *txtChooseLanguage;
    __weak IBOutlet FPTextView *txtTranslate;
    UIPickerView *pickerView;
    NSArray *arrLanguages;
    NSArray *arrLanguageCodes;
//    NSMutableDictionary *dictData;
    NSString *strCurrent;
    NSInteger iSelectedIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:.9]];
    iSelectedIndex = -1;

    [txtTranslate.lblPlaceHolder setText:@"Transliteration"];
    [txtTranslate.lblFloating setText:@"Enter text and leave a space to Transliterate"];
    strCurrent = @"";

    arrLanguages = [NSArray arrayWithObjects:@"Bengali", @"Greek",@"Gujarati",@"Hindi",@"Kannada",@"Malayalam",@"Marathi",@"Nepali",@"Oriya",@"Punjabi",@"Russian",@"Sanskrit",@"Serbian",@"Sinhalese",@"Tamil", @"Telugu",@"Tigrinya", nil];
    arrLanguageCodes = [NSArray arrayWithObjects:@"bn", @"el",@"gu",@"hi",@"kn",@"ml",@"mr",@"ne",@"or",@"pa",@"ru",@"sa",@"sr",@"si",@"ta", @"te",@"ti", nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = txtChooseLanguage.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1] CGColor],[[UIColor whiteColor] CGColor], nil];
    [txtChooseLanguage.layer insertSublayer:gradientLayer atIndex:0];
    [txtChooseLanguage setBackgroundColor:[UIColor clearColor]];
    [txtChooseLanguage.layer setCornerRadius:5];
    [txtChooseLanguage setTintColor:[UIColor clearColor]];
    [txtChooseLanguage setText:@"Tamil"];
    iSelectedIndex = [arrLanguageCodes indexOfObject:@"ta"];
    
    UILabel *lblDown = [[UILabel alloc] initWithFrame:CGRectMake(txtChooseLanguage.bounds.size.width - 30, 0, 30, 35)];
    [lblDown setBackgroundColor:[UIColor grayColor]];
    [lblDown setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [lblDown setTextAlignment:NSTextAlignmentCenter];
    [lblDown setText:@"▽"];
    [lblDown setFont:[UIFont boldSystemFontOfSize:15]];
    [lblDown setTextColor:[UIColor whiteColor]];
    [txtChooseLanguage addSubview:lblDown];
    
    UIView *vwInput = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 216)];
    [vwInput setBackgroundColor:[UIColor clearColor]];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"Cancel",nil)]];
    cancelButton.momentary = YES;
    cancelButton.frame =CGRectMake(10,10,60,32);
    cancelButton.tintColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelTapped) forControlEvents:UIControlEventValueChanged];
    [vwInput addSubview:cancelButton];
    
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:NSLocalizedString(@"Done",nil)]];
    doneButton.momentary = YES;
    doneButton.frame =CGRectMake(vwInput.bounds.size.width-70,10,60,32);
    doneButton.tintColor = [UIColor blackColor];
    [doneButton addTarget:self action:@selector(doneTapped) forControlEvents:UIControlEventValueChanged];
    [vwInput addSubview:doneButton];
    
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = vwInput.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:.96 green:.96 blue:.96 alpha:1] CGColor],[[UIColor whiteColor] CGColor], nil];
    [vwInput.layer insertSublayer:gradientLayer atIndex:0];
    [txtChooseLanguage setInputView:vwInput];
    CGRect rect  = vwInput.bounds;
    rect.origin.y = 35;
    rect.size.height = rect.size.height - 35;
    pickerView = [[UIPickerView alloc] initWithFrame:rect];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [vwInput addSubview:pickerView];

    [txtTranslate.layer setCornerRadius:5];
    [txtTranslate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [txtTranslate.layer setBorderWidth:.5];
}

- (void)doneTapped
{
    iSelectedIndex = [pickerView selectedRowInComponent:0];
    [txtChooseLanguage setText:[arrLanguages objectAtIndex:iSelectedIndex]];
    [self.view endEditing:YES];
}

- (void)cancelTapped
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches)
    {
        [self.view endEditing:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrLanguages count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDown = [[UILabel alloc] initWithFrame:CGRectMake(txtChooseLanguage.bounds.size.width - 30, 0, self.view.bounds.size.width, 38)];
    [lblDown setTextAlignment:NSTextAlignmentCenter];
    [lblDown setText:arrLanguages[row]];
    [lblDown setFont:[UIFont systemFontOfSize:18.]];
    [lblDown setTextColor:[UIColor darkGrayColor]];
    return lblDown;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@" "])
    {
        if (iSelectedIndex == -1)
        {
            strCurrent = @"";
            return YES;
        }
        [Connection sendAsyncRequestWithText:strCurrent andLanguageCode:[arrLanguageCodes objectAtIndex:iSelectedIndex] block:^(id response) {
            @try {
                NSString *strText = textView.text;
                Transliteration *transliteration = [[Transliteration alloc] initWithObject:response];
                strText = [strText stringByReplacingOccurrencesOfString:transliteration.strText withString:transliteration.arrTransliteration[0]];
                [textView setText:strText];
            }
            @catch (NSException *exception) {
                NSLog(@"%@",exception.description);
            }
            @finally {
                
            }
        }];
        strCurrent = @"";
    }
    else
    {
        strCurrent = [strCurrent stringByAppendingString:text];
    }
    return YES;
}

@end
