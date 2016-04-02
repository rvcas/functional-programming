.SUFFIXES: .eventlog .exe

RTSFLAGS = +RTS -K2000M -N -s -ls
GHC = ghc
GHCFLAGS = -O2
GHCRTSFLAGS = -threaded -rtsopts -eventlog
RM = rm -f

%.eventlog: %.exe
	./$< $(RTSFLAGS)

%.exe: %.hs
	$(GHC) $(GHCFLAGS) $< $(GHCRTSFLAGS)

clean:
	$(RM) *.o *.hi *.exe *.eventlog
