//
//  EndPickerWithOccurrenceViewController.m
//  ChoreMate
//
//  Created by Jasdeep Gill on 7/23/20.
//  Copyright © 2020 jazgill. All rights reserved.
//

#import "EndPickerWithOccurrenceViewController.h"
#import "CMColor.h"

@interface EndPickerWithOccurrenceViewController ()

@property (strong, nonatomic) NSNumber *pickedOccurences;
@property (weak, nonatomic) IBOutlet UITextField *occurenceTextField;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIView *pickingBackground;

@end

@implementation EndPickerWithOccurrenceViewController

- (void)viewWillAppear:(BOOL)animated{
    if([self.type isEqual:@"recurring"]){
        self.pickingBackground.backgroundColor = [CMColor recurringTaskColor];
    }
    else if([self.type isEqual:@"rotational"]) {
        self.pickingBackground.backgroundColor = [CMColor rotationalTaskColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (IBAction)didEditField:(id)sender {
    [self.stepper setValue:self.occurenceTextField.text.doubleValue];
    self.numOfOccurences = @(self.occurenceTextField.text.doubleValue);
}


- (IBAction)stepperClicked:(UIStepper *)sender {
    [self.occurenceTextField setText: [NSString stringWithFormat:@"%0.0f", [sender value]]];
    self.numOfOccurences = @([sender value]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
