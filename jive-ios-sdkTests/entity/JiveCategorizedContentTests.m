//
//  JiveCategorizedContentTests.m
//  
//
//  Created by Orson Bushnell on 11/19/14.
//
//

#import "JiveCategorizedContentTests.h"


@interface MockJiveCategorizedContent : JiveCategorizedContent

@end

@interface JiveStructuredOutcomeContentTest (JiveCategorizedContentTests)

- (void)testStructuredOutcomeContentParsing;
- (void)testStructuredOutcomeContentParsingAlternate;

@end


@implementation MockJiveCategorizedContent

- (NSString *)type {
    return @"Categorized test.";
}

@end

@implementation JiveCategorizedContentTests

- (void)setUp {
    [super setUp];
    self.object = [MockJiveCategorizedContent new];
}

- (JiveCategorizedContent *)categorizedContent {
    return (JiveCategorizedContent *)self.structuredOutcome;
}

- (void)initializeCategorizedContent {
    NSString *category = @"category";
    JivePerson *author = [JivePerson new];
    NSString *personURI = @"/person/1234";
    
    author.location = @"location";
    [author setValue:@"no name" forKey:JivePersonAttributes.displayName];
    self.categorizedContent.categories = @[category];
    self.categorizedContent.extendedAuthors = @[author];
    self.categorizedContent.users = @[personURI];
    self.categorizedContent.visibility = @"all";
    
}

- (void)initializeAlternateCategorizedContent {
    NSString *category = @"denomination";
    JivePerson *author = [JivePerson new];
    JivePerson *user = [JivePerson new];
    
    author.location = @"Boulder";
    [author setValue:@"Jive" forKey:JivePersonAttributes.displayName];
    user.location = @"location";
    [user setValue:@"no name" forKey:JivePersonAttributes.displayName];
    self.categorizedContent.categories = @[category];
    self.categorizedContent.extendedAuthors = @[author];
    self.categorizedContent.users = @[user];
    self.categorizedContent.visibility = @"people";
}

