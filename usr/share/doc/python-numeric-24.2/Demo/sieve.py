#! /usr/bin/env python
from Numeric import *

def sieve(max):
        numbers=range(max+1)
        size=int(math.sqrt(max))
        if size<5:
                trials=[2,3]
        else:
                trials=sieve(size)
        for i in trials:
                try:
                        j=i*i
                        while 1:
                                numbers[j]=0
                                j=j+i
                except IndexError:
                        pass
        return filter(lambda x:x>1,numbers)

def factor(num,upto=1000000):
        for p in sieve(upto):
                if num%p==0:
                        print "Can divide by %d"%p

def asieve(max,atype='l'):
        times = []    
	#times.append(time.time())
        size=int(sqrt(max))
        if size<5:
                known_primes=[2,3]
        else:
                known_primes=asieve(size)

	#Initially assume all numbers are prime
	numbers=ones([max+1], 'b') #atype)
	#times.append(time.time())
	#add(numbers, array(1, 'b'), numbers)
	#times.append(time.time())
	#0 and 1 are not prime
	numbers[0:2]=0
	#print trials
        for i in known_primes:
	        #Set multiples of i to be nonprime
	        numbers[(i*i)::i] = 0
        #times.append(time.time())
	#Those entries which are nonzero are prime
	#a = add.accumulate(ones([len(numbers)]))-1
	a = arange(len(numbers))
        #times.append(time.time())
        r = repeat(a, numbers)#numbers)nonzero(numbers)
        #times.append(time.time())
	#times = array(times)
	#print times[1:]-times[:-1]
	return r

def afactor(num,upto=1000000):
        #Calculate all of the primes up to upto
        s = asieve(upto)
        #Return just those primes that divide evenly into num
        for d in take(s, nonzero(equal(num % s, 0))):
	        print "Can divide by %d"%d


import time

#start = time.time()
#factor(129753308,upto=99999)
#stop = time.time()
#print "factor took %7.3f seconds"%((stop-start))
start = time.time()
asieve(999999)
afactor(129753308,upto=999999)
stop = time.time()
print "afactor took %7.3f seconds"%((stop-start))

