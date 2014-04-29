//
// Created by Alexander Scott on 29/04/2014.
// Copyright (c) 2014 CADCoder. All rights reserved.
//

#import "BeatView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation BeatView {
    NSMutableArray *trackedTouches;

    SystemSoundID chinaSoundID;
    SystemSoundID crashSoundID;
    SystemSoundID hiHatSoundID;
    SystemSoundID kickSoundID;
    SystemSoundID rideSoundID;
    SystemSoundID snareSoundID;


}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        trackedTouches = [[NSMutableArray alloc] init];
        [self setMultipleTouchEnabled:YES];
        NSLog(@"Initialising BeatView");



        //Init all the sounds

        NSBundle *main = [NSBundle mainBundle];
        NSString *path = [main pathForResource:@"china" ofType:@"wav"];
        CFURLRef ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &chinaSoundID);

        path = [main pathForResource:@"crash" ofType:@"wav"];
        ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &crashSoundID);

        path = [main pathForResource:@"hi_hat" ofType:@"wav"];
        ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &hiHatSoundID);

        path = [main pathForResource:@"kick" ofType:@"wav"];
        ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &kickSoundID);

        path = [main pathForResource:@"ride" ofType:@"wav"];
        ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &rideSoundID);

        path = [main pathForResource:@"snare" ofType:@"wav"];
        ref = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID(ref, &snareSoundID);
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesBegan:touches withEvent:event];

    for (UITouch *t in touches) {
        [self startTrackingFor:t];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesEnded:touches withEvent:event];

    for (UITouch *t in touches) {
        [self stopTrackingFor:t];
    }
}


- (void)startTrackingFor:(UITouch *)touch {
    if (![trackedTouches containsObject:touch]) {
        [trackedTouches addObject:touch];
        NSLog(@"Tracking Touch.");

        CGPoint location = [touch locationInView:self];
        [self playSound:location];
    }
}

- (void)stopTrackingFor:(UITouch *)touch {
    if ([trackedTouches containsObject:touch]) {
        [trackedTouches removeObject:touch];
        NSLog(@"Stopped Tracking Touch.");
    }
}

- (void)playSound:(CGPoint)location {

    int thirdScreenHeight = (int) [self bounds].size.height / 3;

    int halfScreenWidth = (int) [self bounds].size.width / 2;

    int column = (int) location.x / halfScreenWidth;
    int row = (int) location.y / thirdScreenHeight;

    SystemSoundID toPlayID = 0;
    NSLog(@"Row: %d, Column: %d", row, column);

    if (column == 0) {
        switch (row) {
            case 0:
                toPlayID = rideSoundID;
                NSLog(@"Ride");
                break;
            case 1:
                toPlayID = chinaSoundID;
                NSLog(@"China");
                break;
            case 2:
                NSLog(@"Kick");
                toPlayID = kickSoundID;
                break;
        }
    } else {
        switch (row) {
            case 0:
                NSLog(@"Crash");
                toPlayID = crashSoundID;
                break;
            case 1:
                NSLog(@"HiHat");
                toPlayID = hiHatSoundID;
                break;
            case 2:
                NSLog(@"Snare");
                toPlayID = snareSoundID;
                break;
        }

    }

    if (toPlayID != 0) {
        AudioServicesPlaySystemSound(toPlayID);
    }

}

@end