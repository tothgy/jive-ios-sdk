//
//  JiveAuthorableContentTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/18/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveAuthorableContentTests.h"


@interface MockJiveAuthorableContent : JiveAuthorableContent

@end

@interface JiveCategorizedContentTests (JiveAuthoreableContentTests)

- (void)testStructuredOutcomeContentParsing;
- (void)testStructuredOutcomeContentParsingAlternate;

@end


@implementation MockJiveAuthorableContent

- (NSString *)type {
    return @"For testing purposes only.";
}

@end

@implementation JiveAuthorableContentTests

- (void)setUp {
    [super setUp];
    self.object = [MockJiveAuthorableContent new];
}

- (JiveAuthorableContent *)authorableContent {
    return (JiveAuthorableContent *)self.categorizedContent;
}

- (void)initializeAuthorableContent {
    JivePerson *author = [JivePerson new];
    
    author.location = @"location";
    [author setValue:author.location forKey:JivePersonAttributes.displayName];
    self.authorableContent.authors = @[author];
    self.authorableContent.authorship = @"open";
}

- (void)initializeAlternateAuthorableContent {
    JivePerson *author = [JivePerson new];
    
    author.location = @"Subway";
    [author setValue:author.location forKey:JivePersonAttributes.displayName];
    self.authorableContent.authors = @[author];
    self.authorableContent.authorship = @"limited";
}

- (void)testAuthorableContentToJSON {
    NSDictionary *JSON = [self.authorableContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertNotNil(JSON[JiveTypedObjectAttributes.type], @"Wrong type");
    
    [self initializeAuthorableContent];
    
    JSON = [self.authorableContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.authorableContent.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveAuthorableContentAttributes.authorship],
                         self.authorableContent.authorship, @"Wrong authorship");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]],
                 @"Authors not converted: %@", [authorsJSON class]);
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Authors dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"Authors dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.authorableContent.authors[0]).location,
                         @"Wrong value");
}

- (void)testAuthorableContentToJSON_alternate {
    [self initializeAlternateAuthorableContent];
    
    NSDictionary *JSON = [self.authorableContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.authorableContent.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveAuthorableContentAttributes.authorship],
                         self.authorableContent.authorship, @"Wrong authorship");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.authorableContent.authors[0]).location,
                         @"Wrong value");
}

- (void)testToJSON_authors {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"location";
    person2.location = @"Tower";
    [self.authorableContent setValue:@[person1] forKey:JiveAuthorableContentAttributes.authors];
    
    NSDictionary *JSON = [self.authorableContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.authorableContent.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.authorableContent setValue:[self.authorableContent.authors arrayByAddingObject:person2]
                     forKey:JiveAuthorableContentAttributes.authors];
    
    JSON = [self.authorableContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.authorableContent.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testAuthorableContentPersistentJSON {
    NSDictionary *JSON = [self.authorableContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.authorableContent.type, @"Wrong type");
    
    [self initializeAuthorableContent];
    
    JSON = [self.authorableContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.authorableContent.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveAuthorableContentAttributes.authorship],
                         self.authorableContent.authorship, @"Wrong authorship");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.authorableContent.authors[0]).location, @"Wrong value");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.authorableContent.authors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentPersistentJSON_alternate {
    [self initializeAlternateAuthorableContent];
    
    NSDictionary *JSON = [self.authorableContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.authorableContent.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveAuthorableContentAttributes.authorship],
                         self.authorableContent.authorship, @"Wrong authorship");
    
    NSArray *authorsJSON = [JSON objectForKey:JiveAuthorableContentAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.authorableContent.authors[0]).location,
                         @"Wrong value");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.authorableContent.authors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentParsing {
    [self initializeAuthorableContent];
    
    self.authorableContent.users = nil;
    id JSON = [self.authorableContent persistentJSON];
    JiveAuthorableContent *newContent = [MockJiveAuthorableContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.authorableContent class]],
                 @"Wrong item class: %@", [newContent class]);
    XCTAssertEqualObjects(newContent.type, self.authorableContent.type, @"Wrong type");
    XCTAssertEqual([newContent.authors count], [self.authorableContent.authors count], @"Wrong number of author objects");
    XCTAssertEqualObjects(newContent.authorship, self.authorableContent.authorship, @"Wrong authorship");
    
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                                 ((JivePerson *)self.authorableContent.authors[0]).location, @"Wrong author object");
    }
}

- (void)testAuthorableContentParsing_alternate {
    [self initializeAlternateAuthorableContent];
    
    id JSON = [self.authorableContent persistentJSON];
    JiveAuthorableContent *newContent = [MockJiveAuthorableContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.authorableContent class]],
                 @"Wrong item class: %@", [newContent class]);
    XCTAssertEqualObjects(newContent.type, self.authorableContent.type, @"Wrong type");
    XCTAssertEqual([newContent.authors count], [self.authorableContent.authors count], @"Wrong number of author objects");
    XCTAssertEqualObjects(newContent.authorship, self.authorableContent.authorship, @"Wrong authorship");
    
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                                 ((JivePerson *)self.authorableContent.authors[0]).location, @"Wrong author object");
    }
}

- (BOOL)isNotMockAuthorable {
    return [self.authorableContent class] != [MockJiveAuthorableContent class];
}

- (void)testStructuredOutcomeContentParsing {
    if ([self isNotMockAuthorable]) {
        [super testStructuredOutcomeContentParsing];
    }
}

- (void)testStructuredOutcomeContentParsingAlternate {
    if ([self isNotMockAuthorable]) {
        [super testStructuredOutcomeContentParsingAlternate];
    }
}

@end
