
.PHONY: all clean

ASSEM = ../tools/lgp21-assembler
ASSEM_FLAGS =

PROGRAMS = \
	1dlife \
	fibonacci \
	print_strings \
	rand_test \
	sier

TAPES_PTP = $(patsubst %,%.ptp,$(PROGRAMS))
TAPES_TXT = $(patsubst %,%.txt,$(PROGRAMS))
TAPES_BOOT = $(patsubst %,%.boot,$(PROGRAMS))
TAPES_BTXT = $(patsubst %,%.btxt,$(PROGRAMS))
OTHER_TAPES = \
	dump.boot \
	dump.btxt \
	hellorld_track0.boot \
	hellorld_track0.btxt \
	fibonacci_track0.boot \
	fibonacci_track0.btxt \
	erase_disk.btxt \

all: $(TAPES_PTP) $(TAPES_TXT) $(TAPES_BOOT) $(TAPES_BTXT) $(OTHER_TAPES)

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

# hellorld_track0 needs special handling to place the bootstrap in track 0.
hellorld_track0.boot: hellorld_track0.asm
	$(ASSEM) $(ASSEM_FLAGS) -b -A 0040 --bootstrap $@ $<

hellorld_track0.btxt: hellorld_track0.asm
	$(ASSEM) $(ASSEM_FLAGS) -A 0040 --bootstrap $@ $<

# fibonacci_track0 needs special handling to place the bootstrap in track 0.
fibonacci_track0.boot: fibonacci_track0.asm
	$(ASSEM) $(ASSEM_FLAGS) -b -A 0040 --bootstrap $@ $<

fibonacci_track0.btxt: fibonacci_track0.asm
	$(ASSEM) $(ASSEM_FLAGS) -A 0040 --bootstrap $@ $<

# erase_disk needs the bootstrap placed at the very end of the disk.
erase_disk.btxt: erase_disk.asm
	$(ASSEM) $(ASSEM_FLAGS) -A 6359 -D 0 --compact-bootstrap $@ $<

1dlife.ptp: random.asm
1dlife.txt: random.asm
1dlife.boot: random.asm
1dlife.btxt: random.asm
rand_test.ptp: random.asm
rand_test.txt: random.asm
rand_test.boot: random.asm
rand_test.btxt: random.asm

clean:
	rm -f $(TAPES_PTP) $(TAPES_TXT) $(TAPES_BOOT) $(TAPES_BTXT) $(OTHER_TAPES)
