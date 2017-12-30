//
//  JiveEmbeddedTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveEmbeddedTests.h"
#import "JiveEmbedded.h"

@implementation JiveEmbeddedTests

- (void)setUp {
    [super setUp];
    self.object = [JiveEmbedded new];
}

- (JiveEmbedded *)embedded {
    return (JiveEmbedded *)self.object;
}

- (void)testToJSON {
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"context" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"preferredExperience" forKey:@"key"];
    NSDictionary *JSON = [self.embedded toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self.embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"gadget"];
    [self.embedded setValue:@"image data" forKey:@"previewImage"];
    [self.embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.embedded setValue:context forKey:@"context"];
    [self.embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    JSON = [self.embedded toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"previewImage"], self.embedded.previewImage, @"Wrong previewImage.");
    XCTAssertEqualObjects([JSON objectForKey:@"context"], self.embedded.context, @"Wrong context.");
    XCTAssertEqualObjects([JSON objectForKey:@"preferredExperience"], self.embedded.preferredExperience, @"Wrong preferredExperience.");
    XCTAssertEqualObjects([JSON objectForKey:@"gadget"], [self.embedded.gadget absoluteString], @"Wrong gadget.");
    XCTAssertEqualObjects([JSON objectForKey:@"url"], [self.embedded.url absoluteString], @"Wrong url.");
}

- (void)testToJSON_alternate {
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"wrong" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"not preferred" forKey:@"key"];
    NSDictionary *JSON = [self.embedded toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self.embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"gadget"];
    [self.embedded setValue:@"http://preview.com/image.png" forKey:@"previewImage"];
    [self.embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [self.embedded setValue:context forKey:@"context"];
    [self.embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    JSON = [self.embedded toJSONDictionary];
    
    XCTAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    XCTAssertEqual([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    XCTAssertEqualObjects([JSON objectForKey:@"previewImage"], self.embedded.previewImage, @"Wrong previewImage.");
    XCTAssertEqualObjects([JSON objectForKey:@"context"], self.embedded.context, @"Wrong context.");
    XCTAssertEqualObjects([JSON objectForKey:@"preferredExperience"], self.embedded.preferredExperience, @"Wrong preferredExperience.");
    XCTAssertEqualObjects([JSON objectForKey:@"gadget"], [self.embedded.gadget absoluteString], @"Wrong gadget.");
    XCTAssertEqualObjects([JSON objectForKey:@"url"], [self.embedded.url absoluteString], @"Wrong url.");
}

- (void)testEmbeddedParsing {
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"context" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"preferredExperience" forKey:@"key"];
    
    [self.embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"gadget"];
    [self.embedded setValue:@"image data" forKey:@"previewImage"];
    [self.embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.embedded setValue:context forKey:@"context"];
    [self.embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    id JSON = [self.embedded toJSONDictionary];
    JiveEmbedded *newEmbedded = [JiveEmbedded objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newEmbedded class], [JiveEmbedded class], @"Wrong item class");
    XCTAssertEqualObjects(newEmbedded.gadget, self.embedded.gadget, @"Wrong gadget");
    XCTAssertEqualObjects(newEmbedded.previewImage, self.embedded.previewImage, @"Wrong previewImage");
    XCTAssertEqualObjects(newEmbedded.url, self.embedded.url, @"Wrong url");
    XCTAssertEqualObjects(newEmbedded.context, self.embedded.context, @"Wrong context");
    XCTAssertEqualObjects(newEmbedded.preferredExperience, self.embedded.preferredExperience, @"Wrong preferredExperience");
}

- (void)testEmbeddedParsingAlternate {
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"wrong" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"not preferred" forKey:@"key"];
    
    [self.embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"gadget"];
    [self.embedded setValue:@"http://preview.com/image.png" forKey:@"previewImage"];
    [self.embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [self.embedded setValue:context forKey:@"context"];
    [self.embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    id JSON = [self.embedded toJSONDictionary];
    JiveEmbedded *newEmbedded = [JiveEmbedded objectFromJSON:JSON withInstance:self.instance];
    
    XCTAssertEqual([newEmbedded class], [JiveEmbedded class], @"Wrong item class");
    XCTAssertEqualObjects(newEmbedded.gadget, self.embedded.gadget, @"Wrong gadget");
    XCTAssertEqualObjects(newEmbedded.previewImage, self.embedded.previewImage, @"Wrong previewImage");
    XCTAssertEqualObjects(newEmbedded.url, self.embedded.url, @"Wrong url");
    XCTAssertEqualObjects(newEmbedded.context, self.embedded.context, @"Wrong context");
    XCTAssertEqualObjects(newEmbedded.preferredExperience, self.embedded.preferredExperience, @"Wrong preferredExperience");
}

@end
