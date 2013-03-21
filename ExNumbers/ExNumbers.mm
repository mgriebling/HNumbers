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

- (id)initFromMPInt:(mp_int)integer {
    return [self initFromMPComplex:mp_complex(integer, mp_int(0))];
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

+ (id)numberFromMPInt:(mp_int)integer {
    return [[ExNumbers alloc] initFromMPInt:integer];
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

- (ExNumbers *)gamma  {
    // FIX ME
    return [ExNumbers numberFromMPReal:gamma(self.num.real)];
}

- (ExNumbers *)erfc  {
    // FIX ME
    return [ExNumbers numberFromMPReal:erfc(self.num.real)];
}

- (ExNumbers *)erf  {
    // FIX ME
    return [ExNumbers numberFromMPReal:erf(self.num.real)];
}

- (ExNumbers *)bessel  {
    // FIX ME
    return [ExNumbers numberFromMPReal:bessel(self.num.real)];
}

- (ExNumbers *)besselexp  {
    // FIX ME
    return [ExNumbers numberFromMPReal:besselexp(self.num.real)];
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

#define BASE_NUMBER  (2147483648.0)

- (NSString *)stringFromNumber:(mp_real)real withFormat:(NumberFormat)format {
    BOOL isNegative = real < 0;
    real = abs(real);
    NSString *str = [NSString stringWithCString:real.to_string().c_str() encoding:NSASCIIStringEncoding];
    NSString *trunc = [str substringFromIndex:5];
    NSRange location = [trunc rangeOfString:@" x"];
    NSString *exp = [trunc substringToIndex:location.location];
    NSString *fraction;

    if (format == FORMAT_SCIENTIFIC) {
        fraction = [NSString stringWithFormat:@"%@×10^%@", [trunc substringFromIndex:location.location+3], exp];
    } else if (format == FORMAT_ENGINEERING) {
        NSInteger expValue = exp.integerValue;
        NSInteger adjust = 3 - expValue % 3;
        NSString *fraction = [[trunc substringFromIndex:location.location+3] stringByReplacingOccurrencesOfString:@"." withString:@""];
        expValue += adjust;
        fraction = [NSString stringWithFormat:@"%@.%@×10^%d", [fraction substringToIndex:expValue], [fraction substringFromIndex:expValue], expValue];
    } else {
        NSInteger expValue = exp.integerValue;
        NSString *fraction = [[trunc substringFromIndex:location.location+3] stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (expValue < fraction.length) {
            // use floating decimal point output
            fraction = [NSString stringWithFormat:@"%@.%@", [fraction substringToIndex:expValue], [fraction substringFromIndex:expValue]];
        } else {
            fraction = [NSString stringWithFormat:@"%@×10^%@", [trunc substringFromIndex:location.location+3], exp];            
        }
    }
    if (isNegative) return [@"-" stringByAppendingString:fraction];
    return fraction;
}

- (NSString *)description {
    return [self descriptionWithFormat:FORMAT_STANDARD];
}

- (NSString *)descriptionWithFormat:(NumberFormat)format {
    if (self.num.imag == 0) {
        return [NSString stringWithFormat:@"%@", [self stringFromNumber:self.num.real withFormat:format]];
    } else if (self.num.real == 0) {
        return [NSString stringWithFormat:@"%@i", [self stringFromNumber:self.num.imag withFormat:format]];
    } else {
        NSString *sign = self.num.imag > 0 ? @"+" : @"-";
        NSString *imag = abs(self.num.imag) == 1 ? @"" : [self stringFromNumber:abs(self.num.imag) withFormat:format];
        return [NSString stringWithFormat:@"%@ %@ %@i", [self stringFromNumber:self.num.real withFormat:format], sign, imag];
    }
}

- (NSString *)stringFromDigit:(NSInteger)digit withBase:(NSInteger)base {
    if (base < 2 || base > 36 || digit >= base) return @"?";
    if (base <= 10) return [NSString stringWithFormat:@"%d", digit];
    if (base <= 16) return [NSString stringWithFormat:@"%X", digit];
    unichar digitCharacter[1] = {static_cast<unichar>(digit - 16 + 0x47)};
    return [NSString stringWithCharacters:digitCharacter length:1];
}

- (NSString *)stringWithBase:(NSInteger)base andFormat:(NumberFormat)format {
    if (base == 10) {
        return [self descriptionWithFormat:format];
    } else {
        NSString *result = @"0";
        mp_int inum = self.num.real;
        mp_int izero = mp_int(0);
        while (inum > izero) {
            int digit = inum % base; inum /= base;
            result = [NSString stringWithFormat:@"%@%@", [self stringFromDigit:digit withBase:base], result];
        }
        return result;
    }
}


- (ExNumbers *)integer {
    return [ExNumbers numberFromMPReal:anint(abs(self.num))];
}

/* Return the power of the prime number p in the factorization of n! */
- (int) multiplicity:(int) n andP:(int) p {
    int q = n, m = 0;
    if (p > n) return 0;
    if (p > n/2) return 1;
    while (q >= p) {
        q /= p;
        m += q;
    }
    return m;
}

-(unsigned char*) prime_table:(int) n {
    int i, j;
    unsigned char* sieve = (unsigned char*)calloc(n+1, sizeof(unsigned char));
    sieve[0] = sieve[1] = 1;
    for (i=2; i*i <= n; i++)
        if (sieve[i] == 0)
            for (j=i*i; j <= n; j+=i)
                sieve[j] = 1;
    return sieve;
}

-(mp_int) exponentWithBase:(unsigned int) base power:(unsigned int) power {
    int bit;
    mp_int result = mp_int(1);
    
    bit=sizeof(power)*CHAR_BIT - 1;
    while ((power & (1 << bit)) == 0) bit--;
    for( ; bit>=0; bit--) {
        result = sqr(result);
        if ((power & (1 << bit)) != 0) {
            result *= base;
        }
    }
    return result;
}

- (mp_int) factorialWith:(NSInteger) n {
    unsigned char* primes = [self prime_table:n];
    int p;
    mp_int result   = mp_int(1);
    mp_int p_raised = mp_int(0);
    
    for (p = 2; p <= n; p++) {
        if (primes[p] == 1) continue;
        result = result * [self exponentWithBase:p power:[self multiplicity:n andP:p]];
    }
    
    free(primes);
    return result;
}

- (ExNumbers *)factorial {
    // check if an integer factorial is possible
    mp_real n = anint(self.num.real);
    if (abs(self.num.real - n) == 0) {
        // use integer factorial
        NSInteger nint = integer(n);
        if (nint >= 0 && nint < 79) {
            // accurate to 100 digits
            return [ExNumbers numberFromMPInt:[self factorialWith:nint]];
        }
    }
    
    // use the gamma function approximation except for negative integers
    if (abs(self.num.real - n) != 0 || n >= 0) return [ExNumbers numberFromMPReal:gamma(self.num.real + 1)];
    return [ExNumbers numberFromInteger:1];
}

- (NSArray *)makeLogical:(mp_int)n {
    // convert n into a logical number
    NSMutableArray *logical = [NSMutableArray array];
    mp_int base = mp_int(BASE_NUMBER);
    while (n > base) {
        mp_int rem = n % base; n = n / base;
        NSInteger irem = integer(rem);
        [logical addObject:@(irem)];
    }
    [logical addObject:@(integer(n % base))];
    return logical;
}

- (mp_int)makeInteger:(NSArray *)n {
    // convert n into a logical number
    int length = n.count-1;
    mp_int intValue = mp_int(((NSNumber *)n[length--]).integerValue);
    mp_int base = mp_int(BASE_NUMBER);
    while (length >= 0) {
        intValue = intValue * base;
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

- (ExNumbers *)setBit:(NSUInteger)bit {
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), bit)];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 | n2;
    }];
    mp_int m = [self makeInteger:result];
    ExNumbers *xm = [ExNumbers numberFromMPInt:m];
    return xm;
}

- (ExNumbers *)clearBit:(NSUInteger)bit{
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), bit)];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 & ~n2;
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)toggleBit:(NSUInteger)bit {
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), bit)];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 ^ n2;
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (NSUInteger)numberOfOneBits {
    NSArray *logical = [self makeLogical:[self convertFrom:self.num]];
    __block NSUInteger total = 0;
    [logical enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
        NSInteger inumber = number.integerValue;
        while (inumber != 0) {
            if (inumber & 1) total++;
            inumber /= 2;
        }
    }];
    return total;
}

- (NSUInteger)sizeInBits {
    NSArray *logical = [self makeLogical:[self convertFrom:self.num]];
    NSUInteger size = (logical.count - 1) * (sizeof(NSInteger)*8 - 1);
    
    // count the bits in the highest word separately
    NSInteger inumber = ((NSNumber *)[logical lastObject]).integerValue;
    while (inumber != 0) {
        size++;
        inumber /= 2;
    }
    return size;
}

- (mp_int)convertFrom:(mp_complex)c {
    mp_real n = abs(c);
    return mp_int(n);
}

- (ExNumbers *)andWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 & n2;
    }];
    mp_int iresult = [self makeInteger:result];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)orWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 | n2;
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)xorWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 ^ n2;
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)norWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 | n2);
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)nandWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 & n2);
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)xnorWith:(ExNumbers *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 ^ n2);
    }];
    return [ExNumbers numberFromMPInt:[self makeInteger:result]];
}

- (ExNumbers *)onesComplement {
    return [ExNumbers numberFromMPComplex:-self.num-mp_int(1)];
}

- (ExNumbers *)twosComplement {
    return [ExNumbers numberFromMPComplex:-self.num];
}


@end
