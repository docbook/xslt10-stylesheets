# $Id$
#
TBLSOURCE=http://cm.bell-labs.com/7thEdMan/vol2/tbl
WGET=wget
WGETFLAGS=

GROFF=groff
GROFFFLAGS=

SED=sed
SEDFLAGS=

PS2PDF=ps2pdf
PS2PDFFLAGS=

all: tbl.txt tbl.pdf

tbl.ms:
	$(WGET) $(WGETFLAGS) -O $@ $(TBLSOURCE)

tbl.txt: tbl.ms
	cat $< \
	| $(SED) $(SEDFLAGS) 's/^\.TM.*$$//' \
	| $(SED) $(SEDFLAGS) 's/^gfont roman*$$//' \
	| $(SED) $(SEDFLAGS) 's/\.TL/.nr LL 66n\n.pl 1200i\n.nr HY 0\n.na\n.TL/' \
	| $(SED) $(SEDFLAGS) 's/\.po +3i/.po +4.4i/' \
	| GROFF_NO_SGR=1 $(GROFF) $(GROFFFLAGS) -e -t -ms -Tascii - \
	| $(SED) $(SEDFLAGS) 's/T\x08O/!/g' \
	| col -bx | cat -s \
	| $(SED) $(SEDFLAGS) 's/``/"/g' \
	| $(SED) $(SEDFLAGS) "s/\`/'/g" \
	| $(SED) $(SEDFLAGS) "s/''/\"/g" \
	> $@

tbl.pdf: tbl.ms
	cat $< \
	| $(SED) $(SEDFLAGS) 's/^\.TM.*$$//' \
	| $(SED) $(SEDFLAGS) 's/^gfont roman*$$//' \
	| $(SED) $(SEDFLAGS) 's/\.TL/.nr HY 0\n.na\n.TL/' \
	| $(GROFF) $(GROFFFLAGS) -e -t -ms - \
	| $(PS2PDF) $(PS2PDFFLAGS) - \
	> $@

clean:
	$(RM) tbl.txt
	$(RM) tbl.pdf
	$(RM) tbl.ms

# vim: number
