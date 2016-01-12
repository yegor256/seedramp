all: target scsslint site

target:
	mkdir -p target

scsslint:
	scss-lint sass/*.scss

sass: target sass/*.scss
	mkdir -p target/css
	sass --style=compressed --sourcemap=none sass/index.scss target/css/index.css 
	sass --style=compressed --sourcemap=none sass/safe.scss target/css/safe.css 

site: 
	sass 

clean:
	rm -rf target

