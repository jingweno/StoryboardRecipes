//
//  PRPRecipeEditorViewController.m
//  StoryboardRecipes
//
//  Created by Owen on 2012-09-06.
//  Copyright (c) 2012 Owen. All rights reserved.
//

#import "PRPRecipeEditorViewController.h"
#import "PRPRecipe.h"

@interface PRPRecipeEditorViewController ()

@end

@implementation PRPRecipeEditorViewController

@synthesize recipe;
@synthesize titleField;
@synthesize directionsText;
@synthesize prepTimeLabel;
@synthesize recipeImage;
@synthesize prepTimeStepper;
@synthesize formatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.formatter = [[NSNumberFormatter alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.formatter = nil;
    self.prepTimeStepper = nil;
    self.recipeImage = nil;
    self.prepTimeLabel = nil;
    self.directionsText = nil;
    self.titleField = nil;
    self.recipe = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.titleField.text = self.recipe.title;
    self.directionsText.text = self.recipe.directions;
    self.prepTimeLabel.text = [self.formatter
                               stringFromNumber:self.recipe.preparationTime];
    self.prepTimeStepper.value = [self.recipe.preparationTime doubleValue];
    if(nil != self.recipe.image) {
        self.recipeImage.image = self.recipe.image;
    }
}

- (IBAction)changePreparationTime:(UIStepper *)sender {
    NSInteger value = (NSInteger)[sender value];
    self.recipe.preparationTime = [NSNumber numberWithInteger:value];
    self.prepTimeLabel.text =
    [self.formatter stringFromNumber:self.recipe.preparationTime];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.recipe.title = textField.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([@"editDirections" isEqualToString:segue.identifier]) {
        [[segue destinationViewController] setRecipe:recipe];
    }
    
    if([@"choosePhoto" isEqualToString:segue.identifier]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.recipe.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
    [self.recipeListVC finishedEditingRecipe:self.recipe];
}

@end