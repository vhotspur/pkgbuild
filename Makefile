
all:


download-all-sources:
	for i in */; do (cd $$i; makepkg --nobuild --holdver ); done
