//
//  eBooksUserRegistTableViewCell.m
//  it-eBooks
//
//  Created by 王落凡 on 15/10/28.
//  Copyright © 2015年 王落凡. All rights reserved.
//

#import "eBooksCategoryChooseTableViewController.h"
#import "eBooksTools.h"
#import "eBooksUserRegistTableViewCell.h"
#import "eBooksUserHeaderView.h"

#define kControlMargin 5

@implementation eBooksUserRegistTableViewCell

-(instancetype)initWithInfoDict:(NSDictionary *)infoDict {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        switch ([infoDict[@"Type"] integerValue]) {
            case Cell_Type_HeaderImage:
            {
                self.contentControl = nil;
                self.userHeaderView = [[eBooksUserHeaderView alloc] initWithFrame:self.contentView.bounds];
                [self.userHeaderView setIsOnlyChangeHeader:YES];
                [self.userHeaderView.usernameLabel removeFromSuperview];
                [self.userHeaderView.messageLabel removeFromSuperview];
                [self.contentView addSubview:self.userHeaderView];
            }
                break;
            case Cell_Type_TextField:
            {
                self.contentControl = [[UITextField alloc] init];
                [((UITextField*)self.contentControl) setPlaceholder:infoDict[@"Text"]];
                [((UITextField*)self.contentControl) setDelegate:self];
            }
                break;
            case Cell_Type_Alphabet:
            {
                self.contentControl = [[UITextField alloc] init];
                [((UITextField*)self.contentControl) setPlaceholder:infoDict[@"Text"]];
                [((UITextField*)self.contentControl) setDelegate:self];
                [((UITextField*)self.contentControl) setKeyboardType:UIKeyboardTypeAlphabet];
            }
                break;
            case Cell_Type_Password_TextField:
            {
                self.contentControl = [[UITextField alloc] init];
                [((UITextField*)self.contentControl) setSecureTextEntry:YES];
                [((UITextField*)self.contentControl) setPlaceholder:infoDict[@"Text"]];
                [((UITextField*)self.contentControl) setDelegate:self];
            }
                break;
            case Cell_Type_SegmentControl:
            {
                self.contentControl = [[UISegmentedControl alloc] initWithItems:(NSArray*)infoDict[@"Options"]];
                [((UISegmentedControl*)self.contentControl) setSelectedSegmentIndex:0];
                [((UISegmentedControl*)self.contentControl) setTintColor:[UIColor redColor]];
            }
                break;
            case Cell_Type_NumberPad:
            {
                self.contentControl = [[UITextField alloc] init];
                [((UITextField*)self.contentControl) setKeyboardType:UIKeyboardTypeNumberPad];
                [((UITextField*)self.contentControl) setPlaceholder:infoDict[@"Text"]];
                [((UITextField*)self.contentControl) setDelegate:self];
            }
                break;
            case Cell_Type_DatePicker:
            {
                self.contentControl = [[UITextField alloc] init];
                UIDatePicker* datePicker = [[UIDatePicker alloc] init];
                [datePicker setDatePickerMode:UIDatePickerModeDate];
                [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                [((UITextField*)self.contentControl) setInputView:datePicker];
                [((UITextField*)self.contentControl) setPlaceholder:infoDict[@"Text"]];
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [((UITextField*)self.contentControl) setText:[formatter stringFromDate:[NSDate date]]];
            }
                break;
            case Cell_Type_Button:
            {
                self.contentControl = [UIButton buttonWithType:UIButtonTypeCustom];
                [((UIButton*)self.contentControl) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [((UIButton*)self.contentControl).layer setBorderWidth:1.0f];
                [((UIButton*)self.contentControl).layer setBorderColor:[[UIColor redColor] CGColor]];
                [((UIButton*)self.contentControl).layer setCornerRadius:5.0f];
                [((UIButton*)self.contentControl) setClipsToBounds:YES];
                [((UIButton*)self.contentControl) setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [((UIButton*)self.contentControl) setTag:[infoDict[@"Tag"] integerValue]];
                [((UIButton*)self.contentControl) setTitle:infoDict[@"Text"] forState:UIControlStateNormal];
                [((UIButton*)self.contentControl) setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [((UIButton*)self.contentControl) setBackgroundImage:[eBooksTools imageFromColor:UIColorFromRGBA(255.0f, 0.0f, 0.0f, 0.5f)] forState:UIControlStateHighlighted];
                [((UIButton*)self.contentControl) addTarget:self action:@selector(gotoSelect:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
    }
    
    if(self.contentControl != nil) {
        [self.textLabel setText:infoDict[@"Title"]];
        [self.contentView addSubview:self.contentControl];
        [self.contentControl setEnabled:([infoDict[@"Enabled"] integerValue] == 1)];
        self.canThisDataBeNull = ([infoDict[@"Null"] integerValue] == 0 ? NO : YES);
        if([self.contentControl isKindOfClass:[UITextField class]]) {
            [((UITextField*)self.contentControl) setPlaceholder:[((UITextField*)self.contentControl).placeholder stringByAppendingString:(self.canThisDataBeNull ? @"(选填)" : @"(必填)")]];
        }
    }
    
    return self;
}

-(void)layoutSubviews {
    if(self.contentControl == nil) {
        [self.userHeaderView setFrame:self.contentView.bounds];
    }else{
        [self.textLabel setFrame:CGRectMake(0, 0, 70, self.contentView.bounds.size.height - 2*kControlMargin)];
        [self.contentControl setFrame:CGRectMake(self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 30, kControlMargin, self.contentView.bounds.size.width - 40 - self.textLabel.frame.origin.x - self.textLabel.frame.size.width, self.contentView.bounds.size.height - 2*kControlMargin)];
    }
    return [super layoutSubviews];
}

-(void)datePickerValueChanged:(UIDatePicker*)sender {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [((UITextField*)self.contentControl) setText:[formatter stringFromDate:sender.date]];
    if([self.delegate respondsToSelector:@selector(dateChanged:)])
        [self.delegate dateChanged:sender.date];
    return ;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)gotoSelect :(UIButton*)sender {
    UIResponder* responder = self.nextResponder;
    while(![responder isKindOfClass:[UIViewController class]])
        responder = responder.nextResponder;
    if(sender.tag == 1) {
        eBooksCategoryChooseTableViewController* categoryViewController = [[eBooksCategoryChooseTableViewController alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryChoiceCompleteNotification:) name:EBOOKS_NOTIFICATION_CATEGORY_CHOISE_COMPLETE object:nil];
        [[((UIViewController*)responder) navigationController] pushViewController:categoryViewController animated:YES];
    }
    return ;
}

-(void)categoryChoiceCompleteNotification:(NSNotification*)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@",notification.userInfo);
    return ;
}

@end
