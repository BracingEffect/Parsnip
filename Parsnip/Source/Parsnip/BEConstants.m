//
//  BEConstants.m
//
//  Copyright (c) 2015 Bracing Effect, LLC. See LICENSE for details.
//

#import "BeConstants.h"


static NSArray *_states;
static NSArray *_statesAbbr;
static NSArray *_statesTrunc;


@implementation BEConstants

+ (void)initialize
{
    _states = @[@"ALABAMA",
                @"ALASKA",
                @"AMERICAN SAMOA",
                @"ARIZONA",
                @"ARKANSAS",
                @"CALIFORNIA",
                @"COLORADO",
                @"CONNECTICUT",
                @"DELAWARE",
                @"DISTRICT OF COLUMBIA",
                @"FEDERATED STATES OF MICRONESIA",
                @"FLORIDA",
                @"GEORGIA",
                @"GUAM",
                @"HAWAII",
                @"IDAHO",
                @"ILLINOIS",
                @"INDIANA",
                @"IOWA",
                @"KANSAS",
                @"KENTUCKY",
                @"LOUISIANA",
                @"MAINE",
                @"MARSHALL ISLANDS",
                @"MARYLAND",
                @"MASSACHUSETTS",
                @"MICHIGAN",
                @"MINNESOTA",
                @"MISSISSIPPI",
                @"MISSOURI",
                @"MONTANA",
                @"NEBRASKA",
                @"NEVADA",
                @"NEW HAMPSHIRE",
                @"NEW JERSEY",
                @"NEW MEXICO",
                @"NEW YORK",
                @"NORTH CAROLINA",
                @"NORTH DAKOTA",
                @"NORTHERN MARIANA ISLANDS",
                @"OHIO",
                @"OKLAHOMA",
                @"OREGON",
                @"PALAU",
                @"PENNSYLVANIA",
                @"PUERTO RICO",
                @"RHODE ISLAND",
                @"SOUTH CAROLINA",
                @"SOUTH DAKOTA",
                @"TENNESSEE",
                @"TEXAS",
                @"UTAH",
                @"VERMONT",
                @"VIRGIN ISLANDS",
                @"VIRGINIA",
                @"WASHINGTON",
                @"WEST VIRGINIA",
                @"WISCONSIN",
                @"WYOMING"];

    _statesAbbr = @[@"AL",
                    @"AK",
                    @"AS",
                    @"AZ",
                    @"AR",
                    @"CA",
                    @"CO",
                    @"CT",
                    @"DE",
                    @"DC",
                    @"FM",
                    @"FL",
                    @"GA",
                    @"GU",
                    @"HI",
                    @"ID",
                    @"IL",
                    @"IN",
                    @"IA",
                    @"KS",
                    @"KY",
                    @"LA",
                    @"ME",
                    @"MH",
                    @"MD",
                    @"MA",
                    @"MI",
                    @"MN",
                    @"MS",
                    @"MO",
                    @"MT",
                    @"NE",
                    @"NV",
                    @"NH",
                    @"NJ",
                    @"NM",
                    @"NY",
                    @"NC",
                    @"ND",
                    @"MP",
                    @"OH",
                    @"OK",
                    @"OR",
                    @"PW",
                    @"PA",
                    @"PR",
                    @"RI",
                    @"SC",
                    @"SD",
                    @"TN",
                    @"TX",
                    @"UT",
                    @"VT",
                    @"VI",
                    @"VA",
                    @"WA",
                    @"WV",
                    @"WI",
                    @"WY"];

    _statesTrunc = @[@"ALABAMA",
                     @"ALASKA",
                     @"AMERICAN",
                     @"ARIZONA",
                     @"ARKANSAS",
                     @"CALIFORN",
                     @"COLORADO",
                     @"CONNECTI",
                     @"DELAWARE",
                     @"DISTRICT",
                     @"FEDERATE",
                     @"FLORIDA",
                     @"GEORGIA",
                     @"GUAM GU",
                     @"HAWAII",
                     @"IDAHO",
                     @"ILLINOIS",
                     @"INDIANA",
                     @"IOWA",
                     @"KANSAS",
                     @"KENTUCKY",
                     @"LOUISIAN",
                     @"MAINE",
                     @"MARSHALL",
                     @"MARYLAND",
                     @"MASSACHU",
                     @"MICHIGAN",
                     @"MINNESOT",
                     @"MISSISSI",
                     @"MISSOURI",
                     @"MONTANA",
                     @"NEBRASKA",
                     @"NEVADA",
                     @"NEW HAMP",
                     @"NEW JERS",
                     @"NEW MEXI",
                     @"NEW YORK",
                     @"NORTH CA",
                     @"NORTH DA",
                     @"NORTHERN",
                     @"OHIO",
                     @"OKLAHOMA",
                     @"OREGON",
                     @"PALAU",
                     @"PENNSYLV",
                     @"PUERTO R",
                     @"RHODE IS",
                     @"SOUTH CA",
                     @"SOUTH DA",
                     @"TENNESSE",
                     @"TEXAS",
                     @"UTAH",
                     @"VERMONT",
                     @"VIRGIN I",
                     @"VIRGINIA",
                     @"WASHINGT",
                     @"WEST VIR",
                     @"WISCONSI"];
}

+ (NSArray *)states
{
    return _states;
}

+ (NSArray *)statesAbbr
{
    return _statesAbbr;
}

+ (NSArray *)statesTrunc
{
    return _statesTrunc;
}

@end
