ifeq ($(REALLY),yes)
	GIT_CLEAN_FORCE = f
	CLEAN = rm
else
	GIT_CLEAN_FORCE = n
	CLEAN = @echo rm
endif

all:
	@echo "Available targets:"
	@echo " o download-all-sources - to verify that source tarballs are okay"
	@echo " o clean-app-tarballs - remove application source tarballs (save space)"
	@echo " o clean-packages - remove all built packages (to allow rebuild)"
	@echo " o clean-build-directories - remove src/ and pkg/ (save space)"
	@echo " o clean-prepare-for-build - prepare for rebuilding"
	@echo " o clean-all-but-built-packages - save space but allow installation later"
	@echo " o clean-all-ignored - remove all files from .gitignore"
	@echo ""
	@echo "All of the clean-* targets must have REALLY=yes specified for the action"
	@echo "to actually take effect (otherwise, the action is merely printed)"

.PHONY: all \
	clean-all-but-built-packages clean-all-ignored clean-app-tarballs \
	clean-build-directories clean-packages clean-prepare-for-build \
	download-all-sources

download-all-sources:
	for i in */; do (cd $$i; makepkg --nobuild --holdver ); done

clean-app-tarballs:
	for i in */; do ( cd $$i; \
		git clean -d$(GIT_CLEAN_FORCE)x -e src -e pkg -e '*.pkg.*' -e '*.src.tar.gz' . \
		); done

clean-packages:
	$(CLEAN) -f */*.pkg.* */*.src.tar.gz

clean-build-directories:
	$(CLEAN) -rf */src/ */pkg/

clean-prepare-for-build: clean-packages clean-build-directories

clean-all-but-built-packages: clean-app-tarballs clean-build-directories

clean-all-ignored:
	git clean -d$(GIT_CLEAN_FORCE)X .
