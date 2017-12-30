//
//  JiveTermsAndConditionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTermsAndConditionsTests.h"
#import "JiveTermsAndConditions.h"

@implementation JiveTermsAndConditionsTests

- (void)setUp {
    [super setUp];
    self.object = [JiveTermsAndConditions new];
}

- (JiveTermsAndConditions *)termsAndConditions {
    return (JiveTermsAndConditions *)self.object;
}

- (void)testPersistentJSON {
    [self.termsAndConditions setValue:@YES forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:@"html goes here" forKey:JiveTermsAndConditionsAttributes.text];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual(JSON.count, (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.acceptanceRequired],
                         self.termsAndConditions.acceptanceRequired, @"Wrong acceptanceRequired.");
    XCTAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.text], self.termsAndConditions.text,
                         @"Wrong text.");
}

- (void)testPersistentJSON_alternate {
    [self.termsAndConditions setValue:@NO forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:[NSURL URLWithString:@"http://dummy.com"]
                               forKey:JiveTermsAndConditionsAttributes.url];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual(JSON.count, (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.acceptanceRequired],
                         self.termsAndConditions.acceptanceRequired, @"Wrong acceptanceRequired.");
    XCTAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.url],
                         self.termsAndConditions.url.absoluteString, @"Wrong url.");
}

- (void)testJiveTermsAndConditionsParsing {
    [self.termsAndConditions setValue:@YES forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:@"html goes here, really" forKey:JiveTermsAndConditionsAttributes.text];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    JiveTermsAndConditions *newTsAndCs = [JiveTermsAndConditions objectFromJSON:JSON
                                                                   withInstance:self.instance];
    
    XCTAssertEqual([newTsAndCs class], [JiveTermsAndConditions class], @"Wrong item class");
    XCTAssertEqualObjects(newTsAndCs.acceptanceRequired, self.termsAndConditions.acceptanceRequired,
                         @"Wrong acceptanceRequired");
    XCTAssertEqualObjects(newTsAndCs.text, self.termsAndConditions.text, @"Wrong text");
}

- (void)testJiveTermsAndConditionsParsingAlternate {
    [self.termsAndConditions setValue:@NO forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:[NSURL URLWithString:@"http://situation.com"]
                               forKey:JiveTermsAndConditionsAttributes.url];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    JiveTermsAndConditions *newTsAndCs = [JiveTermsAndConditions objectFromJSON:JSON
                                                                   withInstance:self.instance];
    
    XCTAssertEqual([newTsAndCs class], [JiveTermsAndConditions class], @"Wrong item class");
    XCTAssertEqualObjects(newTsAndCs.acceptanceRequired, self.termsAndConditions.acceptanceRequired,
                         @"Wrong acceptanceRequired");
    XCTAssertEqualObjects(newTsAndCs.url, self.termsAndConditions.url, @"Wrong url");
}

@end
