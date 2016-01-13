all: target lint site

target:
	mkdir -p target

scsslint:
	scss-lint -c .scss-lint.yml 

target/CNAME: target
	echo "www.seedramp.com" > target/CNAME

target/robots.txt: target
	echo "" > target/robots.txt

target/images/logo.svg: target
	cp -R images target

target/index.html: target pages/*.haml
	haml --style=ugly pages/index.haml > target/index.html
	haml --style=ugly pages/safe.haml > target/safe.html

target/css/index.css: target sass/*.scss
	mkdir -p target/css
	sass --style=compressed --sourcemap=none sass/index.scss target/css/index.css 
	sass --style=compressed --sourcemap=none sass/safe.scss target/css/safe.css 

site: target/index.html target/css/index.css target/CNAME target/images/logo.svg target/robots.txt

lint: scsslint

clean:
	rm -rf target

