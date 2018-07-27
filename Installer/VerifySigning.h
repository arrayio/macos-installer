//
//  VerifySigning.h
//  Installer
//
//  Created by Mikhail Lutskiy on 19.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ObjectivePGP/ObjectivePGP.h>

@interface VerifySigning : NSObject
    
    + (BOOL) isVerifyFile:(NSData *) fileData withSignatureData: (NSData*)signatureData withKeys:(NSArray<PGPKey *> *)keys;

@end
