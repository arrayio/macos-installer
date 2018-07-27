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
        NSError *error = nil;
        BOOL isVerify = [ObjectivePGP verify:fileData withSignature:signatureData usingKeys:keys passphraseForKey:nil error:&error];
        NSLog(@"is verify %i %@", isVerify, error);
        if (error == nil) {
            return true;
        } else {
            return false;
        }
    }

@end
