//
//  JiveStructuredOutcomeContentTest.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/14/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveStructuredOutcomeContentTest.h"


@interface MockJiveStructuredOutcomeContent : JiveStructuredOutcomeContent

@end

@implementation MockJiveStructuredOutcomeContent

- (NSString *)type {
    return @"Dummy";
}

@end


@implementation JiveStructuredOutcomeContentTest

- (JiveStructuredOutcomeContent *)structuredOutcome {
    return (JiveStructuredOutcomeContent *)self.content;
}

- (void)setUp
{
    [super setUp];
    self.object = [MockJiveStructuredOutcomeContent new];
}

- (void)initializeStructuredOutcomeContent {
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    
    [outcome setValue:@"outcome" forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcome setValue:outcome.jiveId forKey:JiveOutcomeTypeAttributes.name];
    [self.structuredOutcome setValue:@[outcome]
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    [self.structuredOutcome setValue:@{outcome.jiveId:@1}
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    self.structuredOutcome.outcomeTypeNames = @[outcome.jiveId];
}

- (void)initializeAlternateStructuredOutcomeContent {
    JiveOutcomeType *outcome = [JiveOutcomeType new];
    NSNumber *outcomeCount = @5;
    
    [outcome setValue:@"Hotel" forKey:JiveOutcomeTypeAttributes.jiveId];
    [outcome setValue:outcome.jiveId forKey:JiveOutcomeTypeAttributes.name];
    [self.structuredOutcome setValue:@[outcome]
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    [self.structuredOutcome setValue:@{outcome.jiveId:outcomeCount}
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    self.structuredOutcome.outcomeTypeNames = @[outcome.jiveId];
}

- (void)testStructuredOutcomeContentToJSON {
    NSDictionary *JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    [self initializeStructuredOutcomeContent];
    
    JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeTypeNamesJSON[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
}

- (void)testStructuredOutcomeContentToJSON_alternate {
    [self initializeAlternateStructuredOutcomeContent];
    
    NSDictionary *JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeTypeNamesJSON[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
}

- (void)testToJSON_outcomeTypeNames {
    NSString *firstType = @"first";
    NSString *secondType = @"second";
    
    self.structuredOutcome.outcomeTypeNames = @[firstType];
    
    NSDictionary *JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertEqualObjects(array[0], firstType, @"Wrong value");
    
    self.structuredOutcome.outcomeTypeNames = @[firstType, secondType];
    
    JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertEqualObjects(array[0], firstType, @"Wrong value 1");
    XCTAssertEqualObjects(array[1], secondType, @"Wrong value 2");
}

- (void)testToJSON_outcomeTypes {
    JiveOutcomeType *firstOutcome = [JiveOutcomeType new];
    JiveOutcomeType *secondOutcome = [JiveOutcomeType new];
    
    [firstOutcome setValue:@"first" forKey:JiveOutcomeTypeAttributes.jiveId];
    [secondOutcome setValue:@"second" forKey:JiveOutcomeTypeAttributes.jiveId];
    [self.structuredOutcome setValue:@[firstOutcome]
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    
    NSDictionary *JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    NSDictionary *object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveObjectConstants.id], firstOutcome.jiveId, @"Wrong value");
    
    [self.structuredOutcome setValue:@[firstOutcome, secondOutcome]
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    
    JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    object1 = [array objectAtIndex:0];
    
    NSDictionary *object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"attachments array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JiveObjectConstants.id], firstOutcome.jiveId, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JiveObjectConstants.id], secondOutcome.jiveId, @"Wrong value 2");
}

- (void)testToJSON_outcomeCounts {
    NSString *firstType = @"first";
    NSNumber *firstCount = @5;
    NSString *secondType = @"second";
    NSNumber *secondCount = @72;
    
    [self.structuredOutcome setValue:@{firstType:firstCount}
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    NSDictionary *JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSDictionary *outcomeCountsJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    XCTAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"attachments array not converted");
    XCTAssertEqual([outcomeCountsJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertEqualObjects(outcomeCountsJSON[firstType], firstCount, @"Wrong value");
    
    [self.structuredOutcome setValue:@{firstType:firstCount, secondType:secondCount}
                              forKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    outcomeCountsJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    XCTAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"attachments array not converted");
    XCTAssertEqual([outcomeCountsJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertEqualObjects(outcomeCountsJSON[firstType], firstCount, @"Wrong value 1");
    XCTAssertEqualObjects(outcomeCountsJSON[secondType], secondCount, @"Wrong value 2");
}

- (void)testStructuredOutcomeContentPersistentJSON {
    NSDictionary *JSON = [self.structuredOutcome toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    [self initializeStructuredOutcomeContent];
    
    JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeTypeNamesJSON[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    NSDictionary *outcomeJSON = [outcomeTypesJSON objectAtIndex:0];
    
    XCTAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([outcomeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeJSON[@"id"], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
    XCTAssertEqualObjects(outcomeJSON[JiveOutcomeTypeAttributes.name],
                         ((JiveOutcomeType *)self.structuredOutcome.outcomeTypes[0]).name, @"Wrong value");
    
    NSDictionary *outcomeCountsJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    XCTAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeCountsJSON[self.structuredOutcome.outcomeTypeNames[0]],
                         self.structuredOutcome.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]], @"Wrong value");
}

- (void)testStructuredOutcomeContentPersistentJSON_alternate {
    [self initializeAlternateStructuredOutcomeContent];
    
    NSDictionary *JSON = [self.structuredOutcome persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type],
                         self.structuredOutcome.type, @"Wrong type");
    
    NSArray *outcomeTypeNamesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypeNames];
    
    XCTAssertTrue([[outcomeTypeNamesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypeNamesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeTypeNamesJSON[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
    
    NSArray *outcomeTypesJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeTypes];
    NSDictionary *outcomeJSON = [outcomeTypesJSON objectAtIndex:0];
    
    XCTAssertTrue([[outcomeTypesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([outcomeJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeJSON[@"id"], self.structuredOutcome.outcomeTypeNames[0], @"Wrong value");
    XCTAssertEqualObjects(outcomeJSON[JiveOutcomeTypeAttributes.name],
                         ((JiveOutcomeType *)self.structuredOutcome.outcomeTypes[0]).name, @"Wrong value");
    
    NSDictionary *outcomeCountsJSON = [JSON objectForKey:JiveStructuredOutcomeContentAttributes.outcomeCounts];
    
    XCTAssertTrue([[outcomeCountsJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([outcomeTypesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(outcomeCountsJSON[self.structuredOutcome.outcomeTypeNames[0]],
                         self.structuredOutcome.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]], @"Wrong value");
}

- (void)testStructuredOutcomeContentParsing {
    [self initializeStructuredOutcomeContent];
    
    id JSON = [self.structuredOutcome persistentJSON];
    JiveStructuredOutcomeContent *newContent = [MockJiveStructuredOutcomeContent objectFromJSON:JSON
                                                                                   withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.structuredOutcome class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.structuredOutcome.type, @"Wrong type");
    XCTAssertEqual(newContent.outcomeCounts.count, self.structuredOutcome.outcomeCounts.count, @"Wrong outcomeCounts count");
    XCTAssertEqualObjects(newContent.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]],
                         self.structuredOutcome.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]], @"Wrong outcome count");
    XCTAssertEqual(newContent.outcomeTypeNames.count, self.structuredOutcome.outcomeTypeNames.count, @"Wrong outcomeTypeNames count");
    XCTAssertEqualObjects(newContent.outcomeTypeNames[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong outcome name");
    XCTAssertEqual(newContent.outcomeTypes.count, self.structuredOutcome.outcomeTypes.count, @"Wrong outcomeTypes count");
    if ([newContent.outcomeTypes count] > 0) {
        id convertedObject = newContent.outcomeTypes[0];
        XCTAssertEqual([convertedObject class], [JiveOutcomeType class], @"Wrong outcomeType object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveOutcomeType class]])
            XCTAssertEqualObjects([(JiveOutcomeType *)convertedObject jiveId], self.structuredOutcome.outcomeTypeNames[0], @"Wrong outcome type");
    }
}

- (void)testStructuredOutcomeContentParsingAlternate {
    [self initializeAlternateStructuredOutcomeContent];
    
    id JSON = [self.structuredOutcome persistentJSON];
    JiveStructuredOutcomeContent *newContent = [MockJiveStructuredOutcomeContent objectFromJSON:JSON
                                                                                   withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.structuredOutcome class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.structuredOutcome.type, @"Wrong type");
    XCTAssertEqual(newContent.outcomeCounts.count, self.structuredOutcome.outcomeCounts.count, @"Wrong outcomeCounts count");
    XCTAssertEqualObjects(newContent.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]],
                         self.structuredOutcome.outcomeCounts[self.structuredOutcome.outcomeTypeNames[0]], @"Wrong outcome count");
    XCTAssertEqual(newContent.outcomeTypeNames.count, self.structuredOutcome.outcomeTypeNames.count, @"Wrong outcomeTypeNames count");
    XCTAssertEqualObjects(newContent.outcomeTypeNames[0], self.structuredOutcome.outcomeTypeNames[0], @"Wrong outcome name");
    XCTAssertEqual(newContent.outcomeTypes.count, self.structuredOutcome.outcomeTypes.count, @"Wrong outcomeTypes count");
    if ([newContent.outcomeTypes count] > 0) {
        id convertedObject = newContent.outcomeTypes[0];
        XCTAssertEqual([convertedObject class], [JiveOutcomeType class], @"Wrong outcomeType object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveOutcomeType class]])
            XCTAssertEqualObjects([(JiveOutcomeType *)convertedObject jiveId], self.structuredOutcome.outcomeTypeNames[0], @"Wrong outcome type");
    }
}

@end
