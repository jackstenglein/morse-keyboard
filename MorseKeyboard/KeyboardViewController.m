//
//  KeyboardViewController.m
//  MorseKeyboard
//
//  Created by Jack STENGLEIN on 11/15/14.
//  Copyright (c) 2014 Jack STENGLEIN. All rights reserved.
//

#import "KeyboardViewController.h"
#import "Keyboard.h"

NSMutableString *letterInMorse; //holds the morse code being typed
NSDictionary *morseEnglish; //contains English values for Morse Code keys
BOOL shift;
BOOL capslock;
@interface KeyboardViewController ()
@property (strong,nonatomic) Keyboard *keyboard;
@end

@implementation KeyboardViewController

#pragma mark Keyboards
- (void)addGesturesToKeyboard{
    [self.keyboard.deleteKey addTarget:self action:@selector(pressDeleteKey) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard.spaceKey addTarget:self action:@selector(pressSpaceKey:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard.returnKey addTarget:self action:@selector(pressReturnKey) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard.shiftKey addTarget:self action:@selector(pressShiftKey:event:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboard.globeKey addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside]; //goes to next keyboard
    
    for(UIButton *key in self.keyboard.keysArray)
    {
        [key addTarget:self action:@selector(pressKey:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)pressDeleteKey{ //deletes last character from text box and letterInMorse
    [self.textDocumentProxy deleteBackward];
    if((letterInMorse.length)!=0)
        [letterInMorse deleteCharactersInRange:NSMakeRange([letterInMorse length]-1, 1)];
}
- (void)pressSpaceKey:(id)sender event:(UIEvent *)event { //converts to English if one tap, converts and adds space if double tapped
    
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount==3){
        self.switchLetterToEnglish;
        [self.textDocumentProxy deleteBackward];
        [self.textDocumentProxy insertText: @". "];
    }
    else if(touch.tapCount==2){
        self.switchLetterToEnglish; //converts last letter to English
        [self.textDocumentProxy insertText: @" "]; //inserts a space
    }
    else if(touch.tapCount==1){
        self.switchLetterToEnglish; //converts last letter to English
    }
}
- (void)pressReturnKey{
    [self.textDocumentProxy insertText: @"\n"];
    
}
- (void)switchLetterToEnglish{ //deletes letter in morse code, inserts letter in English
    
    if([morseEnglish objectForKey:letterInMorse]!=nil) //checks to see if inserted text is in dictionary
    {
        for(int i=0; i<letterInMorse.length; i++)
        {
            [self.textDocumentProxy deleteBackward]; //cycles through inserted text and deletes it
        }
        
        NSString *english = [morseEnglish valueForKey: letterInMorse]; //gets English value for inserted morse code
        if(capslock==YES){ //checks if capslock is on
            NSString *finalEnglish = [english capitalizedString];
            [self.textDocumentProxy insertText: finalEnglish]; //capitalizes, inserts English letter
            [letterInMorse setString: @""]; //resets inserted Morse code
        }
        else{ //capslock off
            if(shift==YES){ //checks if shift is on
                NSString *finalEnglish = [english capitalizedString];
                [self.textDocumentProxy insertText: finalEnglish]; //capitalizes, inserts English letter
            }
            else{ //shift is off
                [self.textDocumentProxy insertText: english]; //inserts English letter uncapitalized
            }
            
            [letterInMorse setString: @""]; //resets inserted Morse code
            shift=NO;
            [self.keyboard.shiftKey setImage: [UIImage imageNamed: @"shift off.png"] forState: UIControlStateNormal];
        }
    }
}
- (void)pressShiftKey:(id)sender event:(UIEvent *)event { //turns shift on or off, changes button image
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount==2){ //checks to see if button was tapped twice
            [self.keyboard.shiftKey setImage: [UIImage imageNamed: @"capslock on.png"] forState: UIControlStateNormal];
            capslock=YES;
    }
    else if(touch.tapCount==1){ //button was tapped once
        if(capslock==YES) //check if capslock is on
        {
            capslock=NO;
            shift=NO;
            [self.keyboard.shiftKey setImage: [UIImage imageNamed: @"shift off.png"] forState: UIControlStateNormal];
        }
        else if(shift==NO) //check if capslock is off and shift is off
        {
            shift=YES;
            [self.keyboard.shiftKey setImage: [UIImage imageNamed: @"shift on.png"] forState: UIControlStateNormal];
        }
        else{ //shift is on
            shift=NO;
            [self.keyboard.shiftKey setImage: [UIImage imageNamed: @"shift off.png"] forState: UIControlStateNormal];
        }
    }
}
- (void)pressKey:(UIButton *)key{ //inserts dots and dashes
    [self.textDocumentProxy insertText: [key currentTitle]];
    [letterInMorse appendString: [key currentTitle]];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    // Add custom view sizing constraints here
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    letterInMorse = [[NSMutableString alloc] init];
    [letterInMorse setString: @""];
    NSArray *lettersInEnglish;
    lettersInEnglish = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@".",@",",@"?",@"!", nil];
    
    NSArray *lettersInMorse;
    lettersInMorse = [NSArray arrayWithObjects: @".—",@"—...",@"—.—.",@"—..",@".",@"..—.",@"——.",@"....",@"..",@".———",@"—.—",@".—..",@"——",@"—.",@"———",@".——.",@"——.—",@".—.",@"...",@"—",@"..—",@"...—",@".——",@"—..—",@"—.——",@"——..",@".————",@"..———",@"...——",@"....—",@".....",@"—....",@"——...",@"———..",@"————.",@"—————",@".—.—.—",@"——..——",@"..——..",@"—.—.——",nil];
    morseEnglish = [NSDictionary dictionaryWithObjects: lettersInEnglish forKeys: lettersInMorse]; //creates Morse to English dictionary
    shift=YES;
    capslock=NO;
    self.keyboard = [[[NSBundle mainBundle] loadNibNamed:@"Keyboard" owner:nil options:nil] objectAtIndex:0];
    [self addGesturesToKeyboard];
    self.inputView = self.keyboard;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}
- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}
- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}
@end