- (void)testAuthorableContentToJSON {
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertNotNil(JSON[JiveTypedObjectAttributes.type], @"Wrong type");
    
    [self initializeCategorizedContent];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *categoriesJSON = JSON[JiveCategorizedContentAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Categories array had the wrong number of entries");
    XCTAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    XCTAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    XCTAssertEqual([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"ExtendedAuthors dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    
    NSArray *usersJSON = JSON[JiveCategorizedContentAttributes.users];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Users array had the wrong number of entries");
    XCTAssertEqualObjects(usersJSON[0], self.categorizedContent.users[0], @"Wrong user");
}

- (void)testAuthorableContentToJSON_alternate {
    [self initializeAlternateCategorizedContent];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *categoriesJSON = JSON[JiveCategorizedContentAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Categories array had the wrong number of entries");
    XCTAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    XCTAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    XCTAssertEqual([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"ExtendedAuthors dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    
    NSArray *usersJSON = JSON[JiveCategorizedContentAttributes.users];
    NSDictionary *userJSON = [usersJSON lastObject];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Users array not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Users array had the wrong number of entries");
    XCTAssertTrue([[userJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    XCTAssertEqual([userJSON count], (NSUInteger)2, @"User dictionary had the wrong number of entries");
    XCTAssertEqualObjects(userJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user");
}

- (void)testToJSON_extendedAuthors {
    JivePerson *person1 = [JivePerson new];
    JivePerson *person2 = [JivePerson new];
    
    person1.location = @"Tower";
    person2.location = @"Subway";
    [self.categorizedContent setValue:@[person1] forKey:JiveCategorizedContentAttributes.extendedAuthors];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    NSArray *array = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    id object1 = array[0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.categorizedContent setValue:[self.categorizedContent.extendedAuthors arrayByAddingObject:person2]
                               forKey:JiveCategorizedContentAttributes.extendedAuthors];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    array = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    object1 = array[0];
    
    id object2 = array[1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testToJSON_users {
    JivePerson *person1 = [JivePerson new];
    JivePerson *person2 = [JivePerson new];
    
    person1.location = @"Tower";
    person2.location = @"Subway";
    [self.categorizedContent setValue:@[person1] forKey:JiveCategorizedContentAttributes.users];
    
    NSDictionary *JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    NSArray *array = JSON[JiveCategorizedContentAttributes.users];
    id object1 = array[0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.categorizedContent setValue:[self.categorizedContent.users arrayByAddingObject:person2]
                               forKey:JiveCategorizedContentAttributes.users];
    
    JSON = [self.categorizedContent toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.categorizedContent.type, @"Wrong type");
    
    array = JSON[JiveCategorizedContentAttributes.users];
    object1 = array[0];
    
    id object2 = array[1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testAuthorableContentPersistentJSON {
    NSDictionary *JSON = [self.categorizedContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    
    [self initializeCategorizedContent];
    
    JSON = [self.categorizedContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *usersJSON = [JSON objectForKey:JiveCategorizedContentAttributes.users];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(usersJSON[0], self.categorizedContent.users[0], @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveCategorizedContentAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    XCTAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    XCTAssertEqual([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)3, @"ExtendedAuthors dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentPersistentJSON_alternate {
    [self initializeAlternateCategorizedContent];
    
    NSDictionary *JSON = [self.categorizedContent persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"type"], self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JiveCategorizedContentAttributes.visibility],
                         self.categorizedContent.visibility, @"Wrong visibility");
    
    NSArray *usersJSON = [JSON objectForKey:JiveCategorizedContentAttributes.users];
    NSDictionary *userJSON = usersJSON[0];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([userJSON count], (NSUInteger)3, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong value");
    XCTAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.users[0]).displayName, @"Wrong display name");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveCategorizedContentAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects(categoriesJSON[0], self.categorizedContent.categories[0], @"Wrong value");
    
    NSArray *extendedAuthorsJSON = JSON[JiveCategorizedContentAttributes.extendedAuthors];
    NSDictionary *authorJSON = [extendedAuthorsJSON lastObject];
    
    XCTAssertTrue([[extendedAuthorsJSON class] isSubclassOfClass:[NSArray class]], @"ExtendedAuthors array not converted");
    XCTAssertEqual([extendedAuthorsJSON count], (NSUInteger)1, @"ExtendedAuthors array had the wrong number of entries");
    XCTAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"JivePerson not converted");
    XCTAssertEqual([authorJSON count], (NSUInteger)3, @"ExtendedAuthors dictionary had the wrong number of entries");
    XCTAssertEqualObjects(authorJSON[JivePersonAttributes.location],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong author");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.displayName],
                         ((JivePerson *)self.categorizedContent.extendedAuthors[0]).displayName, @"Wrong display name");
}

- (void)testAuthorableContentParsing {
    [self initializeCategorizedContent];
    
    self.categorizedContent.users = nil;
    id JSON = [self.categorizedContent persistentJSON];
    JiveCategorizedContent *newContent = [MockJiveCategorizedContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.categorizedContent class]],
                 @"Wrong item class: %@", [newContent class]);
    XCTAssertEqualObjects(newContent.type, self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.visibility, self.categorizedContent.visibility, @"Wrong visibility");
    XCTAssertEqual([newContent.categories count], [self.categorizedContent.categories count], @"Wrong categories count");
    XCTAssertEqualObjects(newContent.categories[0], self.categorizedContent.categories[0], @"Wrong category");
    
    XCTAssertEqual([newContent.users count], [self.categorizedContent.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        JivePerson *convertedPerson = newContent.users[0];
        XCTAssertEqual([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user object");
    }
    
    XCTAssertEqual([newContent.extendedAuthors count],
                   [self.categorizedContent.extendedAuthors count], @"Wrong number of extendedAuthor objects");
    if ([newContent.extendedAuthors count] > 0) {
        JivePerson *convertedPerson = newContent.extendedAuthors[0];
        XCTAssertEqual([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong user object");
    }
}

- (void)testAuthorableContentParsing_alternate {
    [self initializeAlternateCategorizedContent];
    
    id JSON = [self.categorizedContent persistentJSON];
    JiveCategorizedContent *newContent = [MockJiveCategorizedContent objectFromJSON:JSON
                                                                     withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.categorizedContent class]],
                 @"Wrong item class: %@", [newContent class]);
    XCTAssertEqualObjects(newContent.type, self.categorizedContent.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.visibility, self.categorizedContent.visibility, @"Wrong visibility");
    XCTAssertEqual([newContent.categories count], [self.categorizedContent.categories count], @"Wrong categories count");
    XCTAssertEqualObjects(newContent.categories[0], self.categorizedContent.categories[0], @"Wrong category");
    
    XCTAssertEqual([newContent.users count], [self.categorizedContent.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        JivePerson *convertedPerson = newContent.users[0];
        XCTAssertEqual([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.users[0]).location, @"Wrong user object");
    }
    
    XCTAssertEqual([newContent.extendedAuthors count],
                   [self.categorizedContent.extendedAuthors count], @"Wrong number of extendedAuthor objects");
    if ([newContent.extendedAuthors count] > 0) {
        JivePerson *convertedPerson = newContent.extendedAuthors[0];
        XCTAssertEqual([convertedPerson class], [JivePerson class], @"Wrong user object class");
        if ([[convertedPerson class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([convertedPerson location],
                                 ((JivePerson *)self.categorizedContent.extendedAuthors[0]).location, @"Wrong user object");
    }
}

- (BOOL)isNotMockCategorized {
    return [self.categorizedContent class] != [MockJiveCategorizedContent class];
}

- (void)testStructuredOutcomeContentParsing {
    if ([self isNotMockCategorized]) {
        [super testStructuredOutcomeContentParsing];
    }
}

- (void)testStructuredOutcomeContentParsingAlternate {
    if ([self isNotMockCategorized]) {
        [super testStructuredOutcomeContentParsingAlternate];
    }
}

@end
