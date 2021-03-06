# This is a makefile for runnig 16-S pipeline#
.PHONY: all test clean
TOP_DIR := $(shell pwd)
THIRD_PARTY := $(TOP_DIR)/src/tools
MOTHUR := https://github.com/mothur/mothur/archive
SILVA := http://www.mothur.org/w/images/2/27/
TEST_DATA := http://www.mothur.org/w/images/d/d6

all: mothur;

mothur: ;
	wget -P $(THIRD_PARTY) $(MOTHUR)/v1.35.0.tar.gz
	tar -C $(THIRD_PARTY) -xzvf $(THIRD_PARTY)/v1.35.0.tar.gz && mv $(THIRD_PARTY)/mothur-1.35.0 $(THIRD_PARTY)/Mothur && rm $(THIRD_PARTY)/Mothur/source/makefile && cp $(TOP_DIR)/makefile $(THIRD_PARTY)/Mothur/source
	make -C $(THIRD_PARTY)/Mothur/source
	wget -P $(THIRD_PARTY)/test-data $(TEST_DATA)/MiSeqSOPData.zip
	unzip -C $(THIRD_PARTY)/test-data/MiSeqSOPData.zip && mv $(TOP_DIR)/MiSeq_SOP $(THIRD_PARTY)/test-data && mv $(TOP_DIR)/__MACOSX $(THIRD_PARTY)/test-data 
	wget -P $(THIRD_PARTY) $(SILVA)/Silva.nr_v119.tgz
	tar -C $(THIRD_PARTY) -xzvf $(THIRD_PARTY)/Silva.nr_v119.tgz && mv $(THIRD_PARTY)/silva.nr_v119.* $(THIRD_PARTY)/test-data/MiSeq_SOP 
	cp $(TOP_DIR)/Make_OTU.sh $(THIRD_PARTY)/test-data/MiSeq_SOP
	cp $(THIRD_PARTY)/Mothur/source/mothur $(THIRD_PARTY)/test-data/MiSeq_SOP
	cd $(THIRD_PARTY)/test-data/MiSeq_SOP && bash $(THIRD_PARTY)/test-data/MiSeq_SOP/Make_OTU.sh
	cp $(TOP_DIR)/Phyloseq.R $(THIRD_PARTY)/test-data/MiSeq_SOP
	R CMD BATCH Phyloseq.R
	
