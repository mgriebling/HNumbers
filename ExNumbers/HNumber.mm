//
//  HNumber.m
//  HNumber
//
//  Created by Mike Griebling on 10.3.2013.
//  Copyright (c) 2013 Computer Inspirations. All rights reserved.
//

#import "HNumber.h"
#import "mp_complex.h"
#import "mp_int.h"

@interface HNumber ()
@property (nonatomic)mp_complex num;
@end

@implementation HNumber

static const NSInteger MAXLENGTH = 200;
static NSUInteger displayLength;
static NSUInteger decimals;
static NSInteger computeLength;
static NumberFormat mode;
static NSString *decPoint;
static NSString *groupChar;
static HNumber *zeroConst;
static HNumber *oneConst;
static HNumber *piConst;
static HNumber *iConst;
static HNumber *expConst;

//#define NSInteger int

typedef void (^LogicalOp2)(NSInteger n1, NSInteger n2, NSInteger *res);
typedef void (^LogicalOp1)(NSInteger n, NSInteger *res);

+ (void)initialize {
    if (self == [HNumber class]) {
        // initialize the mp_math libary
        mp::mp_init(MAXLENGTH+5);
        
        // predefine common constant
        zeroConst = [HNumber numberFromInteger:0];
		oneConst = [HNumber numberWithDouble:1];
		piConst = [HNumber numberWithMPReal:mp_real::_pi imaginary:mp_real(0.0)];
		iConst = [HNumber numberWithDouble:0 imaginary:1];
		expConst = [HNumber numberWithMPReal:exp(mp_real(1.0)) imaginary:mp_real(0.0)];
		displayLength = 25;
		decimals = 0;
		mode = FORMAT_STANDARD;
		computeLength = MAXLENGTH;
		NSDictionary *locale = [NSLocale currentLocale];
		decPoint = [locale objectForKey:NSLocaleDecimalSeparator];
		groupChar = [locale objectForKey:NSLocaleGroupingSeparator];
    }
}

+ (void)finalize
{
	// deallocate the mp math library
	mp::mp_finalize();
	[super finalize];
}

+ (NSInteger)displayLength
{
	return displayLength;
}

+ (NSInteger)decimalPoints
{
	return decimals;
}

+ (NSString *)decimalPoint
{
	return decPoint;
}

+ (NSString *)groupingSeparator
{
	return groupChar;
}

+ (void) setDisplayLength:(NSInteger)len
{
	if (len < MAXLENGTH && len > 15)
		displayLength = len;
}

+ (void) setDecimalPoints:(NSInteger)dec
{
	if (dec < displayLength) decimals = dec;
}

+ (void) setDecimalPoint:(NSString*)dp
{
	decPoint = dp;
}

+ (void) setGroupingSeparator:(NSString*)groupSep
{
	groupChar = groupSep;
}

+ (void) setFormat : (NumberFormat)format 
{
	mode = format;
}

+ (NumberFormat)format {
    return mode;
}

// default initializer

- init {
	return [self initWithDouble:0];
}

// Focal point for all init routines
- (id)initWithMPReal:(const mp_real &)real imaginary:(const mp_real &)complex
{
	if (self = [super init]) {
		_num.real.reallocate(mp::prec_words);
		_num.imag.reallocate(mp::prec_words);
		_num.real = real;
		_num.imag = complex;
	}
	return self;
}

- (id)initWithMPComplex:(mp_complex)complex {
    return [self initWithMPReal:complex.real imaginary:complex.imag];
}

- (id)initWithNumber:(HNumber *)number {
    return [self initWithMPReal:number.num.real imaginary:number.num.imag];
}

- (id)initWithInteger:(unsigned long long)integer exponent:(NSInteger)exponent isNegative:(BOOL)isNegative {
	double number = (integer >> 32);
	double number2 = (integer % 0x100000000ull);
	double shift = 0x100000000ull;
	mp_real real = number2;
	
	real += mp_real(number) * shift;
	real *= pow((mp_real)mp_real(10.0), (int)exponent);
	if (isNegative) real *= -1;
	return [self initWithMPReal:real];
}

- (id)initWithInteger:(int)integer {
    return [self initWithInteger:abs(integer) exponent:0 isNegative:integer < 0];    
}

- (id)initWithDouble:(double)number {
    return [self initWithDouble:number imaginary:0];
}

