//
//  JivePlaceTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
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

#import "JivePlaceTests.h"
#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "JiveResourceEntry.h"
#import "JiveObject_internal.h"
#import "JiveTypedObject_internal.h"
#import <OCMock/OCMock.h>

extern struct JivePlaceResourceAttributes {
    __unsafe_unretained NSString *activity;
    __unsafe_unretained NSString *announcements;
    __unsafe_unretained NSString *avatar;
    __unsafe_unretained NSString *blog;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *checkPoints;
    __unsafe_unretained NSString *childPlaces;
    __unsafe_unretained NSString *contents;
    __unsafe_unretained NSString *extprops;
    __unsafe_unretained NSString *featuredContent;
    __unsafe_unretained NSString *followingIn;
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *invites;
    __unsafe_unretained NSString *members;
    __unsafe_unretained NSString *statics;
    __unsafe_unretained NSString *tasks;
} const JivePlaceResourceAttributes;

@interface DummyPlace : JivePlace

@end

@implementation DummyPlace

- (NSString *)type {
    return @"dummy";
}

@end

@implementation JivePlaceTests

- (JivePlace *)place {
    return (JivePlace *)self.typedObject;
}

- (void)setUp {
    [super setUp];
    self.object = [[DummyPlace alloc] init];
}

- (void)testHandlePrimitivePropertyFromJSON {
    XCTAssertFalse(self.place.visibleToExternalContributors, @"PRECONDITION: default is false");
    
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    XCTAssertTrue(self.place.visibleToExternalContributors, @"Set to true");
    
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanFalse];
    XCTAssertFalse(self.place.visibleToExternalContributors, @"Back to false");
}

- (void)testEntityClass {
    NSString *key = JiveTypedObjectAttributes.type;
    NSMutableDictionary *typeSpecifier = [@{key:@"blog"} mutableCopy];
    SEL selector = @selector(entityClass:);
    
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveBlog class], @"Blog");
    
    [typeSpecifier setValue:@"group" forKey:key];
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveGroup class], @"Group");
    
    [typeSpecifier setValue:@"project" forKey:key];
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveProject class], @"Project");
    
    [typeSpecifier setValue:@"space" forKey:key];
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JiveSpace class], @"Space");
    
    [typeSpecifier setValue:@"random" forKey:key];
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Out of bounds");
    
    [typeSpecifier setValue:@"Not random" forKey:key];
    XCTAssertEqualObjects([JivePlace performSelector:selector withObject:typeSpecifier],
                         [JivePlace class], @"Different out of bounds");
}

