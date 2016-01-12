//
//  Keyboard.h
//  Morse Keyboard
//
//  Created by Jack STENGLEIN on 11/15/14.
//  Copyright (c) 2014 Jack STENGLEIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Keyboard : UIView
@property (weak, nonatomic) IBOutlet UIButton *deleteKey;
@property (weak, nonatomic) IBOutlet UIButton *returnKey;
@property (weak, nonatomic) IBOutlet UIButton *globeKey;
@property (weak, nonatomic) IBOutlet UIButton *spaceKey;
@property (weak, nonatomic) IBOutlet UIButton *shiftKey;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keysArray;
@end
