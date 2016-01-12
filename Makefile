all: target scsslint site

target:
	mkdir -p target

site: 
	sass 

clean:
	rm -rf target

