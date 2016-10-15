BOXCTL_VERSION  =  0.3
# $(shell date +%Y%m%d)
BOXCTL_BUILDID  = 0
# $(shell date +%H%M%S)
SPEC_FILE  = rpm/SPECS/boxctl.spec

.PHONY: all dirs rpm clean

all: clean dirs rpm

dirs: ;
	@[ -d rpm/RPMS/noarch/ ] || mkdir -p rpm/RPMS/noarch/
	@[ -d rpm/BUILD/ ] || mkdir -p rpm/BUILD/

rpm: ;
	@rpmbuild -bb --define="Version $(BOXCTL_VERSION)"  --define="Release $(BOXCTL_BUILDID)"  $(SPEC_FILE)
	@mv rpm/RPMS/noarch/*.rpm .

clean: ;
	@rm -f ./*.rpm 
