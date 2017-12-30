//
//  JiveIdeaTests.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveIdeaTests.h"

@implementation JiveIdeaTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveIdea alloc] init];
}

- (JiveIdea *)idea {
    return (JiveIdea *)self.authorableContent;
}

- (void)testType {
    XCTAssertEqualObjects(self.idea.type, @"idea", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.idea.type forKey:@"type"];
    
    XCTAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.idea class], @"Idea class not registered with JiveTypedObject.");
    XCTAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.idea class], @"Idea class not registered with JiveContent.");
}

- (void)initializeIdea {
    JivePerson *author = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *personURI = @"/person/1234";
    
    author.location = @"location";
    [author setValue:@"name" forKeyPath:JivePersonAttributes.displayName];
    self.idea.authors = @[author];
    self.idea.authorship = @"open";
    [self.idea setValue:JiveIdeaAuthorshipPolicy.open forKeyPath:JiveIdeaAttributes.authorshipPolicy];
    self.idea.categories = @[category];
    [self.idea setValue:@5 forKeyPath:JiveIdeaAttributes.commentCount];
    [self.idea setValue:@10 forKeyPath:JiveIdeaAttributes.score];
    [self.idea setValue:@"stage" forKeyPath:JiveIdeaAttributes.stage];
    self.idea.users = @[personURI];
    self.idea.visibility = @"hidden";
    [self.idea setValue:@20 forKeyPath:JiveIdeaAttributes.voteCount];
    [self.idea setValue:@YES forKeyPath:JiveIdeaAttributes.voted];
}

- (void)initializeAlternateIdea {
    JivePerson *author = [[JivePerson alloc] init];
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"denomination";
    
    author.location = @"Tower";
    [author setValue:@"bob" forKeyPath:JivePersonAttributes.displayName];
    user.location = @"restaurant";
    [user setValue:@"frank" forKeyPath:JivePersonAttributes.displayName];
    self.idea.authors = @[author];
    self.idea.authorship = @"limited";
    [self.idea setValue:JiveIdeaAuthorshipPolicy.multiple forKeyPath:JiveIdeaAttributes.authorshipPolicy];
    self.idea.categories = @[category];
    [self.idea setValue:@7 forKeyPath:JiveIdeaAttributes.commentCount];
    [self.idea setValue:@38 forKeyPath:JiveIdeaAttributes.score];
    [self.idea setValue:@"screen" forKeyPath:JiveIdeaAttributes.stage];
    self.idea.users = @[user];
    self.idea.visibility = @"people";
    [self.idea setValue:@163 forKeyPath:JiveIdeaAttributes.voteCount];
}

- (void)testIdeaToJSON {
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"idea", @"Wrong type");
    
    [self initializeIdea];
    
    JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveIdeaAttributes.authorship], self.idea.authorship, @"Wrong authorship");
    XCTAssertEqualObjects(JSON[JiveIdeaAttributes.visibility], self.idea.visibility, @"Wrong visibility");
    
    NSArray *authorsJSON = JSON[JiveIdeaAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.idea.authors[0]).location, @"Wrong value");
    
    NSArray *usersJSON = JSON[JiveIdeaAttributes.users];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([usersJSON objectAtIndex:0], self.idea.users[0], @"Wrong value");
    
    NSArray *categoriesJSON = JSON[JiveIdeaAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([categoriesJSON objectAtIndex:0], self.idea.categories[0], @"Wrong value");
}

