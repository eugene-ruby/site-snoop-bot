deploy:
	@$(MAKE) deploy-bump BUMP=patch

deploy-minor:
	@$(MAKE) deploy-bump BUMP=minor

deploy-major:
	@$(MAKE) deploy-bump BUMP=major

deploy-bump:
	@git push origin main
	@latest_tag=$$(git tag | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$$' | sort -V | tail -n 1); \
	if [ -z "$$latest_tag" ]; then \
	  major=1; minor=0; patch=0; \
	else \
	  base=$$(echo $$latest_tag | sed 's/^v//'); \
	  major=$$(echo $$base | cut -d. -f1); \
	  minor=$$(echo $$base | cut -d. -f2); \
	  patch=$$(echo $$base | cut -d. -f3); \
	  if [ "$(BUMP)" = "patch" ]; then \
	    patch=$$((patch + 1)); \
	  elif [ "$(BUMP)" = "minor" ]; then \
	    minor=$$((minor + 1)); patch=0; \
	  elif [ "$(BUMP)" = "major" ]; then \
	    major=$$((major + 1)); minor=0; patch=0; \
	  fi; \
	fi; \
	new_tag="v$${major}.$${minor}.$${patch}"; \
	echo "🚀 Новый тег: $$new_tag"; \
	git tag -a $$new_tag -m "Release $$new_tag"; \
	git push origin $$new_tag
