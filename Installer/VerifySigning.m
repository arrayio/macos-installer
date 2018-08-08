//
//  VerifySigning.m
//  Installer
//
//  Created by Mikhail Lutskiy on 19.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

#import "VerifySigning.h"

@implementation VerifySigning
    
    + (BOOL)isVerifyFile:(NSData *)fileData withSignatureData:(NSData *)signatureData withKeys:(NSArray<PGPKey *> *)keys {
        @try {
            NSError *error = nil;
            BOOL isVerify = [ObjectivePGP verify:fileData withSignature:signatureData usingKeys:keys passphraseForKey:nil error:&error];
            return isVerify;
        } @catch (NSException *exc) {
            NSLog(@"%@", exc);
            return false;
        }
    }

@end