- (void)testIdeaToJSON_alternate {
    [self initializeAlternateIdea];
    
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    XCTAssertEqualObjects(JSON[JiveIdeaAttributes.authorship], self.idea.authorship, @"Wrong authorship");
    XCTAssertEqualObjects(JSON[JiveIdeaAttributes.visibility], self.idea.visibility, @"Wrong visibility");
    
    NSArray *authorsJSON = JSON[JiveIdeaAttributes.authors];
    NSDictionary *authorJSON = [authorsJSON objectAtIndex:0];
    
    XCTAssertTrue([[authorsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([authorsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([authorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([authorJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.idea.authors[0]).location, @"Wrong value");
    
    NSArray *usersJSON = JSON[JiveIdeaAttributes.users];
    NSDictionary *userJSON = [usersJSON objectAtIndex:0];
    
    XCTAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqual([userJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([userJSON objectForKey:JivePersonAttributes.location],
                         ((JivePerson *)self.idea.users[0]).location, @"Wrong value");
    
    NSArray *categoriesJSON = JSON[JiveIdeaAttributes.categories];
    
    XCTAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    XCTAssertEqual([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([categoriesJSON objectAtIndex:0], self.idea.categories[0], @"Wrong value");
}

- (void)testToJSON_authors {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"Tower";
    person2.location = @"restaurant";
    [self.idea setValue:[NSArray arrayWithObject:person1] forKey:JiveIdeaAttributes.authors];
    
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    
    NSArray *array = JSON[JiveIdeaAttributes.authors];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.idea setValue:[self.idea.authors arrayByAddingObject:person2] forKey:JiveIdeaAttributes.authors];
    
    JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    
    array = JSON[JiveIdeaAttributes.authors];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"authors array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testToJSON_users {
    JivePerson *person1 = [[JivePerson alloc] init];
    JivePerson *person2 = [[JivePerson alloc] init];
    
    person1.location = @"Tower";
    person2.location = @"restaurant";
    [self.idea setValue:[NSArray arrayWithObject:person1] forKey:JiveIdeaAttributes.users];
    
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    
    NSArray *array = JSON[JiveIdeaAttributes.users];
    id object1 = [array objectAtIndex:0];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value");
    
    [self.idea setValue:[self.idea.users arrayByAddingObject:person2] forKey:JiveIdeaAttributes.users];
    
    JSON = [self.idea toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.idea.type, @"Wrong type");
    
    array = JSON[JiveIdeaAttributes.users];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    XCTAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"users array not converted");
    XCTAssertEqual([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"person 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:JivePersonAttributes.location], person1.location, @"Wrong value 1");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"person 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:JivePersonAttributes.location], person2.location, @"Wrong value 2");
}

- (void)testIdeaParsing {
    [self initializeIdea];
    [self.idea setValue:nil forKeyPath:JiveIdeaAttributes.users];
    
    id JSON = [self.idea persistentJSON];
    JiveIdea *newContent = [JiveIdea objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.authorship, self.idea.authorship, @"Wrong authorship");
    XCTAssertEqualObjects(newContent.authorshipPolicy, self.idea.authorshipPolicy, @"Wrong authorshipPolicy");
    XCTAssertEqualObjects(newContent.commentCount, self.idea.commentCount, @"Wrong commentCount");
    XCTAssertEqualObjects(newContent.score, self.idea.score, @"Wrong score");
    XCTAssertEqualObjects(newContent.stage, self.idea.stage, @"Wrong stage");
    XCTAssertEqualObjects(newContent.visibility, self.idea.visibility, @"Wrong visibility");
    XCTAssertEqualObjects(newContent.voteCount, self.idea.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects(newContent.voted, self.idea.voted, @"Wrong voted");
    XCTAssertEqual([newContent.categories count], [self.idea.categories count], @"Wrong number of tags");
    XCTAssertEqualObjects([newContent.categories objectAtIndex:0], self.idea.categories[0], @"Wrong category");
    XCTAssertEqual([newContent.authors count], [self.idea.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                                 ((JivePerson *)self.idea.authors[0]).location, @"Wrong author object");
    }
    
//    STAssertEquals([newContent.users count], [self.idea.users count], @"Wrong number of user objects");
//    if ([newContent.users count] > 0) {
//        id convertedObject = [newContent.users objectAtIndex:0];
//        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong user object class");
//        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
//            STAssertEqualObjects([(JivePerson *)convertedObject location],
//                         ((JivePerson *)self.idea.users[0]).location, @"Wrong user object");
//    }
}

- (void)testIdeaParsingAlternate {
    [self initializeAlternateIdea];
    
    id JSON = [self.idea persistentJSON];
    JiveIdea *newContent = [JiveIdea objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    XCTAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    XCTAssertEqualObjects(newContent.authorship, self.idea.authorship, @"Wrong authorship");
    XCTAssertEqualObjects(newContent.authorshipPolicy, self.idea.authorshipPolicy, @"Wrong authorshipPolicy");
    XCTAssertEqualObjects(newContent.commentCount, self.idea.commentCount, @"Wrong commentCount");
    XCTAssertEqualObjects(newContent.score, self.idea.score, @"Wrong score");
    XCTAssertEqualObjects(newContent.stage, self.idea.stage, @"Wrong stage");
    XCTAssertEqualObjects(newContent.visibility, self.idea.visibility, @"Wrong visibility");
    XCTAssertEqualObjects(newContent.voteCount, self.idea.voteCount, @"Wrong voteCount");
    XCTAssertEqualObjects(newContent.voted, self.idea.voted, @"Wrong voted");
    XCTAssertEqual([newContent.categories count], [self.idea.categories count], @"Wrong number of tags");
    XCTAssertEqualObjects([newContent.categories objectAtIndex:0], self.idea.categories[0], @"Wrong category");
    XCTAssertEqual([newContent.authors count], [self.idea.authors count], @"Wrong number of author objects");
    if ([newContent.authors count] > 0) {
        id convertedObject = [newContent.authors objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong author object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                                 ((JivePerson *)self.idea.authors[0]).location, @"Wrong author object");
    }
    
    XCTAssertEqual([newContent.users count], [self.idea.users count], @"Wrong number of user objects");
    if ([newContent.users count] > 0) {
        id convertedObject = [newContent.users objectAtIndex:0];
        XCTAssertEqual([convertedObject class], [JivePerson class], @"Wrong user object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            XCTAssertEqualObjects([(JivePerson *)convertedObject location],
                                 ((JivePerson *)self.idea.users[0]).location, @"Wrong user object");
    }
}

@end
