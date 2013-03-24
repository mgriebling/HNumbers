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

// NOTE: MUST BE CALLED BEFORE ANYTHING ELSE
+ (void)initWithDigits:(NSUInteger)digits;

+ (id)zero;
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


- (id)initWithNumber:(HNumber *)number;
- (id)initWithInteger:(unsigned long long)integer exponent:(NSInteger)exponent isNegative:(BOOL)isNegative;
- (id)initWithDouble:(double)number;
- (id)initWithDouble:(double)real imaginary:(double)imaginary;
- (id)initWithString:(NSString *)real imaginaryString:(NSString *)imaginary;

- (NSString *)description;
- (NSString *)stringWithBase:(NSInteger)base andFormat:(NumberFormat)format;

- (HNumber *)real;
- (HNumber *)imaginary;
- (HNumber *)integer;

- (HNumber *)add:(HNumber *)complex;
- (HNumber *)subtract:(HNumber *)complex;
- (HNumber *)multiply:(HNumber *)complex;
- (HNumber *)divide:(HNumber *)complex;

- (HNumber *)exponential;
- (HNumber *)naturalLogarithm;
- (HNumber *)base10Logarithm;
- (HNumber *)sine;
- (HNumber *)cosine;
- (HNumber *)squared;
- (HNumber *)squareRoot;
- (HNumber *)absolute;
- (HNumber *)argument;
- (HNumber *)powerToExponent:(HNumber *)exponent;

- (BOOL)isEqual:(id)object;

// functions only in real number domain -- for now
- (HNumber *)tangent;
- (HNumber *)hyperbolicSine;
- (HNumber *)hyperbolicCosine;
- (HNumber *)hyperbolicTangent;
- (HNumber *)arcTangent;
- (HNumber *)arcTangentWithY:(HNumber *)y;
- (HNumber *)arcSine;
- (HNumber *)arcCosine;
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
- (HNumber *)setBit:(NSUInteger)bit;
- (HNumber *)clearBit:(NSUInteger)bit;
- (HNumber *)toggleBit:(NSUInteger)bit;
- (NSUInteger)numberOfOneBits;
- (NSUInteger)sizeInBits;
- (HNumber *)factorial;

- (HNumber *)andWith:(HNumber *)number;
- (HNumber *)orWith:(HNumber *)number;
- (HNumber *)xorWith:(HNumber *)number;
- (HNumber *)norWith:(HNumber *)number;
- (HNumber *)nandWith:(HNumber *)number;
- (HNumber *)xnorWith:(HNumber *)number;
- (HNumber *)onesComplement;
- (HNumber *)twosComplement;

@end
