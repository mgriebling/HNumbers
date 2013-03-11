//
//  ExNumbers.m
//  ExNumbers
//
//  Created by Mike Griebling on 10.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "ExNumbers.h"
#import "mp_complex.h"

@implementation ExNumbers {
    mp_complex num;
}

- (id)initFromMPComplex:(mp_complex)complex {
    self = [super init];
    if (self) {
        num = complex;
    }
    return self;
}

- (id)initFromExNumber:(ExNumbers *)exNumber {
    return [self initFromMPComplex:exNumber->num];
}

- (id)initFromInteger:(NSInteger)integer {
    mp_complex x = mp_complex(mp_real(integer), mp_real(0.0));
    return [self initFromMPComplex:x];
}

- (id)initFromDouble:(double)number {
    return [self initFromComplex:number imaginary:0];
}

- (id)initFromComplex:(double)real imaginary:(double)imaginary {
    mp_complex x = mp_complex(mp_real(real), mp_real(imaginary));
    return [self initFromMPComplex:x];
}

- (id)initFromExComplex:(mp_real)real imaginary:(mp_real)imaginary {
    mp_complex x = mp_complex(real, imaginary);
    return [self initFromMPComplex:x];
}

+ (id)numberFromExComplex:(mp_real)real imaginary:(mp_real)imaginary {
    return [[ExNumbers alloc] initFromExComplex:real imaginary:imaginary];
}

+ (id)numberFromComplex:(double)real imaginary:(double)imaginary {
    return [[ExNumbers alloc] initFromComplex:real imaginary:imaginary];
}

+ (id)numberFromMPComplex:(mp_complex)complex {
    return [[ExNumbers alloc] initFromMPComplex:complex];
}

- (id)initFromString:(NSString *)real imaginaryString:(NSString *)imaginary {
    mp_real realNum = mp_real([real cStringUsingEncoding:NSASCIIStringEncoding]);
    mp_real imagNum = mp_real([imaginary cStringUsingEncoding:NSASCIIStringEncoding]);
    return [self initFromMPComplex:mp_complex(realNum, imagNum)];
}

+ (id)zero {
    return [[ExNumbers alloc] initFromInteger:0];
}

+ (id)pi {
    return [[ExNumbers alloc] initFromExComplex:mp_real::_pi imaginary:mp_real(0.0)];
}

+ (id)log2 {
    return [[ExNumbers alloc] initFromExComplex:mp_real::_log2 imaginary:mp_real(0.0)];
}

+ (id)log10 {
    return [[ExNumbers alloc] initFromExComplex:mp_real::_log10 imaginary:mp_real(0.0)];
}

+ (id)eps {
    return [[ExNumbers alloc] initFromExComplex:mp_real::_eps imaginary:mp_real(0.0)];
}

- (ExNumbers *)real {
    return [[ExNumbers alloc] initFromExComplex:num.real imaginary:mp_real(0.0)];
}

- (ExNumbers *)imaginary {
    return [[ExNumbers alloc] initFromExComplex:num.imag imaginary:mp_real(0.0)];
}

+ (id)numberFromInteger:(NSInteger)integer {
    return [[ExNumbers alloc] initFromInteger:integer];
}

+ (id)numberFromDouble:(double)number {
    return [[ExNumbers alloc] initFromDouble:number];
}

+ (id)numberFromString:(NSString *)real imaginaryString:(NSString *)imaginary {
    return [[ExNumbers alloc] initFromString:real imaginaryString:imaginary];
}

- (ExNumbers *)add:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:num + complex->num];
}

- (ExNumbers *)subtract:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:num - complex->num];
}

- (ExNumbers *)multiply:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:num * complex->num];
}

- (ExNumbers *)divide:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:num / complex->num];
}

- (ExNumbers *)exponential {
    return [ExNumbers numberFromMPComplex:exp(self->num)];
}

- (ExNumbers *)naturalLogarithm {
    return [ExNumbers numberFromMPComplex:log(self->num)];
}

- (ExNumbers *)base10Logarithm {
    return [ExNumbers numberFromMPComplex:log(self->num)/mp_real::_log10];
}

- (ExNumbers *)sine {
    return [ExNumbers numberFromMPComplex:sin(self->num)];
}

- (ExNumbers *)cosine {
    return [ExNumbers numberFromMPComplex:cos(self->num)];
}

- (ExNumbers *)squared {
    return [ExNumbers numberFromMPComplex:sqr(self->num)];
}

- (ExNumbers *)squareRoot {
    return [ExNumbers numberFromMPComplex:sqrt(self->num)];
}

- (ExNumbers *)absolute {
    return [ExNumbers numberFromExComplex:abs(self->num) imaginary:mp_real(0.0)];
}

- (ExNumbers *)argument {
    return [ExNumbers numberFromExComplex:arg(self->num) imaginary:mp_real(0.0)];
}

- (ExNumbers *)powerToExponent:(ExNumbers *)exponent {
    return [ExNumbers numberFromMPComplex:exp(self->num)];
}


@end
