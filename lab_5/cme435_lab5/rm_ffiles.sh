#!/usr/bin/env bash

if [ -d "fx_coverage" ]; then
	rm -rf fx_coverage
fi

if [ -d "work" ]; then
	rm -rf work
fi

if [ -f *.ucdb ]; then
	rm *.ucdb
fi

if [ -f transcript ]; then
	rm transcript
fi

if [ -f *.rpt ]; then
	rm *.rpt
fi

if [ -d "fx_coverage/pdm_cov_html" ]; then
	rm -rf fx_coverage/pdm_cov_html
fi
