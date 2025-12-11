PDK_ROOT ?= ../gf180mcu_pdk
PDK ?= gf180mcuD

all: logo drc
.PHONY: all

logo:
	python3 ../ip/gf180mcu_ws_ip__logo/script/make_gds.py wafer_space_logo.png big_logo.gds --cellname big_logo --invert --pixel-size 3.4 --foreground "34/0" "36/0" "42/0" "46/0" "30/0" "81/0" --boundary "0/0" "152/5"
.PHONY: logo

drc:
	echo "calma read big_logo.gds;load big_logo;lef write -pinonly;" | PDK_ROOT=${PDK_ROOT} PDK=${PDK} magic -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc -dnull -noconsole
	PDK_ROOT=${PDK_ROOT} PDK=${PDK} klayout -b -zz -r ${PDK_ROOT}/${PDK}/libs.tech/klayout/tech/drc/gf180mcu.drc -rd input=big_logo.gds -rd report=report.lyrdb -rd feol=false -rd beol=true
.PHONY: drc
