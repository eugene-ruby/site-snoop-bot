deploy:
	git push origin main
	git tag -a v1.0 -m "Новая версия"
	git push --tags
