deploy:
	git push origin main
	git tag новый_тег
	git push --tags
