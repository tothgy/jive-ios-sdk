//
//  JivePlatformVersionTest.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
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

#import "JivePlatformVersionTests.h"
#import "JivePlatformVersion.h"
#import "JiveCoreVersion.h"
#import <OCMock/OCMock.h>

@interface JivePlatformVersion (TestSupport)
- (BOOL)supportsFeatureAvailableWithMajorVersion:(NSUInteger)majorVersion
                                    minorVersion:(NSUInteger)minorVersion
                              maintenanceVersion:(NSUInteger)maintenanceVersion
                                    buildVersion:(NSUInteger)buildVersion;
@end

@implementation JivePlatformVersionTests

- (void)setUp {
    [super setUp];
    self.object = [JivePlatformVersion new];
}

- (void)testVersionParsing {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *sdkVersion = [JivePlatformVersion new].sdk;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"https://dummy.com/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    XCTAssertNotNil(sdkVersion, @"PRECONDITION: Invalid sdk version");
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertNil(version.ssoEnabled, @"Invalid ssoEnabled result");
    XCTAssertEqualObjects(version.sdk, sdkVersion, @"Invalid sdk version number");
    XCTAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Invalid instance URL");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        XCTAssertEqual([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        XCTAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        XCTAssertEqual([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        XCTAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsing_preLogin {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *sdkVersion = [JivePlatformVersion new].sdk;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"https://dummy.com/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    XCTAssertNotNil(sdkVersion, @"PRECONDITION: Invalid sdk version");
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:[Jive new]];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertNil(version.ssoEnabled, @"Invalid ssoEnabled result");
    XCTAssertEqualObjects(version.sdk, sdkVersion, @"Invalid sdk version number");
    XCTAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Invalid instance URL");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        XCTAssertEqual([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        XCTAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        XCTAssertEqual([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        XCTAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsingAlternate {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSNumber *build = @3;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertNil(version.instanceURL, @"There should be no instance URL here");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
    if (version.coreURI.count == 2) {
        JiveCoreVersion *version2 = version.coreURI[0];
        
        XCTAssertEqual([version2 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version2.version, apiVersion2, @"Wrong version number");
        XCTAssertEqualObjects(version2.revision, apiVersion2Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version2.uri, coreVersion2URI, @"Wrong uri number");
        
        JiveCoreVersion *version3 = version.coreURI[1];
        
        XCTAssertEqual([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        XCTAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testVersionParsing_NoReleaseID {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSNumber *build = @3;
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@",
                                              major, minor, maintenance, build],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    XCTAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertNil(version.releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsing_NoBuild {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSNumber *maintenance = @2;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@ %@",
                                              major, minor, maintenance, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    XCTAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertNil(version.build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsing_NoMaintenance {
    NSNumber *apiVersion2 = @1;
    NSNumber *apiVersion2Revision = @2;
    NSString *coreVersion2URI = @"/api/core/v1";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v1/rest"
                                    };
    NSNumber *apiVersion3 = @4;
    NSNumber *apiVersion3Revision = @6;
    NSString *coreVersion3URI = @"/api/core/v4";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v4/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @6;
    NSNumber *minor = @1;
    NSString *releaseID = @"6c5";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@ %@",
                                              major, minor, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    JivePlatformVersion *version;
    
    XCTAssertNoThrow(version = [JivePlatformVersion objectFromJSON:JSON
                                                       withInstance:self.instance], @"Should not throw");
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertNil(version.maintenance, @"Wrong maintenance version");
    XCTAssertNil(version.build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)2, @"Wrong number of core URIs");
}

- (void)testVersionParsingInvalidJSON_WrongTags {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"version" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"versions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    XCTAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsingInvalidJSON_MissingVersion {
    NSNumber *apiVersion2 = @2;
    NSNumber *apiVersion2Revision = @3;
    NSString *coreVersion2URI = @"/api/core/v2";
    NSDictionary *version2JSON = @{ @"version" : apiVersion2,
                                    @"revision" : apiVersion2Revision,
                                    @"uri" : coreVersion2URI,
                                    @"documentation" : @"https://developers.jivesoftware.com/api/v2/rest"
                                    };
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version2JSON, version3JSON];
    NSDictionary *JSON = @{ @"versions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    XCTAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsingInvalidJSON_MissingCoreVersions {
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"version" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                          major, minor, maintenance, build, releaseID],
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    XCTAssertNil(version, @"Invalid JSON parsed");
}

- (void)testVersionParsing_SingleVersion {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    if (version.coreURI.count == 1) {
        JiveCoreVersion *version3 = version.coreURI[0];
        
        XCTAssertEqual([version3 class], [JiveCoreVersion class], @"Wrong sub-item class");
        XCTAssertEqualObjects(version3.version, apiVersion3, @"Wrong version number");
        XCTAssertEqualObjects(version3.revision, apiVersion3Revision, @"Wrong revision number");
        XCTAssertEqualObjects(version3.uri, coreVersion3URI, @"Wrong uri number");
    }
}

- (void)testSSOEnabledParsing {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSArray *ssoTypes = @[@"sso"];
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"ssoEnabled" : ssoTypes
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                            withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    XCTAssertEqual(version.ssoEnabled.count, (NSUInteger)1, @"Wrong number of ssoEnabled entries");
    if (version.ssoEnabled.count > 0) {
        XCTAssertEqual(version.ssoEnabled[0], ssoTypes[0], @"Wrong sso type");
    }
    
    XCTAssertFalse([version allowsSSOForOAuth]);
}

- (void)testSsoForOAuthGrantEnabledParsing {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSArray *ssoTypes = @[@"sso"];
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"ssoEnabled" : ssoTypes,
                            @"ssoForOAuthGrantEnabled" : @YES
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
    XCTAssertEqual(version.ssoEnabled.count, (NSUInteger)1, @"Wrong number of ssoEnabled entries");
    if (version.ssoEnabled.count > 0) {
        XCTAssertEqual(version.ssoEnabled[0], ssoTypes[0], @"Wrong sso type");
    }
    
    XCTAssertTrue([version allowsSSOForOAuth]);
}

- (void)testInstanceURL {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSString *instanceURL = @"http://alternate.net/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURL
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqualObjects([version.instanceURL absoluteString], instanceURL, @"Wrong instance URL");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
}

- (void)testInstanceURLWithoutTrailingSlash {
    NSNumber *apiVersion3 = @3;
    NSNumber *apiVersion3Revision = @3;
    NSString *coreVersion3URI = @"/api/core/v3";
    NSDictionary *version3JSON = @{ @"version" : apiVersion3,
                                    @"revision" : apiVersion3Revision,
                                    @"uri" : coreVersion3URI,
                                    @"documentation" : @"https://docs.developers.jivesoftware.com/api/v3/cloud/rest"
                                    };
    NSArray *versionsArray = @[version3JSON];
    NSNumber *major = @7;
    NSNumber *minor = @0;
    NSNumber *maintenance = @0;
    NSNumber *build = @0;
    NSString *releaseID = @"7c2";
    NSString *instanceURLWithoutSlash = @"http://alternate.net";
    NSString *instanceURLWithSlash = @"http://alternate.net/";
    NSDictionary *JSON = @{ @"jiveVersion" : [NSString stringWithFormat:@"%@.%@.%@.%@ %@",
                                              major, minor, maintenance, build, releaseID],
                            @"jiveCoreVersions" : versionsArray,
                            @"instanceURL" : instanceURLWithoutSlash
                            };
    
    JivePlatformVersion *version = [JivePlatformVersion objectFromJSON:JSON
                                                          withInstance:self.instance];
    
    XCTAssertEqual([version class], [JivePlatformVersion class], @"Wrong item class");
    XCTAssertEqualObjects(version.major, major, @"Wrong major version");
    XCTAssertEqualObjects(version.minor, minor, @"Wrong minor version");
    XCTAssertEqualObjects(version.maintenance, maintenance, @"Wrong maintenance version");
    XCTAssertEqualObjects(version.build, build, @"Wrong build version");
    XCTAssertEqualObjects(version.releaseID, releaseID, @"Wrong releaseID version");
    XCTAssertEqualObjects([version.instanceURL absoluteString], instanceURLWithSlash, @"Wrong instance URL");
    XCTAssertEqual(version.coreURI.count, (NSUInteger)1, @"Wrong number of core URIs");
}

- (void)test_supportsFeatureAvailableWithMajorVersion_minorVersion_maintenanceVersion_valid {
    JivePlatformVersion *version = [JivePlatformVersionTests jivePlatformVersionWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0];
    
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:1 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:5 minorVersion:8 maintenanceVersion:8 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0], @"Feature should be supported for platform version");
    
    version = [JivePlatformVersionTests jivePlatformVersionWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:0 minorVersion:0 maintenanceVersion:1 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:5 minorVersion:8 maintenanceVersion:8 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:2 buildVersion:0], @"Feature should be supported for platform version");
    XCTAssertTrue([version supportsFeatureAvailableWithMajorVersion:6 minorVersion:5 maintenanceVersion:3 buildVersion:0], @"Feature should be supported for platform version");
}

- (void)test_supportsDraftPostCreation {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsDraftPostCreation], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsDraftPostCreation], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsDraftPostContentFilter {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsDraftPostContentFilter], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsDraftPostContentFilter], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsExplicitSSO {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0];
    XCTAssertFalse([version supportsExplicitSSO], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:2 buildVersion:0];
    XCTAssertTrue([version supportsExplicitSSO], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsFollowing {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:4 buildVersion:0];
    XCTAssertFalse([version supportsFollowing], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:4 buildVersion:0];
    XCTAssertTrue([version supportsFollowing], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsStatusUpdateInPlace {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsStatusUpdateInPlace], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsStatusUpdateInPlace], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsBookmarkInboxEntries {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsBookmarkInboxEntries], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsBookmarkInboxEntries], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsCorrectAndHelpfulReplies {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsCorrectAndHelpfulReplies], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsCorrectAndHelpfulReplies], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsStructuredOutcomes {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsStructuredOutcomes], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsStructuredOutcomes], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsUnmarkAsCorrectAnswer {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsUnmarkAsCorrectAnswer], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsUnmarkAsCorrectAnswer], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsExplicitCorrectAnswerAPI {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsExplicitCorrectAnswerAPI], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsExplicitCorrectAnswerAPI], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsDiscussionLikesInActivityObjects {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsDiscussionLikesInActivityObjects], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsDiscussionLikesInActivityObjects], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsInboxTypeFiltering {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsInboxTypeFiltering], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsInboxTypeFiltering], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsCommentAndReplyPermissions {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsCommentAndReplyPermissions], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsCommentAndReplyPermissions], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportedIPhoneVersion {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportedIPhoneVersion], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportedIPhoneVersion], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsOAuth {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsOAuth], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsOAuth], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsOAuthSessionGrant {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    XCTAssertFalse([version supportsOAuthSessionGrant], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    XCTAssertTrue([version supportsOAuthSessionGrant], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsFeatureModuleVideoProperty {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    XCTAssertFalse([version supportsFeatureModuleVideoProperty], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:1 buildVersion:0];
    XCTAssertTrue([version supportsFeatureModuleVideoProperty], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsContentEditingAPI {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsContentEditingAPI], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsContentEditingAPI], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsLikeCountInStreams {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertFalse([version supportsLikeCountInStreams], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:0];
    XCTAssertTrue([version supportsLikeCountInStreams], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsNativeAppAllowed {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:2];
    XCTAssertFalse([version supportsNativeAppAllowed], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:6 minorVersion:0 maintenanceVersion:3 buildVersion:2];
    XCTAssertTrue([version supportsNativeAppAllowed], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsCollapsingStreams {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsCollapsingStreams], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:7 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsCollapsingStreams], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

- (void)test_supportsOriginParam {
    id version = [OCMockObject partialMockForObject:[JivePlatformVersionTests jivePlatformVersionWithMajorVersion:0 minorVersion:0 maintenanceVersion:0 buildVersion:0]];
    
    [[[version expect] andReturnValue:@NO] supportsFeatureAvailableWithMajorVersion:8 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertFalse([version supportsOriginParam], @"should not support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
    
    [[[version expect] andReturnValue:@YES] supportsFeatureAvailableWithMajorVersion:8 minorVersion:0 maintenanceVersion:0 buildVersion:0];
    XCTAssertTrue([version supportsOriginParam], @"should support this feature");
    XCTAssertNoThrow([version verify], @"verify failure");
}

#pragma mark - Factory methods

+ (JivePlatformVersion *)jivePlatformVersionWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion maintenanceVersion:(NSUInteger)maintenanceVersion buildVersion:(NSUInteger)buildVersion {
    JivePlatformVersion *version = [[JivePlatformVersion alloc] init];
    
    [version setValue:@(majorVersion) forKey:JivePlatformVersionAttributes.major];
    [version setValue:@(minorVersion) forKey:JivePlatformVersionAttributes.minor];
    [version setValue:@(maintenanceVersion) forKey:JivePlatformVersionAttributes.maintenance];
    [version setValue:@(buildVersion) forKey:JivePlatformVersionAttributes.build];
    
    return version;
}

@end
