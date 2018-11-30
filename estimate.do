clear all
capture log close
log using output/estimate, text replace

use temp/analysis_sample

*Dinamika
scalar Tbefore = 4
scalar Tduring = 6
scalar Tafter = 4

gen byte analysis_window = (tenure>=-Tbefore-1)&(year-first_exit_year<=Tafter)

local sample_baseline (analysis_window==1)
local sample_manufacturing `sample_baseline' & (manufacturing==1)
local sample_acquisitions `sample_baseline' & (greenfield==0)

local samples baseline manufacturing acquisitions

local outcomes lnL lnKL lnQL exporter
label var lnL "Employment (log)"
label var lnKL "Capital per worker (log)"
label var lnQL "Revenue per worker (log)"
label var exporter "Firm is an exporter (dummy)"

egen person_tag = tag(frame_id manager_id)
egen N = sum(person_tag), by(frame_id)
gen inverse_weight = 1/N

xtset firm_person year
foreach X of var `outcomes' {
	foreach sample in `samples' {
		xtreg `X' foreign during after during_expat after_expat i.ind_year i.age_cat if `sample_`sample'' [aw=inverse_weight], i(firm_person ) fe vce(cluster id)
		local r2_w = `e(r2_w)'
		do regram output/regression/`sample' `X' `X' R2_within "`r2_w'"

		local fname = e(depvar)
		local title : variable label `fname'

		slopegraph, ///
			from(0 0 1 _b[during] 0 0 1 _b[during]+_b[during_expat]) ///
			to(1 _b[during] 2 _b[after] 1 _b[during]+_b[during_expat] 2 _b[after]+_b[after_expat]) ///
			style(p1 p1 p2 p2) ///
			label("Local-during" "Local-after" "Expat-during" "Expat-after" ) ///
			width_test(during after==during during_expat after_expat==during_expat) ///
			star_test(1==1 1==1 during_expat after_expat) ///
			format(scheme(538w) xlabel(none) xtitle("") ytitle(`title') legend(off) aspect(0.67))

		graph export output/figure/`sample'_`fname'_slope.png, width(800) replace
	}
	xtreg `X' foreign during_?? after_?? i.ind_year i.age_cat if `sample_acquisitions' [aw=inverse_weight], i(firm_person ) fe vce(cluster id)
	local r2_w = `e(r2_w)'
	do regram output/regression/acquisitions_change `X' `X' R2_within "`r2_w'"
	do tree_graph

	foreach Y in `outcomes' {
		xtreg `X' foreign during after during_expat after_expat i.ind_year i.age_cat if `sample_acquisitions' & high_`Y' [aw=inverse_weight], i(firm_person ) fe vce(cluster id)
		local r2_w = `e(r2_w)'
		do regram output/regression/high_`Y' `X' `X' R2_within "`r2_w'"
	}
}

*Szelekció az akvicíziós mintában
xtset firm_person year
areg f1.expat `outcomes' if ever_foreign==1&greenfield!=1, a(industry_year) cluster(frame_id)
do regram output/regression/selection 1 1

keep if ever_foreign==1

foreach X in outcomes sample_acquisitions {
	global `X' ``X''
}
do event_study

log close
