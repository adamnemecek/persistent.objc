//
//  AATransientVector.h
//  Persistent
//
//  Created by Anton Astashov on 03/10/14.
//  Copyright (c) 2014 Anton Astashov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AABaseVectorPrivate.h"

@interface AATransientVector : AABaseVector

-(instancetype)initWithSize:(NSUInteger)size level:(NSUInteger)level root:(AAVNode *)root tail:(AAVNode *)tail owner:(AAOwner *)owner;

@end
