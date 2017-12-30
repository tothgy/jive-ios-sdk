//
//  JiveObjectMetadataTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveObjectMetadataTests.h"
#import "JiveField.h"
#import "JiveResource.h"
#import "JiveObject_internal.h"

@implementation JiveObjectMetadataTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveObjectMetadata alloc] init];
}

- (JiveObjectMetadata *)objectMetadata {
    return (JiveObjectMetadata *)self.object;
}

- (void)initializeObjectMetadata {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.associatable];
    [self.objectMetadata setValue:@[field] forKey:JiveObjectMetadataAttributes.fields];
    [self.objectMetadata setValue:@[resourceLink] forKey:JiveObjectMetadataAttributes.resourceLinks];
    [self.objectMetadata setValue:@"availability" forKey:JiveObjectMetadataAttributes.availability];
    [self.objectMetadata setValue:@"description" forKey:JiveObjectAttributes.jiveDescription];
    [self.objectMetadata setValue:@"example" forKey:JiveObjectMetadataAttributes.example];
    [self.objectMetadata setValue:@"name" forKey:JiveObjectMetadataAttributes.name];
    [self.objectMetadata setValue:@"plural" forKey:JiveObjectMetadataAttributes.plural];
    [self.objectMetadata setValue:@"since" forKey:JiveObjectMetadataAttributes.since];
}

- (void)initializeAlternateObjectMetadata {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"Reginald" forKey:@"displayName"];
    [resourceLink setValue:@"Resource" forKey:@"name"];
    [self.objectMetadata setValue:@[field] forKey:JiveObjectMetadataAttributes.fields];
    [self.objectMetadata setValue:@[resourceLink] forKey:JiveObjectMetadataAttributes.resourceLinks];
    [self.objectMetadata setValue:@"wrong" forKey:JiveObjectMetadataAttributes.availability];
    [self.objectMetadata setValue:@"title" forKey:JiveObjectAttributes.jiveDescription];
    [self.objectMetadata setValue:@"big" forKey:JiveObjectMetadataAttributes.example];
    [self.objectMetadata setValue:@"Whippersnapper" forKey:JiveObjectMetadataAttributes.name];
    [self.objectMetadata setValue:@"singular" forKey:JiveObjectMetadataAttributes.plural];
    [self.objectMetadata setValue:@"until" forKey:JiveObjectMetadataAttributes.since];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.commentable];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.content];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.place];
}

