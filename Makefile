BOXCTL_VERSION  =  0.1
# $(shell date +%Y%m%d)
BOXCTL_BUILDID  = 0
# $(shell date +%H%M%S)
SPEC_FILE  = rpm/SPECS/boxctl.spec

.PHONY: all rpm clean

all: clean rpm

rpm: ;\
  rpmbuild -bb --define="Version $(BOXCTL_VERSION)"  --define="Release $(BOXCTL_BUILDID)"  $(SPEC_FILE) && \
  mv rpm/RPMS/noarch/*.rpm . ;

clean: ;\
  rm -f ./*.rpm ;