- (id)initWithDouble:(double)real imaginary:(double)imaginary {
    return [self initWithMPReal:mp_real(real) imaginary:mp_real(imaginary)];
}

- (id)initWithMPReal:(mp_real)real {
    return [self initWithMPReal:real imaginary:mp_int(0)];
}

- (id)initWithMPInt:(mp_int)integer {
    return [self initWithMPReal:integer];
}

+ (id)numberWithInteger:(unsigned long long)integer exponent:(NSInteger)exponent isNegative:(BOOL)isNegative {
    return [[HNumber alloc] initWithInteger:integer exponent:exponent isNegative:isNegative];
}

+ (id)numberWithDouble:(double)number {
    return [[HNumber alloc] initWithDouble:number];
}

+ (id)numberWithString:(NSString *)string {
    return [[HNumber alloc] initWithString:string];
}

+ (id)numberWithString:(NSString *)string locale:(NSDictionary *)locale {
    return [[HNumber alloc] initWithString:string locale:locale];
}

+ (id)numberWithString:(NSString *)string usingBase:(short)base {
    return [[HNumber alloc] initWithString:string usingBase:base];
}

+ (id)numberWithMPReal:(mp_real)real imaginary:(mp_real)imaginary {
    return [[HNumber alloc] initWithMPReal:real imaginary:imaginary];
}

+ (id)numberWithDouble:(double)real imaginary:(double)imaginary {
    return [[HNumber alloc] initWithDouble:real imaginary:imaginary];
}

+ (id)numberWithMPComplex:(mp_complex)complex {
    return [[HNumber alloc] initWithMPComplex:complex];
}

+ (id)numberWithNumber:(HNumber *)number {
    return [[HNumber alloc] initWithNumber:number];
}

+ (id)numberWithMPReal:(mp_real)real {
    return [[HNumber alloc] initWithMPReal:real];
}

+ (id)numberWithMPInt:(mp_int)integer {
    return [[HNumber alloc] initWithMPInt:integer];
}

- (id)initWithString:(NSString *)string {
    mp_real realNum = mp_real([string cStringUsingEncoding:NSASCIIStringEncoding]);
    return [self initWithMPReal:realNum];
}

- (id)initWithString:(NSString *)string locale:(NSDictionary *)locale {
    return [self initWithString:string];    // fix to use locale
}

- (id)initWithString:(NSString *)string usingBase:(short)base {
    return [self initWithString:string];    // fix to use base
}

+ (id)zero {
    return zeroConst;
}

+ (id)pi {
    return piConst;
}

+ (id)one {
    return oneConst;
}

+ (id)i {
    return iConst;
}

+ (id)exp {
    return expConst;
}

+ (id)log2 {
    return  [HNumber numberWithMPReal:mp_real::_log2];
}

+ (id)log10 {
    return  [HNumber numberWithMPReal:mp_real::_log10];
}

+ (id)eps {
    return  [HNumber numberWithMPReal:mp_real::_eps];
}

- (HNumber *)realPart {
    return [HNumber numberWithMPReal:self.num.real];
}

- (HNumber *)imaginaryPart {
    return [HNumber numberWithMPReal:self.num.imag];
}

- (double)doubleValue {
    return dble(abs(self.num));
}

- (HNumber *)conjugate {
    return [HNumber numberWithMPReal:self.num.real imaginary:-self.num.imag];
}

+ (id)numberFromInteger:(int)integer {
    return [[HNumber alloc] initWithInteger:integer];
}

+ (id)numberFromDouble:(double)number {
    return [[HNumber alloc] initWithDouble:number];
}

+ (id)numberFromString:(NSString *)string {
    return [[HNumber alloc] initWithString:string];
}

- (HNumber *)add:(HNumber *)complex {
    return [HNumber numberWithMPComplex:self.num + complex.num];
}

- (HNumber *)subtract:(HNumber *)complex {
    return [HNumber numberWithMPComplex:self.num - complex.num];
}

- (HNumber *)multiplyBy:(HNumber *)complex {
    return [HNumber numberWithMPComplex:self.num * complex.num];
}

- (HNumber *)divideBy:(HNumber *)complex {
    return [HNumber numberWithMPComplex:self.num / complex.num];
}

- (HNumber *)exponential {
    return [HNumber numberWithMPComplex:exp(self.num)];
}

