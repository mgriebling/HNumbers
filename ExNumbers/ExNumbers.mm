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

static BOOL libInitialized = NO;

#define DEFAULT_DIGITS  16

+ (void)initWithDigits:(NSUInteger)digits {
    if (!libInitialized) {
        // need to initialize the base library constants and precision
        mp::mp_init(digits);
        libInitialized = YES;
    }
}

+ (mp_real)mp_zero {
    [ExNumbers initWithDigits:DEFAULT_DIGITS];
    return mp_real(0.0);
}

+ (mp_real)mp_pi {
    [ExNumbers initWithDigits:DEFAULT_DIGITS];
    return mp_real::_pi;
}

+ (mp_real)mp_log2 {
    [ExNumbers initWithDigits:DEFAULT_DIGITS];
    return mp_real::_log2;
}

+ (mp_real)mp_log10 {
    [ExNumbers initWithDigits:DEFAULT_DIGITS];
    return mp_real::_log10;
}

+ (mp_real)mp_eps {
    [ExNumbers initWithDigits:DEFAULT_DIGITS];
    return mp_real::_eps;
}

- (id)initFromMPComplex:(mp_complex)complex {
    self = [super init];
    if (self) {
        [ExNumbers initWithDigits:DEFAULT_DIGITS];
        num = complex;
    }
    return self;
}

- (id)initFromExNumber:(ExNumbers *)exNumber {
    return [self initFromMPComplex:exNumber->num];
}

- (id)initFromInteger:(NSInteger)integer {
    mp_complex x = mp_complex(mp_real(integer), [ExNumbers mp_zero]);
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

- (id)initFromMPReal:(mp_real)real {
    mp_complex x = mp_complex(real, [ExNumbers mp_zero]);
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

+ (id)numberFromExNumber:(ExNumbers *)exNumber {
    return [[ExNumbers alloc] initFromExNumber:exNumber];
}

+ (id)numberFromMPReal:(mp_real)real {
    return [[ExNumbers alloc] initFromMPReal:real];
}

- (id)initFromString:(NSString *)real imaginaryString:(NSString *)imaginary {
    mp_real realNum = mp_real([real cStringUsingEncoding:NSASCIIStringEncoding]);
    mp_real imagNum = mp_real([imaginary cStringUsingEncoding:NSASCIIStringEncoding]);
    return [self initFromMPComplex:mp_complex(realNum, imagNum)];
}

+ (id)zero {
    return [ExNumbers numberFromInteger:0];
}

+ (id)pi {
    return [ExNumbers numberFromMPReal:[ExNumbers mp_pi]];
}

+ (id)log2 {
    return  [ExNumbers numberFromMPReal:[ExNumbers mp_log2]];
}

+ (id)log10 {
    return  [ExNumbers numberFromMPReal:[ExNumbers mp_log10]];
}

+ (id)eps {
    return  [ExNumbers numberFromMPReal:[ExNumbers mp_eps]];
}

- (ExNumbers *)real {
    return [ExNumbers numberFromMPReal:num.real];
}

- (ExNumbers *)imaginary {
    return [ExNumbers numberFromMPReal:num.imag];
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
    return [ExNumbers numberFromMPReal:abs(self->num)];
}

- (ExNumbers *)argument {
    return [ExNumbers numberFromMPReal:arg(self->num)];
}

- (ExNumbers *)powerToExponent:(ExNumbers *)exponent {
    return [ExNumbers numberFromMPComplex:exp(self->num)];
}

- (ExNumbers *)tangent {
    mp_complex_temp sine = sin(num);
    mp_complex_temp cosine = cos(num);
    return [ExNumbers numberFromMPComplex:sine/cosine];
}

- (ExNumbers *)hyperbolicSine {
    // FIX ME
    return [ExNumbers numberFromMPReal:sinh(num.real)];
}

- (ExNumbers *)hyperbolicCosine {
    // FIX ME
    return [ExNumbers numberFromMPReal:cosh(num.real)];
}

- (ExNumbers *)hyperbolicTangent {
    // FIX ME
    return [ExNumbers numberFromMPReal:tanh(num.real)];
}

- (ExNumbers *)arcTangent {
    // FIX ME
    return [ExNumbers numberFromMPReal:atan(num.real)];
}

- (ExNumbers *)arcTangentWithY:(ExNumbers *)y  {
    // FIX ME
    return [ExNumbers numberFromMPReal:atan2(y->num.real, num.real)];
}

- (ExNumbers *)arcSine  {
    // FIX ME
    return [ExNumbers numberFromMPReal:asin(num.real)];
}

- (ExNumbers *)arcCosine  {
    // FIX ME
    return [ExNumbers numberFromMPReal:acos(num.real)];
}

- (ExNumbers *)random  {
    return [ExNumbers numberFromExComplex:mp_rand() imaginary:mp_rand()];
}

- (ExNumbers *)floatingModulus:(ExNumbers *)modulus  {
    // FIX ME
    return [ExNumbers numberFromMPReal:fmod(num.real, modulus->num.real)];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[ExNumbers class]]) {
        return num == ((ExNumbers *)object)->num;
    }
    return  NO;
}

- (BOOL)isGreaterThan:(ExNumbers *)object  {
    return  abs(num) > abs(self->num);
}

- (BOOL)isLessThan:(ExNumbers *)object  {
    return  abs(num) < abs(self->num);
}

- (NSString *)stringFromNumber:(mp_real)real {
    NSString *str = [NSString stringWithCString:real.to_string().c_str() encoding:NSASCIIStringEncoding];
    NSString *trunc = [str substringFromIndex:5];
    NSRange location = [trunc rangeOfString:@" x"];
    NSString *exp = [trunc substringToIndex:location.location];
    return [NSString stringWithFormat:@"%@ x 10 ^ %@", [trunc substringFromIndex:location.location], exp];
}

- (NSString *)description {
    if (num.imag == 0) {
        return [NSString stringWithFormat:@"%@", [self stringFromNumber:num.real]];
    } else if (num.real == 0) {
        return [NSString stringWithFormat:@"%@i", [self stringFromNumber:num.imag]];
    } else {
        return [NSString stringWithFormat:@"%@%@i", [self stringFromNumber:num.real], [self stringFromNumber:num.imag]];
    }
}

- (NSString *)stringWithBase:(NSUInteger)base andFormat:(NumberFormat)format {
    // TBD
    return @"TBD";
}


- (ExNumbers *)integer {
    return [ExNumbers numberFromExComplex:anint(abs(num)) imaginary:mp_real(0.0)];
}

@end
