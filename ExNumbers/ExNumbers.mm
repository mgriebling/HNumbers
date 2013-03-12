//
//  ExNumbers.m
//  ExNumbers
//
//  Created by Mike Griebling on 10.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "ExNumbers.h"
#import "mp_complex.h"
#import "mp_int.h"

@interface ExNumbers ()
@property (nonatomic)mp_complex num;
@end

@implementation ExNumbers

static NSInteger libDigits = 0;

+ (void)initWithDigits:(NSUInteger)digits {
    if (libDigits != digits) {
        // need to initialize the base library constants and precision
        mp::mp_init(digits);
        libDigits = digits;
    }
}

// default initializer

- (id)initFromMPComplex:(mp_complex)complex {
    self = [super init];
    if (self) _num = complex;
    return self;
}

- (id)initFromExNumber:(ExNumbers *)exNumber {
    return [self initFromMPComplex:exNumber.num];
}

- (id)initFromInteger:(NSInteger)integer {
    return [self initFromMPComplex:mp_complex(mp_int(integer), mp_int(0))];
}

- (id)initFromDouble:(double)number {
    return [self initFromComplex:number imaginary:0];
}

- (id)initFromComplex:(double)real imaginary:(double)imaginary {
    return [self initFromMPComplex:mp_complex(mp_real(real), mp_real(imaginary))];
}

- (id)initFromExComplex:(mp_real)real imaginary:(mp_real)imaginary {
    return [self initFromMPComplex:mp_complex(real, imaginary)];
}

- (id)initFromMPReal:(mp_real)real {
    return [self initFromMPComplex:mp_complex(real, mp_int(0))];
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
    return [ExNumbers numberFromMPReal:mp_real::_pi];
}

+ (id)log2 {
    return  [ExNumbers numberFromMPReal:mp_real::_log2];
}

+ (id)log10 {
    return  [ExNumbers numberFromMPReal:mp_real::_log10];
}

+ (id)eps {
    return  [ExNumbers numberFromMPReal:mp_real::_eps];
}

- (ExNumbers *)real {
    return [ExNumbers numberFromMPReal:self.num.real];
}

- (ExNumbers *)imaginary {
    return [ExNumbers numberFromMPReal:self.num.imag];
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
    return [ExNumbers numberFromMPComplex:self.num + complex.num];
}

- (ExNumbers *)subtract:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:self.num - complex.num];
}

- (ExNumbers *)multiply:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:self.num * complex.num];
}

- (ExNumbers *)divide:(ExNumbers *)complex {
    return [ExNumbers numberFromMPComplex:self.num / complex.num];
}

- (ExNumbers *)exponential {
    return [ExNumbers numberFromMPComplex:exp(self.num)];
}

- (ExNumbers *)naturalLogarithm {
    return [ExNumbers numberFromMPComplex:log(self.num)];
}

- (ExNumbers *)base10Logarithm {
    return [ExNumbers numberFromMPComplex:log(self.num)/mp_real::_log10];
}

- (ExNumbers *)sine {
    return [ExNumbers numberFromMPComplex:sin(self.num)];
}

- (ExNumbers *)cosine {
    return [ExNumbers numberFromMPComplex:cos(self.num)];
}

- (ExNumbers *)squared {
    return [ExNumbers numberFromMPComplex:sqr(self.num)];
}

- (ExNumbers *)squareRoot {
    return [ExNumbers numberFromMPComplex:sqrt(self.num)];
}

- (ExNumbers *)absolute {
    return [ExNumbers numberFromMPReal:abs(self.num)];
}

- (ExNumbers *)argument {
    return [ExNumbers numberFromMPReal:arg(self.num)];
}

- (ExNumbers *)powerToExponent:(ExNumbers *)exponent {
    return [ExNumbers numberFromMPComplex:exp(self.num)];
}

- (ExNumbers *)tangent {
    mp_complex_temp sine = sin(self.num);
    mp_complex_temp cosine = cos(self.num);
    return [ExNumbers numberFromMPComplex:sine/cosine];
}

- (ExNumbers *)hyperbolicSine {
    // FIX ME
    return [ExNumbers numberFromMPReal:sinh(self.num.real)];
}

- (ExNumbers *)hyperbolicCosine {
    // FIX ME
    return [ExNumbers numberFromMPReal:cosh(self.num.real)];
}

- (ExNumbers *)hyperbolicTangent {
    // FIX ME
    return [ExNumbers numberFromMPReal:tanh(self.num.real)];
}

- (ExNumbers *)arcTangent {
    // FIX ME
    return [ExNumbers numberFromMPReal:atan(self.num.real)];
}

- (ExNumbers *)arcTangentWithY:(ExNumbers *)y  {
    // FIX ME
    return [ExNumbers numberFromMPReal:atan2(y.num.real, self.num.real)];
}

- (ExNumbers *)arcSine  {
    // FIX ME
    return [ExNumbers numberFromMPReal:asin(self.num.real)];
}

- (ExNumbers *)arcCosine  {
    // FIX ME
    return [ExNumbers numberFromMPReal:acos(self.num.real)];
}

- (ExNumbers *)random  {
    return [ExNumbers numberFromExComplex:mp_rand() imaginary:mp_rand()];
}

- (ExNumbers *)floatingModulus:(ExNumbers *)modulus  {
    // FIX ME
    return [ExNumbers numberFromMPReal:fmod(self.num.real, modulus.num.real)];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[ExNumbers class]]) {
        return self.num == ((ExNumbers *)object).num;
    }
    return  NO;
}

- (BOOL)isGreaterThan:(ExNumbers *)object  {
    return  abs(self.num) > abs(object.num);
}

- (BOOL)isLessThan:(ExNumbers *)object  {
    return  abs(self.num) < abs(object.num);
}

- (NSString *)stringFromNumber:(mp_real)real {
    NSString *str = [NSString stringWithCString:real.to_string().c_str() encoding:NSASCIIStringEncoding];
    NSString *trunc = [str substringFromIndex:5];
    NSRange location = [trunc rangeOfString:@" x"];
    NSString *exp = [trunc substringToIndex:location.location];
    if (exp.integerValue == 0) return [trunc substringFromIndex:location.location+3];
    else return [NSString stringWithFormat:@"%@×10^%@", [trunc substringFromIndex:location.location+3], exp];
}

- (NSString *)description {
    if (self.num.imag == 0) {
        return [NSString stringWithFormat:@"%@", [self stringFromNumber:self.num.real]];
    } else if (self.num.real == 0) {
        return [NSString stringWithFormat:@"%@i", [self stringFromNumber:self.num.imag]];
    } else {
        NSString *sign = self.num.imag > 0 ? @"+" : @"-";
        NSString *imag = abs(self.num.imag) == 1 ? @"" : [self stringFromNumber:abs(self.num.imag)];
        return [NSString stringWithFormat:@"%@ %@ %@i", [self stringFromNumber:self.num.real], sign, imag];
    }
}

- (NSString *)stringWithBase:(NSUInteger)base andFormat:(NumberFormat)format {
    // TBD
    return @"TBD";
}


- (ExNumbers *)integer {
    return [ExNumbers numberFromMPReal:anint(abs(self.num))];
}

@end
