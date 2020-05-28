low_svg=$(patsubst %, %.svg, $(shell seq 1 9))
high_svg=$(patsubst %, %.svg, $(shell seq 10 30))
low_png=$(patsubst %.svg, %.png, $(low_svg))
high_png=$(patsubst %.svg, %.png, $(high_svg))

all: $(low_svg) $(high_svg) $(low_png) $(high_png)

clean:
	rm -rf ./*.png
	rm -rf ./*.svg

$(low_svg): %.svg:
	convert -size 202x202 xc:green -transparent green -fill black -draw 'circle 100,100 30,30' -fill white -stroke none -pointsize 160 -gravity center -kerning -5 -font Helvetica-bold -draw "text 0,5 \"$*\"" -scale '24x24' $*.svg

$(low_png): %.png:
	convert -size 202x202 xc:green -transparent green -fill black -draw 'circle 100,100 30,30' -fill white -stroke none -pointsize 160 -gravity center -kerning -5 -font Helvetica-bold -draw "text 0,5 \"$*\"" -scale '24x24' $*.png

$(high_svg): %.svg:
	convert -size 202x202 xc:green -transparent green -fill black -draw 'circle 100,100 30,30' -fill white -stroke none -pointsize 140 -gravity center -kerning -5 -font Helvetica-bold -draw "text 0,5 \"$*\"" -scale '24x24' $*.svg

$(high_png): %.png:
	convert -size 202x202 xc:green -transparent green -fill black -draw 'circle 100,100 30,30' -fill white -stroke none -pointsize 140 -gravity center -kerning -5 -font Helvetica-bold -draw "text 0,5 \"$*\"" -scale '24x24' $*.png

