all:
	cd ../../graphics && tar cf - `find . -type f -name "*.gif" -o -name "*.png"` | (cd ../demo/graphics; tar xf -)

clean:
	find . -name "*.gif" -exec rm {} \;
	find . -name "*.png" -exec rm {} \;
