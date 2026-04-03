
.PHONY: all clean

ASSEM = ../tools/lgp21-assembler
ASSEM_FLAGS =

PROGRAMS = \
	1dlife \
	fibonnaci \
	rand_test \
	sier

TAPES_PTP = $(patsubst %,%.ptp,$(PROGRAMS))
TAPES_TXT = $(patsubst %,%.txt,$(PROGRAMS))
TAPES_BOOT = $(patsubst %,%.boot,$(PROGRAMS))
TAPES_BTXT = $(patsubst %,%.btxt,$(PROGRAMS))
DUMP_TAPES = dump.boot dump.btxt

all: $(TAPES_PTP) $(TAPES_TXT) $(TAPES_BOOT) $(TAPES_BTXT) $(DUMP_TAPES)

%.ptp: %.asm
	$(ASSEM) $(ASSEM_FLAGS) -b $@ $<

%.txt: %.asm
	$(ASSEM) $(ASSEM_FLAGS) $@ $<

%.boot: %.asm
	$(ASSEM) $(ASSEM_FLAGS) -b --bootstrap $@ $<

%.btxt: %.asm
	$(ASSEM) $(ASSEM_FLAGS) --bootstrap $@ $<

# Dump and its bootstrap needs to fit in track 0, so use the compact bootstrap.
dump.boot: dump.asm
	$(ASSEM) $(ASSEM_FLAGS) -b -A 0059 --compact-bootstrap $@ $<

dump.btxt: dump.asm
	$(ASSEM) $(ASSEM_FLAGS) -A 0059 --compact-bootstrap $@ $<

1dlife.ptp: random.asm
1dlife.txt: random.asm
1dlife.boot: random.asm
1dlife.btxt: random.asm
rand_test.ptp: random.asm
rand_test.txt: random.asm
rand_test.boot: random.asm
rand_test.btxt: random.asm

clean:
	rm -f $(TAPES_PTP) $(TAPES_TXT) $(TAPES_BOOT) $(TAPES_BTXT)
	rm -f dump.boot dump.btxt
