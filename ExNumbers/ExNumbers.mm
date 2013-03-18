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

typedef void (^LogicalOp2)(NSInteger n1, NSInteger n2, NSInteger *res);
typedef void (^LogicalOp1)(NSInteger n, NSInteger *res);

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

- (ExNumbers *)setBit:(NSUInteger)bit {
    mp_int n = [self convertFrom:self.num];
    mp_int b = pow(mp_int(2), bit);
    return [ExNumbers numberFromMPReal:mp_real(n)];
}

- (NSArray *)makeLogical:(mp_int)n {
    // convert n into a logical number
    NSMutableArray *logical = [NSMutableArray array];
    NSInteger Base = 0x7FFFFFFF;
    mp_int base = mp_int(Base);
    while (n > base) {
        int rem = n % Base; n = n / Base;
        [logical addObject:@(rem)];
    }
    [logical addObject:@(n % Base)];
    return logical;
}

- (mp_int)makeInteger:(NSArray *)n {
    // convert n into a logical number
    int length = n.count-1;
    mp_int intValue = mp_int(((NSNumber *)n[length--]).integerValue);
    NSInteger Base = 0x7FFFFFFF;
    mp_int base = mp_int(Base);
    while (length >= 0) {
        intValue *= Base;
        intValue += ((NSNumber *)n[length--]).integerValue;
    }
    return intValue;
}

- (NSArray *)intOp2:(NSArray *)n1 andInt:(NSArray *)n2 usingOperation:(LogicalOp2)operation {
    NSInteger l1 = n1.count;
    NSInteger l2 = n2.count;
    NSInteger max = MAX(l1, l2);
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i=0; i<max; i++) {
        // logically apply the 'operation' to pieces of 'n1' and 'n2'
        NSInteger p1 = (i < l1) ? ((NSNumber *)n1[i]).integerValue : 0;
        NSInteger p2 = (i < l2) ? ((NSNumber *)n2[i]).integerValue : 0;
        NSInteger res;
        operation(p1, p2, &res);
        [result addObject:@(res)];
    }
    return result;
}

- (NSArray *)intOp1:(NSArray *)n usingOperation:(LogicalOp1)operation {
    NSInteger max = n.count;
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i=0; i<max; i++) {
        // logically apply the 'operation' to pieces of 'n'
        NSInteger res;
        operation(((NSNumber *)n[i]).integerValue, &res);
        [result addObject:@(res)];
    }
    return result;
}

- (ExNumbers *)clearBit:(NSUInteger)bit{
    mp_int xbit = pow(2, bit);
    NSUInteger bits = MAX(bit+1, [self sizeInBits]);
    
    return [self andWith:[ExNumbers numberFromMPReal:xbit]];
}

- (ExNumbers *)toggleBit:(NSUInteger)bit {
    return [ExNumbers numberFromInteger:0];    
}

- (NSUInteger)numberOfOneBits {
    NSArray *logical = [self makeLogical:[self convertFrom:self.num]];
    NSUInteger total = 0;
    for (NSNumber *number in logical) {
        NSInteger inumber = number.integerValue;
        while (inumber != 0) {
            if (inumber & 1) total++;
            inumber /= 2;
        }
    }
    return total;
}

- (NSUInteger)sizeInBits {
    NSArray *logical = [self makeLogical:[self convertFrom:self.num]];
    NSUInteger size = (logical.count - 1) * (sizeof(NSInteger) - 1);
    
    // count the bits in the highest word separately
    NSInteger inumber = ((NSNumber *)[logical lastObject]).integerValue;
    while (inumber != 0) {
        size++;
        inumber /= 2;
    }
    return size;
}

- (mp_int)convertFrom:(mp_complex)c {
    mp_real n = abs(self.num);
    return mp_int(n);
}

- (ExNumbers *)andWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 & n2;
    }];
    return [ExNumbers numberFromMPReal:[self makeInteger:result]];
}

- (ExNumbers *)orWith:(ExNumbers *)number {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)xorWith:(ExNumbers *)number {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)norWith:(ExNumbers *)number {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)nandWith:(ExNumbers *)number {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)xnorWith:(ExNumbers *)number {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)onesComplement {
    return [ExNumbers numberFromInteger:0];    
}

- (ExNumbers *)twosComplement {
    return [ExNumbers numberFromInteger:0];   
}


@end
