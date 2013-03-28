//
//  HNumber.h
//  HNumber
//
//  Created by Mike Griebling on 10.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNumber : NSObject

typedef enum {FORMAT_STANDARD, FORMAT_SCIENTIFIC, FORMAT_ENGINEERING} NumberFormat;

// Number formatting methods
+ (NSInteger)displayLength;
+ (NSInteger)decimalPoints;
+ (NSString *)decimalPoint;
+ (NSString *)groupingSeparator;
+ (NumberFormat)format;

+ (void) setDisplayLength:(NSInteger)len;
+ (void) setDecimalPoints:(NSInteger)decimals;
+ (void) setDecimalPoint:(NSString*)dp;
+ (void) setGroupingSeparator:(NSString*)groupSep;
+ (void) setFormat : (NumberFormat)mode;

+ (id)zero;
+ (id)one;
+ (id)i;
+ (id)exp;
+ (id)pi;
+ (id)log2;
+ (id)log10;
+ (id)eps;

+ (id)numberWithNumber:(HNumber *)number;
+ (id)numberWithInteger:(unsigned long long)integer exponent:(NSInteger)exponent isNegative:(BOOL)isNegative;
+ (id)numberWithDouble:(double)number;
+ (id)numberWithDouble:(double)real imaginary:(double)imaginary;
+ (id)numberWithString:(NSString *)string;
+ (id)numberWithString:(NSString *)string locale:(NSDictionary *)locale;
+ (id)numberWithString:(NSString *)string usingBase:(short)base;


- (id)initWithNumber:(HNumber *)number;
- (id)initWithInteger:(unsigned long long)integer exponent:(NSInteger)exponent isNegative:(BOOL)isNegative;
- (id)initWithDouble:(double)number;
- (id)initWithDouble:(double)real imaginary:(double)imaginary;
- (id)initWithString:(NSString *)string;
- (id)initWithString:(NSString *)string locale:(NSDictionary *)locale;
- (id)initWithString:(NSString *)string usingBase:(short)base;

- (NSString *)description;
- (NSString *)stringUsingBase:(short)base;
- (NSString *)stringUsingLocale:(NSDictionary *)locale;

- (HNumber *)realPart;
- (HNumber *)imaginaryPart;
- (double)doubleValue;

- (HNumber *)add:(HNumber *)complex;
- (HNumber *)subtract:(HNumber *)complex;
- (HNumber *)multiplyBy:(HNumber *)complex;
- (HNumber *)divideBy:(HNumber *)complex;
- (HNumber *)conjugate;

- (HNumber *)exponential;
- (HNumber *)naturalLogarithm;
- (HNumber *)base10Logarithm;
- (HNumber *)base2Logarithm;
- (HNumber *)sine;
- (HNumber *)cosine;
- (HNumber *)tangent;
- (HNumber *)hyperbolicSine;
- (HNumber *)hyperbolicCosine;
- (HNumber *)hyperbolicTangent;
- (HNumber *)inverseSine;
- (HNumber *)inverseCosine;
- (HNumber *)inverseTangent;
- (HNumber *)inverseHyperbolicSine;
- (HNumber *)inverseHyperbolicCosine;
- (HNumber *)inverseHyperbolicTangent;

- (HNumber *)squared;
- (HNumber *)squareRoot;
- (HNumber *)cubed;
- (HNumber *)cubeRoot;
- (HNumber *)anyRoot:(short)root;

- (HNumber *)absoluteValue;
- (HNumber *)argument;
- (HNumber *)round;
- (HNumber *)truncate;

- (HNumber *)signOfRealPart;
- (HNumber *)minimumOfRealParts:(HNumber *)number;
- (HNumber *)maximumOfRealParts:(HNumber *)number;

- (HNumber *)multiplyByPowerOf10:(int)power;
- (HNumber *)multiplyByPowerOf2:(int)power;
- (HNumber *)raiseToPower:(HNumber *)exponent;
- (HNumber *)raiseToIntegerPower:(int)power;
- (HNumber *)raiseToDoublePower:(double)power;

- (BOOL)isEqual:(id)object;

// functions only in real number domain -- for now
- (HNumber *)random;
- (HNumber *)floatingModulus:(HNumber *)modulus;

// special functions in real number domain
- (HNumber *)gamma;
- (HNumber *)erfc;
- (HNumber *)erf;
- (HNumber *)bessel;
- (HNumber *)besselexp;

- (BOOL)isGreaterThan:(HNumber *)object;
- (BOOL)isLessThan:(HNumber *)object;

// integer-based operations -- result will be an integer
- (HNumber *)integerDivideBy:(HNumber *)number;
- (HNumber *)moduloWith:(HNumber *)number;
- (HNumber *)shiftBy:(HNumber *)bits;
- (HNumber *)signedShiftBy:(HNumber *)bits;
- (HNumber *)rotateBy:(HNumber *)bits;
- (HNumber *)setBit:(HNumber *)bit;
- (HNumber *)clearBit:(HNumber *)bit;
- (HNumber *)toggleBit:(HNumber *)bit;
- (NSUInteger)numberOfOneBits;
- (NSUInteger)sizeInBits;
- (HNumber *)factorial;
- (HNumber *)nCr:(HNumber *)number;
- (HNumber *)nPr:(HNumber *)number;
- (HNumber *)GCD:(HNumber *)number;
- (HNumber *)fibonacci;

- (HNumber *)andWith:(HNumber *)number;
- (HNumber *)orWith:(HNumber *)number;
- (HNumber *)xorWith:(HNumber *)number;
- (HNumber *)norWith:(HNumber *)number;
- (HNumber *)nandWith:(HNumber *)number;
- (HNumber *)xnorWith:(HNumber *)number;
- (HNumber *)onesComplement;
- (HNumber *)twosComplement;

@end
