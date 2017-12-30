//
//  JiveExternalURLEntityTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/16/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveContentTests.h"
#import "JiveExternalURLEntity.h"


@interface JiveExternalURLEntityTests : JiveContentTests

@property (nonatomic, readonly) JiveExternalURLEntity *externalURL;

@end


@implementation JiveExternalURLEntityTests

- (JiveExternalURLEntity *)externalURL {
    return (JiveExternalURLEntity *)self.content;
}

- (void)setUp
{
    [super setUp];
    self.object = [JiveExternalURLEntity new];
}

- (void)testType {
    XCTAssertEqualObjects(self.externalURL.type, @"url", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.externalURL.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.externalURL class], @"External url class not registered with JiveContent.");
}

- (void)initializeExternalURL {
    self.externalURL.url = [NSURL URLWithString:@"http://dummy.com"];
}

- (void)initializeAlternateExternalURL {
    self.externalURL.url = [NSURL URLWithString:@"http://alternate.net"];
}

- (void)testExternalURLToJSON {
    NSDictionary *JSON = [self.externalURL toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.externalURL.type, @"Wrong type");
    
    [self initializeExternalURL];
    
    JSON = [self.externalURL toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.externalURL.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveExternalURLEntityAttributes.url],
                         [self.externalURL.url absoluteString], @"Wrong url");
}

- (void)testExternalURLToJSON_alternate {
    [self initializeAlternateExternalURL];
    
    NSDictionary *JSON = [self.externalURL toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.externalURL.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveExternalURLEntityAttributes.url],
                         [self.externalURL.url absoluteString], @"Wrong url");
}

- (void)testExternalURLParsing {
    [self initializeExternalURL];
    
    id JSON = [self.externalURL persistentJSON];
    JiveExternalURLEntity *newExternalURL = [JiveExternalURLEntity objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertEqualObjects([newExternalURL.url absoluteString], [self.externalURL.url absoluteString]);
}

- (void)testExternalURLParsing_alternate {
    [self initializeAlternateExternalURL];
    
    id JSON = [self.externalURL persistentJSON];
    JiveExternalURLEntity *newExternalURL = [JiveExternalURLEntity objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertEqualObjects([newExternalURL.url absoluteString], [self.externalURL.url absoluteString]);
}

@end
