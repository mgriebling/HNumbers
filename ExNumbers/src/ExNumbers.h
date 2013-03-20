//
//  ExNumbers.h
//  ExNumbers
//
//  Created by Mike Griebling on 10.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExNumbers : NSObject

typedef enum {FORMAT_STANDARD, FORMAT_SCIENTIFIC, FORMAT_ENGINEERING} NumberFormat;

// NOTE: MUST BE CALLED BEFORE ANYTHING ELSE
+ (void)initWithDigits:(NSUInteger)digits;

+ (id)zero;
+ (id)pi;
+ (id)log2;
+ (id)log10;
+ (id)eps;

+ (id)numberFromExNumber:(ExNumbers *)exNumber;
+ (id)numberFromInteger:(NSInteger)integer;
+ (id)numberFromDouble:(double)number;
+ (id)numberFromComplex:(double)real imaginary:(double)imaginary;
+ (id)numberFromString:(NSString *)real imaginaryString:(NSString *)imaginary;

- (id)initFromExNumber:(ExNumbers *)exNumber;
- (id)initFromInteger:(NSInteger)integer;
- (id)initFromDouble:(double)number;
- (id)initFromComplex:(double)real imaginary:(double)imaginary;
- (id)initFromString:(NSString *)real imaginaryString:(NSString *)imaginary;

- (NSString *)description;
- (NSString *)stringWithBase:(NSInteger)base andFormat:(NumberFormat)format;

- (ExNumbers *)real;
- (ExNumbers *)imaginary;
- (ExNumbers *)integer;

- (ExNumbers *)add:(ExNumbers *)complex;
- (ExNumbers *)subtract:(ExNumbers *)complex;
- (ExNumbers *)multiply:(ExNumbers *)complex;
- (ExNumbers *)divide:(ExNumbers *)complex;

- (ExNumbers *)exponential;
- (ExNumbers *)naturalLogarithm;
- (ExNumbers *)base10Logarithm;
- (ExNumbers *)sine;
- (ExNumbers *)cosine;
- (ExNumbers *)squared;
- (ExNumbers *)squareRoot;
- (ExNumbers *)absolute;
- (ExNumbers *)argument;
- (ExNumbers *)powerToExponent:(ExNumbers *)exponent;

- (BOOL)isEqual:(id)object;

// functions only in real number domain -- for now
- (ExNumbers *)tangent;
- (ExNumbers *)hyperbolicSine;
- (ExNumbers *)hyperbolicCosine;
- (ExNumbers *)hyperbolicTangent;
- (ExNumbers *)arcTangent;
- (ExNumbers *)arcTangentWithY:(ExNumbers *)y;
- (ExNumbers *)arcSine;
- (ExNumbers *)arcCosine;
- (ExNumbers *)random;
- (ExNumbers *)floatingModulus:(ExNumbers *)modulus;

// special functions in real number domain
- (ExNumbers *)gamma;
- (ExNumbers *)erfc;
- (ExNumbers *)erf;
- (ExNumbers *)bessel;
- (ExNumbers *)besselexp;

- (BOOL)isGreaterThan:(ExNumbers *)object;
- (BOOL)isLessThan:(ExNumbers *)object;

// integer-based operations -- result will be an integer
- (ExNumbers *)setBit:(NSUInteger)bit;
- (ExNumbers *)clearBit:(NSUInteger)bit;
- (ExNumbers *)toggleBit:(NSUInteger)bit;
- (NSUInteger)numberOfOneBits;
- (NSUInteger)sizeInBits;
- (ExNumbers *)factorial;

- (ExNumbers *)andWith:(ExNumbers *)number;
- (ExNumbers *)orWith:(ExNumbers *)number;
- (ExNumbers *)xorWith:(ExNumbers *)number;
- (ExNumbers *)norWith:(ExNumbers *)number;
- (ExNumbers *)nandWith:(ExNumbers *)number;
- (ExNumbers *)xnorWith:(ExNumbers *)number;
- (ExNumbers *)onesComplement;
- (ExNumbers *)twosComplement;

@end