- (void)testObjectMetadataToJSON {
    [self initializeObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
}

- (void)testObjectMetadataPersistentJSON {
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeObjectMetadata];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)9, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.availability],
                         self.objectMetadata.availability, @"Wrong availability.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.description], self.objectMetadata.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.example], self.objectMetadata.example, @"Wrong example");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.name], self.objectMetadata.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.plural], self.objectMetadata.plural, @"Wrong plural");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.since], self.objectMetadata.since, @"Wrong since.");
    
    NSArray *fieldsJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *fieldJSON = [fieldsJSON lastObject];
    
    XCTAssertTrue([[fieldsJSON class] isSubclassOfClass:[NSArray class]], @"fields array not converted");
    XCTAssertEqual([fieldsJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[fieldsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"fields object not converted");
    XCTAssertTrue([[fieldJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Field JSON has the wrong class");
    XCTAssertEqual([fieldJSON count], (NSUInteger)1, @"Fields dictionary had the wrong number of entries");
    XCTAssertEqualObjects(fieldJSON[@"displayName"],
                         ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object.");
    
    NSArray *resourceLinksJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *resourceJSON = [resourceLinksJSON lastObject];
    
    XCTAssertTrue([[resourceLinksJSON class] isSubclassOfClass:[NSArray class]], @"resourceLinks array not converted");
    XCTAssertEqual([resourceLinksJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    XCTAssertTrue([[[resourceLinksJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"resourceLinks object not converted");
    XCTAssertTrue([[resourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Resource link JSON has the wrong class");
    XCTAssertEqual([resourceJSON count], (NSUInteger)1, @"Resource link dictionary had the wrong number of entries");
    XCTAssertEqualObjects(resourceJSON[@"name"],
                         ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resource object.");
}

- (void)testObjectMetadataPersistentJSON_alternate {
    [self initializeAlternateObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)11, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.availability],
                         self.objectMetadata.availability, @"Wrong availability.");
    XCTAssertEqualObjects(JSON[JiveObjectConstants.description], self.objectMetadata.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.example], self.objectMetadata.example, @"Wrong example");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.name], self.objectMetadata.name, @"Wrong name");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.plural], self.objectMetadata.plural, @"Wrong plural");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.since], self.objectMetadata.since, @"Wrong since.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    
    NSArray *fieldsJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *fieldJSON = [fieldsJSON lastObject];
    
    XCTAssertTrue([[fieldsJSON class] isSubclassOfClass:[NSArray class]], @"fields array not converted");
    XCTAssertEqual([fieldsJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    XCTAssertTrue([[[fieldsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"fields object not converted");
    XCTAssertTrue([[fieldJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Field JSON has the wrong class");
    XCTAssertEqual([fieldJSON count], (NSUInteger)1, @"Fields dictionary had the wrong number of entries");
    XCTAssertEqualObjects(fieldJSON[@"displayName"],
                         ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object.");
    
    NSArray *resourceLinksJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *resourceJSON = [resourceLinksJSON lastObject];
    
    XCTAssertTrue([[resourceLinksJSON class] isSubclassOfClass:[NSArray class]], @"resourceLinks array not converted");
    XCTAssertEqual([resourceLinksJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    XCTAssertTrue([[[resourceLinksJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"resourceLinks object not converted");
    XCTAssertTrue([[resourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Resource link JSON has the wrong class");
    XCTAssertEqual([resourceJSON count], (NSUInteger)1, @"Resource link dictionary had the wrong number of entries");
    XCTAssertEqualObjects(resourceJSON[@"name"],
                         ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resource object.");
}

- (void)testObjectMetadataPersistentJSON_allFlags {
    XCTAssertFalse([self.objectMetadata isAssociatable]);
    XCTAssertFalse([self.objectMetadata isCommentable]);
    XCTAssertFalse([self.objectMetadata isContent]);
    XCTAssertFalse([self.objectMetadata isAPlace]);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.associatable];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    XCTAssertTrue([self.objectMetadata isAssociatable]);
    XCTAssertFalse([self.objectMetadata isCommentable]);
    XCTAssertFalse([self.objectMetadata isContent]);
    XCTAssertFalse([self.objectMetadata isAPlace]);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.commentable];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    XCTAssertTrue([self.objectMetadata isAssociatable]);
    XCTAssertTrue([self.objectMetadata isCommentable]);
    XCTAssertFalse([self.objectMetadata isContent]);
    XCTAssertFalse([self.objectMetadata isAPlace]);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.content];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    XCTAssertTrue([self.objectMetadata isAssociatable]);
    XCTAssertTrue([self.objectMetadata isCommentable]);
    XCTAssertTrue([self.objectMetadata isContent]);
    XCTAssertFalse([self.objectMetadata isAPlace]);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.place];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    XCTAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    XCTAssertTrue([self.objectMetadata isAssociatable]);
    XCTAssertTrue([self.objectMetadata isCommentable]);
    XCTAssertTrue([self.objectMetadata isContent]);
    XCTAssertTrue([self.objectMetadata isAPlace]);
}

- (void)testObjectMetadataPersistentJSON_fields {
    JiveField *field1 = [[JiveField alloc] init];
    JiveField *field2 = [[JiveField alloc] init];
    
    [field1 setValue:@"displayName" forKey:@"displayName"];
    [field2 setValue:@"alternate" forKey:@"displayName"];
    [self.objectMetadata setValue:@[field1] forKey:JiveObjectMetadataAttributes.fields];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the field array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field object not converted");
    XCTAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field displayName");
    
    [self.objectMetadata setValue:@[field1, field2] forKey:JiveObjectMetadataAttributes.fields];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JiveObjectMetadataAttributes.fields];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the field array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field 1 displayName");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"field 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:@"displayName"], field2.displayName, @"Wrong field 2 displayName");
}

- (void)testObjectMetadataPersistentJSON_resourceLinks {
    JiveResource *resourceLink1 = [[JiveResource alloc] init];
    JiveResource *resourceLink2 = [[JiveResource alloc] init];
    
    [resourceLink1 setValue:@"name" forKey:@"name"];
    [resourceLink2 setValue:@"alternate" forKey:@"name"];
    [self.objectMetadata setValue:@[resourceLink1]
                           forKey:JiveObjectMetadataAttributes.resourceLinks];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the resourceLink array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink object not converted");
    XCTAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink name");
    
    [self.objectMetadata setValue:@[resourceLink1, resourceLink2]
                           forKey:JiveObjectMetadataAttributes.resourceLinks];
    
    JSON = [self.objectMetadata persistentJSON];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the resourceLink array");
    XCTAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink 1 object not converted");
    XCTAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink 1 name");
    XCTAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink 2 object not converted");
    XCTAssertEqualObjects([object2 objectForKey:@"name"], resourceLink2.name, @"Wrong resourceLink 2 name");
}

- (void)testParsing {
    [self initializeObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    JiveObjectMetadata *metadata = [JiveObjectMetadata objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    XCTAssertEqualObjects(metadata.availability, self.objectMetadata.availability, @"Wrong availability");
    XCTAssertEqualObjects(metadata.jiveDescription, self.objectMetadata.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(metadata.example, self.objectMetadata.example, @"Wrong example");
    XCTAssertEqualObjects(metadata.name, self.objectMetadata.name, @"Wrong name");
    XCTAssertEqualObjects(metadata.plural, self.objectMetadata.plural, @"Wrong plural");
    XCTAssertEqualObjects(metadata.since, self.objectMetadata.since, @"Wrong since");
    XCTAssertEqualObjects(metadata.associatable, self.objectMetadata.associatable, @"Wrong associatable");
    XCTAssertEqualObjects(metadata.commentable, self.objectMetadata.commentable, @"Wrong commentable");
    XCTAssertEqualObjects(metadata.content, self.objectMetadata.content, @"Wrong content");
    XCTAssertEqualObjects(metadata.place, self.objectMetadata.place, @"Wrong place");
    XCTAssertEqual([metadata.fields count], [self.objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        XCTAssertEqual([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            XCTAssertEqualObjects([(JiveField *)convertedField displayName],
                                 ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object");
    }
    
    XCTAssertEqual([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        XCTAssertEqual([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            XCTAssertEqualObjects([(JiveResource *)convertedResourceLink name],
                                 ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resourceLink object");
    }
}

- (void)testParsingAlternate {
    [self initializeAlternateObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    JiveObjectMetadata *metadata = [JiveObjectMetadata objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    XCTAssertEqualObjects(metadata.availability, self.objectMetadata.availability, @"Wrong availability");
    XCTAssertEqualObjects(metadata.jiveDescription, self.objectMetadata.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(metadata.example, self.objectMetadata.example, @"Wrong example");
    XCTAssertEqualObjects(metadata.name, self.objectMetadata.name, @"Wrong name");
    XCTAssertEqualObjects(metadata.plural, self.objectMetadata.plural, @"Wrong plural");
    XCTAssertEqualObjects(metadata.since, self.objectMetadata.since, @"Wrong since");
    XCTAssertEqualObjects(metadata.associatable, self.objectMetadata.associatable, @"Wrong associatable");
    XCTAssertEqualObjects(metadata.commentable, self.objectMetadata.commentable, @"Wrong commentable");
    XCTAssertEqualObjects(metadata.content, self.objectMetadata.content, @"Wrong content");
    XCTAssertEqualObjects(metadata.place, self.objectMetadata.place, @"Wrong place");
    XCTAssertEqual([metadata.fields count], [self.objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        XCTAssertEqual([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            XCTAssertEqualObjects([(JiveField *)convertedField displayName],
                                 ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object");
    }
    
    XCTAssertEqual([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        XCTAssertEqual([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            XCTAssertEqualObjects([(JiveResource *)convertedResourceLink name],
                                 ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resourceLink object");
    }
}

@end
