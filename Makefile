all: target lint site

target:
	mkdir -p target

scsslint:
	scss-lint -c .scss-lint.yml 

cname: target
	echo "www.seedramp.com" > target/CNAME

robots.txt: target
	echo "" > target/robots.txt

images: target
	cp -R images target

sass: target sass/*.scss
	mkdir -p target/css
	sass --style=compressed --sourcemap=none sass/index.scss target/css/index.css 
	sass --style=compressed --sourcemap=none sass/safe.scss target/css/safe.css 

site: sass cname images robots.txt

lint: scsslint

clean:
	rm -rf target

