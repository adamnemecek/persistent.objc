//
//  AAPersistentVectorClass.m
//  Persistent
//
//  Created by Anton Astashov on 04/10/14.
//  Copyright (c) 2014 Anton Astashov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "AAPersistentVector.h"
#import "AATransientVector.h"

@interface AAPersistentVectorClass : XCTestCase
@end

@implementation AAPersistentVectorClass

-(void)testPushPop {
    AAPersistentVector *v = [[AAPersistentVector alloc] init];
    for (int i = 0; i < 72; i += 1) { v = [v push:@(i)]; }
    for (int i = 0; i < 67; i += 1) { v = [v pop]; }
    for (int i = 0; i < 70; i += 1) { v = [v push:@(i)]; }
    for (int i = 0; i < 65; i += 1) { v = [v pop]; }
    NSArray *expected = @[@(0), @(1), @(2), @(3), @(4), @(0), @(1), @(2), @(3), @(4)];
    XCTAssertEqualObjects([v asArray], expected);
}

-(void)testGet {
    AAPersistentVector *v = [[AAPersistentVector alloc] init];
    for (int i = 0; i < 72; i += 1) { v = [v push:@(i)]; }
    for (int i = 0; i < 72; i += 1) {
        XCTAssertEqualObjects([v get:i], @(i));
    }
}

-(void)testSet {
    AAPersistentVector *v = [[AAPersistentVector alloc] init];
    for (int i = 0; i < 72; i += 1) { v = [v push:@(i)]; }
    v = [v set:37 withValue:@(100500)];
    for (int i = 0; i < 72; i += 1) {
        XCTAssertEqualObjects([v get:i], i == 37 ? @(100500) : @(i));
    }
}

-(void)testAsTransient {
    AAPersistentVector *v = [[AAPersistentVector alloc] init];
    v = (AAPersistentVector *)[v withTransient:^(AATransientVector *transient) {
        AATransientVector* tmp = transient;
        for (int i = 0; i < 72; i += 1) { [tmp push:@(i)]; }
        [tmp set:50 withValue:@(123)];
        for (int i = 0; i < 10; i += 1) { [tmp pop]; }
        return tmp;
    }];
    XCTAssertEqual(v.size, 62);
    for (int i = 0; i < 62; i += 1) {
        XCTAssertEqual([v get:i], i == 50 ? @(123) : @(i));
    }
    XCTAssertEqual(v.size, 62);
}

-(void)testImmutability {
    AAPersistentVector *v = [[AAPersistentVector alloc] init];
    AAPersistentVector *a = (AAPersistentVector *)[v withTransient:^(AATransientVector *transient) {
        for (int i = 0; i < 100; i += 1) { [transient push:@(i)]; }
        return transient;
    }];
    AAPersistentVector *b = (AAPersistentVector *)[a withTransient:^(AATransientVector *transient) {
        for (int i = 0; i < 50; i += 1) { [transient pop]; }
        return transient;
    }];
    AAPersistentVector *c = (AAPersistentVector *)[b withTransient:^(AATransientVector *transient) {
        for (int i = 0; i < 25; i += 1) { [transient set:i withValue:@(i + 100)]; }
        return transient;
    }];
    AAPersistentVector *d = [a push:@(1000)];
    AAPersistentVector *e = [b pop];
    AAPersistentVector *f = [c set:10 withValue:@(2000)];

    XCTAssertEqual(v.size, 0);

    XCTAssertEqual(a.size, 100);
    for (int i = 0; i < 100; i += 1) {
        XCTAssertEqual([a get:i], @(i));
    }

    XCTAssertEqual(b.size, 50);
    for (int i = 0; i < 50; i += 1) {
        XCTAssertEqual([b get:i], @(i));
    }

    XCTAssertEqual(c.size, 50);
    for (int i = 0; i < 50; i += 1) {
        NSNumber *value = i < 25 ? @(i + 100) : @(i);
        XCTAssertEqual([c get:i], value);
    }

    XCTAssertEqual(d.size, 101);
    XCTAssertEqual([d get:100], @(1000));

    XCTAssertEqual(e.size, 49);

    XCTAssertEqual(f.size, 50);
    XCTAssertEqual([f get:10], @(2000));
}

@end
