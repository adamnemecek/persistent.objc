//
//  AABaseVector.h
//  Persistent
//
//  Created by Anton Astashov on 01/10/14.
//  Copyright (c) 2014 Anton Astashov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAIIterator.h"
#import "AAIPersistent.h"

// Abstract class
@interface AABaseVector : NSObject <NSFastEnumeration, AAIPersistent>

-(id)objectAtIndex:(NSUInteger)index;
-(instancetype)replaceObjectAtIndex:(NSUInteger)index withObject:(id)value;

-(instancetype)addObject:(id)value;
-(instancetype)removeLastObject;

-(NSUInteger)indexOfObject:(id)anObject;

-(NSArray *)toArray;

-(void)each:(void(^)(id))block;

// For debugging only :)
-(NSString *)internals;

-(BOOL)isEqualToVector:(AABaseVector *)vector;

-(id<AAIIterator>)iterator;

-(id)objectAt:(NSArray *)path;
-(instancetype)setAt:(NSArray *)path withValue:(id)value;
-(instancetype)removeAt:(NSArray *)path;
-(instancetype)addAt:(NSArray *)path withValue:(id)value;
-(instancetype)insertAt:(NSArray *)path withValue:(id)value;

@property(readonly, nonatomic) NSUInteger count;

@end