- (HNumber *)naturalLogarithm {
    return [HNumber numberWithMPComplex:log(self.num)];
}

- (HNumber *)base10Logarithm {
    return [HNumber numberWithMPComplex:log(self.num)/mp_real::_log10];
}

- (HNumber *)base2Logarithm {
    return [HNumber numberWithMPComplex:log(self.num)/mp_real::_log2];
}

- (HNumber *)sine {
    return [HNumber numberWithMPComplex:sin(self.num)];
}

- (HNumber *)cosine {
    return [HNumber numberWithMPComplex:cos(self.num)];
}

- (HNumber *)tangent {
    mp_complex_temp sine = sin(self.num);
    mp_complex_temp cosine = cos(self.num);
    return [HNumber numberWithMPComplex:sine/cosine];
}

- (HNumber *)squared {
    return [HNumber numberWithMPComplex:sqr(self.num)];
}

- (HNumber *)squareRoot {
    return [HNumber numberWithMPComplex:sqrt(self.num)];
}

- (HNumber *)cubed
{
	return [HNumber numberWithMPComplex:self.num*sqr(self.num)];
}

- (HNumber *)cubeRoot
{
	return [HNumber numberWithNumber:[self anyRoot:3]];
}

- (HNumber *)anyRoot:(short) root
{
	mp_real anyRoot = mp_real(1)/mp_real(root);
	return [HNumber numberWithMPComplex:pow(self.num, anyRoot)];
}

- (HNumber *)signOfRealPart
{
	if (self.num.real < 0)
		return [[HNumber zero] subtract:[HNumber one]];
	else
		return [HNumber one];
}

- (HNumber *)minimumOfRealParts:(HNumber *)number
{
	if (self.num.real < number.num.real)
		return [HNumber numberWithMPReal:self.num.real];
	else
		return [HNumber numberWithMPReal:number.num.real];
}

- (HNumber *)maximumOfRealParts:(HNumber *)number
{
	if (self.num.real > number.num.real)
		return [HNumber numberWithMPReal:self.num.real];
	else
		return [HNumber numberWithMPReal:number.num.real];
}

- (HNumber *)multiplyByPowerOf10:(int)power
{
	return [HNumber numberWithMPComplex:self.num * pow(mp_real(10.0), power)];
}

- (HNumber *)raiseToIntegerPower:(int)power
{
	return [HNumber numberWithMPComplex:pow(self.num, power)];
}

- (HNumber *)raiseToDoublePower:(double)power
{
	return [HNumber numberWithMPComplex:pow(self.num, power)];
}

- (HNumber *)raiseToPower:(HNumber *)power
{
	return [HNumber numberWithMPComplex:pow(self.num, power.num)];
}

- (HNumber *)absoluteValue {
    return [HNumber numberWithMPReal:abs(self.num)];
}

- (HNumber *)round {
	return [HNumber numberWithMPReal:aint(self.num.real) imaginary:aint(self.num.imag)];
}

- (HNumber *)argument {
    return [HNumber numberWithMPReal:arg(self.num)];
}

- (HNumber *)powerToExponent:(HNumber *)exponent {
    return [HNumber numberWithMPComplex:exp(self.num)];
}

- (HNumber *)hyperbolicSine {
	// asin(z) = -i*ln(iz+sqrt(1 - z^2))
	mp_complex i = mp_complex(0, 1);
	mp_complex result = -i * log(i*self.num + sqrt(mp_real(1) - self.num*self.num));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)hyperbolicCosine {
	// acos(z) = -i*ln(z+sqrt(z^2 - 1))
	mp_complex i = mp_complex(0, 1);
	mp_complex result = -i * log(self.num + sqrt(self.num*self.num - mp_real(1)));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)hyperbolicTangent {
	// tanh(z) = sinh(z)/cosh(z)
	HNumber * sinhz = [self hyperbolicSine];
	HNumber * coshz = [self hyperbolicCosine];
	return [sinhz divideBy:coshz];
}