- (void)testToJSON {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.place toJSONDictionary]);
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Status update" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Parent";
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                withObject:@"visibleToExternalContributors"
                withObject:(__bridge id)kCFBooleanTrue];
    [self.place setValue:@"testIconCss" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"not here" forKey:JivePlaceAttributes.placeID];
    
    XCTAssertNoThrow(JSON = [self.place toJSONDictionary]);
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)19, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.name], self.place.name, @"Wrong name.");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.displayName],
                         self.place.displayName, @"Wrong display name.");
    XCTAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.place.jiveId, @"Wrong id.");
    XCTAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.status], self.place.status, @"Wrong status update");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightBody],
                         self.place.highlightBody, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightSubject],
                         self.place.highlightSubject, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightTags],
                         self.place.highlightTags, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.followerCount],
                         self.place.followerCount, @"Wrong followerCount.");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.likeCount], self.place.likeCount, @"Wrong likeCount");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.viewCount], self.place.viewCount, @"Wrong viewCount");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.published], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.updated], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.parent], self.place.parent, @"Wrong parent");
    
    NSNumber *visibility = [JSON objectForKey:JivePlaceAttributes.visibleToExternalContributors];
    
    XCTAssertNotNil(visibility, @"Missing visibility");
    if (visibility)
        XCTAssertTrue([visibility boolValue], @"Wrong visiblity");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:JivePlaceAttributes.parentContent];
    
    XCTAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:JivePlaceAttributes.parentPlace];
    
    XCTAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");

    NSArray *contentTypesJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
    
    XCTAssertTrue([[contentTypesJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    XCTAssertEqual([contentTypesJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    XCTAssertEqualObjects([contentTypesJSON objectAtIndex:0], contentType, @"contentType object not converted");
}

- (void)testToJSON_alternate {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    self.place.displayName = @"Alternate";
    [self.place setValue:@"87654" forKey:@"jiveId"];
    self.place.jiveDescription = @"Foxtrot";
    [self.place setValue:@"Working for the man" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"not Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"not Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"not Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"test name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    self.place.parent = @"Goofy";

    NSDictionary *JSON;
    
    XCTAssertNoThrow(JSON = [self.place toJSONDictionary]);
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)17, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.name], self.place.name, @"Wrong name.");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.displayName],
                         self.place.displayName, @"Wrong display name.");
    XCTAssertEqualObjects([JSON objectForKey:JiveObjectConstants.id], self.place.jiveId, @"Wrong id.");
    XCTAssertEqualObjects([JSON objectForKey:@"description"], self.place.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.status], self.place.status, @"Wrong status update");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightBody],
                         self.place.highlightBody, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightSubject],
                         self.place.highlightSubject, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.highlightTags],
                         self.place.highlightTags, @"Wrong thumbnail url");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.followerCount],
                         self.place.followerCount, @"Wrong followerCount.");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.likeCount], self.place.likeCount, @"Wrong likeCount");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.viewCount], self.place.viewCount, @"Wrong viewCount");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.published], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.updated], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
    XCTAssertEqualObjects([JSON objectForKey:JivePlaceAttributes.parent], self.place.parent, @"Wrong parent");
    XCTAssertNil([JSON objectForKey:JivePlaceAttributes.visibleToExternalContributors], @"Visibility included?");
    
    NSDictionary *parentContentJSON = [JSON objectForKey:JivePlaceAttributes.parentContent];
    
    XCTAssertTrue([[parentContentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentContentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([parentContentJSON objectForKey:@"name"], parentContent.name, @"Wrong user name");
    
    NSDictionary *parentPlaceJSON = [JSON objectForKey:JivePlaceAttributes.parentPlace];
    
    XCTAssertTrue([[parentPlaceJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    XCTAssertEqual([parentPlaceJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    XCTAssertEqualObjects([parentPlaceJSON objectForKey:@"name"], parentPlace.name, @"Wrong user name");
}

- (void)testToJSON_contentTypes {
    NSString *contentType1 = @"First";
    NSString *contentType2 = @"Last";
    
    [self.place setValue:[NSArray arrayWithObject:contentType1]
                  forKey:JivePlaceAttributes.contentTypes];
    
    NSDictionary *JSON = [self.place toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");

    NSArray *addressJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
    
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the contentTypes array");
    XCTAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType value");
    
    [self.place setValue:[self.place.contentTypes arrayByAddingObject:contentType2]
                  forKey:JivePlaceAttributes.contentTypes];
    
    XCTAssertNoThrow(JSON = [self.place toJSONDictionary]);
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    XCTAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.place.type, @"Wrong type");

    addressJSON = [JSON objectForKey:JivePlaceAttributes.contentTypes];
    XCTAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"contentTypes array not converted");
    XCTAssertEqual([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the contentTypes array");
    XCTAssertEqualObjects([addressJSON objectAtIndex:0], contentType1, @"Wrong contentType 1 value");
    XCTAssertEqualObjects([addressJSON objectAtIndex:1], contentType2, @"Wrong contentType 2 value");
}

- (void)testPlaceParsing {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    
    [resource setValue:[NSURL URLWithString:@"http://dummy.com"]
                forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [parentContent setValue:@"content" forKey:@"name"];
    [parentPlace setValue:@"place" forKey:@"name"];
    self.place.displayName = @"testName";
    [self.place setValue:@"1234" forKey:@"jiveId"];
    self.place.jiveDescription = @"USA";
    [self.place setValue:@"Working for the man" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:33] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"name";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Parent";
    [self.place setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
    [self.place performSelector:@selector(handlePrimitiveProperty:fromJSON:)
                    withObject:@"visibleToExternalContributors"
                    withObject:(__bridge id)kCFBooleanTrue];
    [self.place setValue:@"testIconCss" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"not here" forKey:JivePlaceAttributes.placeID];
    
    id JSON;
    JivePlace *newPlace;
    
    XCTAssertNoThrow(JSON = [self.place persistentJSON]);
    XCTAssertNoThrow(newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance]);
    
    XCTAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    XCTAssertEqualObjects(newPlace.displayName, self.place.displayName, @"Wrong display name");
    XCTAssertEqualObjects(newPlace.followerCount, self.place.followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(newPlace.likeCount, self.place.likeCount, @"Wrong like count");
    XCTAssertEqualObjects(newPlace.viewCount, self.place.viewCount, @"Wrong viewCount");
    XCTAssertEqualObjects(newPlace.jiveId, self.place.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newPlace.jiveDescription, self.place.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(newPlace.name, self.place.name, @"Wrong name");
    XCTAssertEqualObjects(newPlace.published, self.place.published, @"Wrong published date");
    XCTAssertEqualObjects(newPlace.status, self.place.status, @"Wrong status");
    XCTAssertEqualObjects(newPlace.highlightBody, self.place.highlightBody, @"Wrong highlightBody");
    XCTAssertEqualObjects(newPlace.highlightSubject, self.place.highlightSubject, @"Wrong highlightSubject");
    XCTAssertEqualObjects(newPlace.highlightTags, self.place.highlightTags, @"Wrong highlightTags");
    XCTAssertEqualObjects(newPlace.updated, self.place.updated, @"Wrong updated date");
    XCTAssertEqualObjects(newPlace.parent, self.place.parent, @"Wrong parent");
    XCTAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    XCTAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    XCTAssertTrue(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    XCTAssertEqual([newPlace.contentTypes count], [self.place.contentTypes count], @"Wrong number of contentType objects");
    XCTAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [self.place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    XCTAssertEqual([newPlace.resources count], [self.place.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newPlace.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
    XCTAssertEqualObjects(newPlace.iconCss, self.place.iconCss);
    XCTAssertEqualObjects(newPlace.placeID, self.place.placeID);
}

- (void)testPlaceParsingAlternate {
    JiveSummary *parentContent = [[JiveSummary alloc] init];
    JiveSummary *parentPlace = [[JiveSummary alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    
    [resource setValue:[NSURL URLWithString:@"https://dummy.com"]
                forKey:JiveResourceEntryAttributes.ref];
    [resource setValue:@[@"GET"] forKey:JiveResourceEntryAttributes.allowed];
    [parentContent setValue:@"not content" forKey:@"name"];
    [parentPlace setValue:@"not place" forKey:@"name"];
    self.place.displayName = @"display name";
    [self.place setValue:@"87654" forKey:JivePlaceAttributes.jiveId];
    self.place.jiveDescription = @"New Mexico";
    [self.place setValue:@"No status" forKey:JivePlaceAttributes.status];
    [self.place setValue:@"not Body" forKey:JivePlaceAttributes.highlightBody];
    [self.place setValue:@"not Subject" forKey:JivePlaceAttributes.highlightSubject];
    [self.place setValue:@"not Tags" forKey:JivePlaceAttributes.highlightTags];
    [self.place setValue:[NSNumber numberWithInt:6] forKey:JivePlaceAttributes.followerCount];
    [self.place setValue:[NSNumber numberWithInt:4] forKey:JivePlaceAttributes.likeCount];
    [self.place setValue:[NSNumber numberWithInt:12] forKey:JivePlaceAttributes.viewCount];
    self.place.name = @"Alternate";
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:1000.123]
                  forKey:JivePlaceAttributes.published];
    [self.place setValue:[NSDate dateWithTimeIntervalSince1970:0]
                  forKey:JivePlaceAttributes.updated];
    [self.place setValue:parentContent forKey:JivePlaceAttributes.parentContent];
    [self.place setValue:parentPlace forKey:JivePlaceAttributes.parentPlace];
    [self.place setValue:[NSArray arrayWithObject:contentType]
                  forKey:JivePlaceAttributes.contentTypes];
    self.place.parent = @"Goofy";
    [self.place setValue:@{resourceKey:resource} forKey:JiveTypedObjectAttributesHidden.resources];
    [self.place setValue:@"dummy" forKey:JivePlaceAttributes.iconCss];
    [self.place setValue:@"Chicago" forKey:JivePlaceAttributes.placeID];
    
    id JSON;
    JivePlace *newPlace;
    
    XCTAssertNoThrow(JSON = [self.place persistentJSON]);
    XCTAssertNoThrow(newPlace = [JivePlace objectFromJSON:JSON withInstance:self.instance]);
    
    XCTAssertTrue([[newPlace class] isSubclassOfClass:[JivePlace class]], @"Wrong item class");
    XCTAssertEqualObjects(newPlace.displayName, self.place.displayName, @"Wrong display name");
    XCTAssertEqualObjects(newPlace.followerCount, self.place.followerCount, @"Wrong follower count");
    XCTAssertEqualObjects(newPlace.likeCount, self.place.likeCount, @"Wrong like count");
    XCTAssertEqualObjects(newPlace.viewCount, self.place.viewCount, @"Wrong viewCount");
    XCTAssertEqualObjects(newPlace.jiveId, self.place.jiveId, @"Wrong id");
    XCTAssertEqualObjects(newPlace.jiveDescription, self.place.jiveDescription, @"Wrong description");
    XCTAssertEqualObjects(newPlace.name, self.place.name, @"Wrong name");
    XCTAssertEqualObjects(newPlace.published, self.place.published, @"Wrong published date");
    XCTAssertEqualObjects(newPlace.status, self.place.status, @"Wrong status");
    XCTAssertEqualObjects(newPlace.highlightBody, self.place.highlightBody, @"Wrong highlightBody");
    XCTAssertEqualObjects(newPlace.highlightSubject, self.place.highlightSubject, @"Wrong highlightSubject");
    XCTAssertEqualObjects(newPlace.highlightTags, self.place.highlightTags, @"Wrong highlightTags");
    XCTAssertEqualObjects(newPlace.updated, self.place.updated, @"Wrong updated date");
    XCTAssertEqualObjects(newPlace.parent, self.place.parent, @"Wrong parent");
    XCTAssertEqualObjects(newPlace.parentContent.name, parentContent.name, @"Wrong parentContent name");
    XCTAssertEqualObjects(newPlace.parentPlace.name, parentPlace.name, @"Wrong parentPlace name");
    XCTAssertFalse(newPlace.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    XCTAssertEqual([newPlace.contentTypes count], [self.place.contentTypes count], @"Wrong number of contentType objects");
    XCTAssertEqualObjects([newPlace.contentTypes objectAtIndex:0], [self.place.contentTypes objectAtIndex:0], @"Wrong contentType object class");
    XCTAssertEqual([newPlace.resources count], [self.place.resources count], @"Wrong number of resource objects");
    XCTAssertEqualObjects([(JiveResourceEntry *)[newPlace.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
    XCTAssertEqualObjects(newPlace.iconCss, self.place.iconCss);
    XCTAssertEqualObjects(newPlace.placeID, self.place.placeID);
}

- (void)test_canCreate {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // announcement
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.announcements, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canCreateAnnouncement], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.announcements, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canCreateAnnouncement], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // invite
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.invites, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canCreateInvite], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.invites, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canCreateInvite], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // member
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.members, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canCreateMember], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.members, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canCreateMember], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // task
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.tasks, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canCreateTask], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.tasks, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canCreateTask], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // content
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.contents, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canCreateContent], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.contents, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canCreateContent], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
}

- (void)test_canAdd {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // extprops
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canAddExtProps], @"user cannot add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canAddExtProps], @"user can add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // statics
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.statics, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canAddStatic], @"user cannot add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.statics, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canAddStatic], @"user can add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // categories
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.categories, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canAddCategory], @"user cannot add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.categories, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canAddCategory], @"user can add this type");
    XCTAssertNoThrow([mockedPlace verify]);
}

- (void)test_canDelete {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // extprops
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canDeleteExtProps], @"user cannot add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.extprops, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canDeleteExtProps], @"user can add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // avatar
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canDeleteAvatar], @"user cannot add this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasDeleteForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canDeleteAvatar], @"user can add this type");
    XCTAssertNoThrow([mockedPlace verify]);
}

- (void)test_canUpdate {
    id mockedPlace = [OCMockObject partialMockForObject:self.place];
    
    // avatar
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canUpdateAvatar], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.avatar, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canUpdateAvatar], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // checkPoints
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.checkPoints, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canUpdateCheckPoints], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.checkPoints, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canUpdateCheckPoints], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    
    // followingIn
    [[[mockedPlace expect] andReturnValue:@NO] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.followingIn, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertFalse([mockedPlace canUpdateFollowingIn], @"user cannot create this type");
    XCTAssertNoThrow([mockedPlace verify]);
    [[[mockedPlace expect] andReturnValue:@YES] resourceHasPostForTag:[OCMArg checkWithBlock:^BOOL(id obj) {
        XCTAssertEqualObjects(obj, JivePlaceResourceAttributes.followingIn, @"Wrong property requested.");
        return YES;
    }]];
    XCTAssertTrue([mockedPlace canUpdateFollowingIn], @"user can create this type");
    XCTAssertNoThrow([mockedPlace verify]);
}

@end
