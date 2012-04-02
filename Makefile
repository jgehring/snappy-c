CFLAGS := -Wall -g -O2 -DNDEBUG=1  -DSG=1 -std=c89 -pedantic -D_BSD_SOURCE
# Remove -DSG=1 if you don't need scather-gather support
# NDEBUG=1 is recommended for production

#CFLAGS += -m32
#LDFLAGS += -m32

all: scmd verify sgverify

snappy.o: snappy.c

scmd: scmd.o snappy.o map.o util.o

CLEAN := scmd.o snappy.o scmd bench bench.o fuzzer.o fuzzer map.o verify.o \
	 verify util.o sgverify sgverify.o

clean: 
	rm -f ${CLEAN}

src: src.lex
	flex src.lex
	gcc ${CFLAGS} -o src lex.yy.c



#LZO := ../comp/lzo.o
LZO := ../comp/minilzo-2.06/minilzo.o

OTHER := ${LZO} ../comp/zlib.o ../comp/lzf.o ../comp/quicklz.o \
	 ../comp/fastlz.o

# incompatible with 32bit
# broken due to namespace collision
#SNAPREF_BASE := ../../src/snappy-1.0.3
#SNAPREF_FL := -I ${SNAPREF_BASE} -D SNAPREF
#SNAPREF := ${SNAPREF_BASE}/snappy-c.o ${SNAPREF_BASE}/snappy.o \
#           ${SNAPREF_BASE}/snappy-sinksource.o \
#           ${SNAPREF_BASE}/snappy-stubs-internal.o \
LDFLAGS += -lstdc++

fuzzer.o: CFLAGS += -D COMP ${SNAPREF_FL}

fuzzer: fuzzer.o map.o util.o snappy.o ${OTHER} # ${SNAPREF}

bench: bench.o map.o snappy.o util.o ${OTHER} # ${SNAPREF}

bench.o: CFLAGS += -I ../simple-pmu -D COMP # ${SNAPREF_FL}  # -D SIMPLE_PMU

verify: verify.o map.o snappy.o util.o

sgverify: sgverify.o map.o snappy.o util.o