- (HNumber *)inverseSine  {
	// asin(z) = -i*ln(iz+sqrt(1 - z^2))
	mp_complex i = mp_complex(0, 1);
	mp_complex result = -i * log(i*self.num + sqrt(mp_real(1) - self.num*self.num));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)inverseCosine  {
	// acos(z) = -i*ln(z+sqrt(z^2 - 1))
	mp_complex i = mp_complex(0, 1);
	mp_complex result = -i * log(self.num + sqrt(self.num*self.num - mp_real(1)));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)inverseTangent {
	// atan(z) = 1/2*ln((i+z)/(i-z))
	mp_complex i = mp_complex(0, 1);
	mp_complex result = mp_real(0.5) * log((i+self.num)/(i-self.num));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)inverseHyperbolicSine
{
	// asinh(z) = ln(z + sqrt(z^2 + 1))
	mp_complex result = log(self.num + sqrt(self.num*self.num + mp_real(1)));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)inverseHyperbolicCosine
{
	// acosh(z) = ln(z + sqrt(z^2 - 1))
	mp_complex result = log(self.num + sqrt(self.num*self.num - mp_real(1)));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)inverseHyperbolicTangent
{
	// atanh(z) = 1/2*ln((1+z)/(1-z))
	mp_real one = mp_real(1);
	mp_complex result = mp_real(0.5)*log((one+self.num)/(one-self.num));
	return [HNumber numberWithMPComplex:result];
}

- (HNumber *)gamma  {
    // FIX ME
    return [HNumber numberWithMPReal:gamma(abs(self.num))];
}

- (HNumber *)erfc  {
    // FIX ME
    return [HNumber numberWithMPReal:erfc(self.num.real)];
}

- (HNumber *)erf  {
    // FIX ME
    return [HNumber numberWithMPReal:erf(self.num.real)];
}

- (HNumber *)bessel  {
    // FIX ME
    return [HNumber numberWithMPReal:bessel(self.num.real)];
}

- (HNumber *)besselexp  {
    // FIX ME
    return [HNumber numberWithMPReal:besselexp(self.num.real)];
}

- (HNumber *)random  {
    return [HNumber numberWithMPReal:mp_rand()];
}

- (HNumber *)floatingModulus:(HNumber *)modulus  {
    // FIX ME
    return [HNumber numberWithMPReal:fmod(self.num.real, modulus.num.real)];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[HNumber class]]) {
        return self.num == ((HNumber *)object).num;
    }
    return  NO;
}

- (BOOL)isGreaterThan:(HNumber *)object  {
    return  abs(self.num) > abs(object.num);
}

- (BOOL)isLessThan:(HNumber *)object  {
    return  abs(self.num) < abs(object.num);
}

#define BASE_NUMBER  (2147483648.0)

- (NSString *)stringWithNumber:(mp_real)real andFormat:(NumberFormat)format {
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
        int expValue = exp.intValue;
        NSInteger adjust = expValue % 3;
        fraction = [[trunc substringFromIndex:location.location+3] stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (adjust < 0) adjust += 3;
        expValue -= adjust; adjust++;
        fraction = [NSString stringWithFormat:@"%@.%@×10^%d", [fraction substringToIndex:adjust], [fraction substringFromIndex:adjust], expValue];
    } else {
        NSInteger expValue = exp.integerValue;
        fraction = [[trunc substringFromIndex:location.location+3] stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (expValue == 0) {
            // leave number as is
        } else if (expValue < 0) {
            // pad with zeros as needed for fraction
            fraction = [[@"0." stringByPaddingToLength:-expValue+1 withString:@"0" startingAtIndex:0] stringByAppendingString:fraction];
        } else if (expValue < fraction.length) {
            // use floating decimal point output
            expValue++;
            if (expValue < fraction.length) {
                fraction = [NSString stringWithFormat:@"%@.%@", [fraction substringToIndex:expValue], [fraction substringFromIndex:expValue]];
            }
        } else if (expValue < mp::mpgetprec()) {
            // add zeros to number
            fraction = [fraction stringByPaddingToLength:expValue+1 withString:@"0" startingAtIndex:0];
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
        return [NSString stringWithFormat:@"%@", [self stringWithNumber:self.num.real andFormat:format]];
    } else if (self.num.real == 0) {
        return [NSString stringWithFormat:@"%@i", [self stringWithNumber:self.num.imag andFormat:format]];
    } else {
        NSString *sign = self.num.imag > 0 ? @"+" : @"-";
        NSString *imag = abs(self.num.imag) == 1 ? @"" : [self stringWithNumber:abs(self.num.imag) andFormat:format];
        return [NSString stringWithFormat:@"%@ %@ %@i", [self stringWithNumber:self.num.real andFormat:format], sign, imag];
    }
}

- (NSString *)stringUsingLocale:(NSDictionary *)locale {
    return [self description];  // need to add locale
}

- (NSString *)stringFromDigit:(int)digit withBase:(NSInteger)base {
    if (base < 2 || base > 36 || digit >= base) return @"?";
    if (base <= 10) return [NSString stringWithFormat:@"%d", digit];
    if (base <= 16) return [NSString stringWithFormat:@"%X", digit];
    unichar digitCharacter[1] = {static_cast<unichar>(digit - 16 + 0x47)};
    return [NSString stringWithCharacters:digitCharacter length:1];
}

- (NSString *)stringUsingBase:(short)base {
    if (base == 10) {
        return [self descriptionWithFormat:mode];
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

- (mp_int) factorialWith:(int) n {
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

- (HNumber *)factorial {
    // check if an integer factorial is possible
    mp_real n = anint(self.num.real);
    if (abs(self.num.real - n) == 0) {
        // use integer factorial
        int nint = integer(n);
        if (nint >= 0 && nint < 79) {
            // accurate to 100 digits
            return [HNumber numberWithMPInt:[self factorialWith:nint]];
        }
    }
    
    // use the gamma function approximation except for negative integers
    if (abs(self.num.real - n) != 0 || n >= 0) return [HNumber numberWithMPReal:gamma(self.num.real + 1)];
    return [HNumber numberFromInteger:1];
}

- (HNumber *)nCr:(HNumber *)number
{
	// result = n!/(k!(n-k)!)
	mp_real n = gamma(self.num.real+1);
	mp_real k = gamma(number.num.real+1);
	mp_real nk = gamma(self.num.real-number.num.real+1);
	return [HNumber numberWithMPReal:n/(k*nk)];
}

- (HNumber *)nPr:(HNumber *)number
{
	// result = n!/(n-k)!
	mp_real n = gamma(self.num.real+1);
	mp_real nk = gamma(self.num.real-number.num.real+1);
	return [HNumber numberWithMPReal:n/nk];
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
    int length = (int)n.count-1;
    int integer = ((NSNumber *)n[length--]).intValue;
    mp_int intValue = mp_int(integer);
    mp_int base = mp_int(BASE_NUMBER);
    while (length >= 0) {
        intValue = intValue * base;
        intValue += ((NSNumber *)n[length--]).intValue;
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

- (HNumber *)setBit:(HNumber *)bit {
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), integer(bit.num.real))];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 | n2;
    }];
    mp_int m = [self makeInteger:result];
    HNumber *xm = [HNumber numberWithMPInt:m];
    return xm;
}

- (HNumber *)clearBit:(HNumber *)bit{
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), integer(bit.num.real))];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 & ~n2;
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)toggleBit:(HNumber *)bit {
    NSArray *n = [self makeLogical:[self convertFrom:self.num]];
    NSArray *b = [self makeLogical:pow(mp_int(2), integer(bit.num.real))];
    NSArray *result = [self intOp2:n andInt:b usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 ^ n2;
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
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

- (HNumber *)truncate
{
	mp_int inumber(mp_real(abs(self.num)));
	return [HNumber numberWithMPReal:inumber];
}

- (HNumber *)moduloWith:(HNumber *)number
{
	mp_int inumber(mp_real(abs(self.num)));
	mp_int inumber2(mp_real(abs(number.num)));
	return [HNumber numberWithMPReal:mp_int(inumber % inumber2)];
}

- (HNumber *)integerDivideBy:(HNumber *)number
{
	mp_int inumber(mp_real(abs(self.num)));
	mp_int inumber2(mp_real(abs(number.num)));
	return [HNumber numberWithMPReal:mp_int(inumber / inumber2)];
}

- (HNumber *)multiplyByPowerOf2:(int)power
{
	mp_int inumber(mp_real(abs(self.num)));
	return [HNumber numberWithMPReal:mp_int(inumber*pow(mp_int(2), power))];
}

int MaxBits(void) {
	// This only needs to be done during power-up and precision changes
	char str[32];
	int bitSize;
	
	sprintf(str, "1E%ld", (unsigned long)displayLength);
	mp_int max = mp_int(str)-1;
	mp_int bits = mp_int(mp_real(log(max)/mp_real::_log2));
	bitSize = integer(bits);
	return bitSize;
}

bool Bit(mp_int& number, short bitnum)
{
	HNumber *lnum = [HNumber numberWithMPReal:number];
	if (bitnum >= MaxBits()) return false;
	lnum = [lnum andWith:[HNumber numberWithMPReal:pow(mp_real(2), bitnum)]];
	return (lnum != 0);
}

- (HNumber *)signedShiftBy:(HNumber *)bits
{
	short ShiftCnt;
	bool SavedBit;
	mp_int inumber(mp_real(abs(self.num)));
	mp_int Two(2);
	mp_int UpperBit = pow(Two, MaxBits()-1);
	int lbits = integer(mp_real(abs(bits.num)));
    
	if (lbits > MaxBits()) {
		return [HNumber numberWithDouble:1];
	}
	
	SavedBit = (inumber < mp_int(0));
	for (ShiftCnt=1; ShiftCnt<=lbits; ShiftCnt++) {
		inumber = inumber / Two;
		if (SavedBit) inumber += UpperBit;
	}
	return [HNumber numberWithMPReal:inumber];
}

- (HNumber *)rotateBy:(HNumber *)bits
{
	short ShiftCnt;
	bool SavedBit;
	mp_int inumber = mp_int(mp_real(abs(self.num)));
	mp_int Two(2);
	mp_int UpperBit = pow(Two, MaxBits()-1);
	int lbits = integer(bits.num.real);
	
	lbits = lbits % (MaxBits()+1);
	
	for (ShiftCnt = 1; ShiftCnt <= lbits; ShiftCnt++) {
		if (lbits > 0)	{
			SavedBit = Bit(inumber, 0);
			inumber = inumber / Two;
			if (SavedBit) inumber += UpperBit;
		} else {
			SavedBit = Bit(inumber, MaxBits()-1);
			inumber = inumber * Two;
			if (SavedBit) inumber += 1;
		}
	}
	return [HNumber numberWithMPReal:inumber];
}

- (HNumber *)shiftBy:(HNumber *)bits
{
	mp_real inumber = mp_real(abs(self.num));
	int lbits = integer(bits.num.real);
	
	if (abs(lbits) > MaxBits()) return [HNumber zero];
	return [HNumber numberWithMPReal:inumber * pow(mp_real(2), lbits)];
}

- (mp_int)convertFrom:(mp_complex)c {
    mp_real n = abs(c);
    return mp_int(n);
}

- (HNumber *)andWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 & n2;
    }];
    mp_int iresult = [self makeInteger:result];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)orWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 | n2;
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)xorWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = n1 ^ n2;
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)norWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 | n2);
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)nandWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 & n2);
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)xnorWith:(HNumber *)number {
    NSArray *n1 = [self makeLogical:[self convertFrom:self.num]];
    NSArray *n2 = [self makeLogical:[self convertFrom:number.num]];
    NSArray *result = [self intOp2:n1 andInt:n2 usingOperation:^(NSInteger n1, NSInteger n2, NSInteger *res) {
        *res = ~(n1 ^ n2);
    }];
    return [HNumber numberWithMPInt:[self makeInteger:result]];
}

- (HNumber *)onesComplement {
    return [HNumber numberWithMPComplex:-self.num-mp_int(1)];
}

- (HNumber *)twosComplement {
    return [HNumber numberWithMPComplex:-self.num];
}

- (HNumber *)fibonacci
{
	mp_int Zero(0);
	mp_int rp(Zero), rn, u = self.num.real;
	mp_int Result;
	mp_int One(1);
	
	if (u <= Zero)
		return [HNumber zero];
	else {
		// iterative Fibonacci series
		Result = mp_int(1);
		for (;;) {
			u = u - One;
			if (u == Zero) break;
			rn = Result + rp;
			rp = Result; Result = rn;
		}
	}
	return [HNumber numberWithMPReal:Result];
}

- (HNumber *)GCD:(HNumber *) number
{
	mp_int nop1(mp_real(self.num.real));
	mp_int nop2(mp_real(number.num.real));
	mp_int Zero(0);
	mp_int Result;
    
	while (nop2 != Zero) {
		Result = nop1 % nop2;
		nop1 = nop2; nop2 = Result;
	}
	return [HNumber numberWithMPReal:nop1];
}


@end
