clear all
capture log close
log using output/estimate, text replace

use temp/analysis_sample

local sample_baseline expat!=.&greenfield!=1
local sample_manufacturing `sample_baseline' & manufacturing==1
local sample_acquisitions `sample_baseline' & ever_foreign==1

local samples baseline manufacturing acquisitions

local scale lnL lnK lnQ
local intensity lnKL lnQL exporter inv

xtset id year
foreach sample in `samples' {
	foreach group in scale intensity {
		foreach X of var ``group'' {
			xtreg `X' foreign new fnew fnew_expat fold_expat i.ind_year i.age_cat if `sample_`sample'', i(id ) fe vce(cluster id)
			local r2_w = `e(r2_w)'
			do regram output/regression/`sample'_`group' `X' `X' R2_within "`r2_w'"
		}
	}
}

*Szelekció az akvicíziós mintában
xtset id year
areg f1.expat lnL lnQ lnK exporter if ever_foreign==1&greenfield!=1, a(industry_year) cluster(frame_id)
do regram output/regression/selection 1 1

*Akvizíciós minta (greenfield nélkül)
keep if ever_foreign==1&greenfield!=1
*Dinamika
scalar Tbefore = 4
scalar Tafter = 5

local N = Tbefore+Tafter+1

clonevar tenure_foreign = age_since_foreign

do event_study

local Tbefore = Tbefore
local Tafter = Tafter
foreach Y of var `scale' `intensity' {
	* with firm FE, controls are years more than Tbefore before any event happens
	xtreg `Y' *_m_? *_p_? i.ind_year i.age_cat if expat!=.&greenfield!=1 & ever_foreign==1, i(id) fe vce(cluster id)
	preserve
	clear
	set obs `N'
	gen t = _n-1-`Tbefore'
	label var t "Time since event (year)"

	foreach X in foreign expat domestic {
		gen `X'_beta=.
		gen `X'_lower=.
		gen `X'_upper=.
		forval t=-`Tbefore'/`Tafter' {
			local tag "`t'"
			if (`t'<0) {
				local tag = -`t'
				local tag  _m_`tag'
			}
			else {
				local tag  _p_`t'
			}
			replace `X'_beta = _b[`X'`tag'] if t==`t'
			replace `X'_lower = `X'_beta-1.69*_se[`X'`tag'] if t==`t'
			replace `X'_upper = `X'_beta+1.69*_se[`X'`tag'] if t==`t'
		}
		label var `X'_beta "`Y'"
		label var `X'_upper "90% CI"
		label var `X'_lower "90% CI"

	}
	label var foreign_beta "Foreign acquistion"
	label var expat_beta "New expat manager"
	label var domestic_beta "New domestic manager"
	* omit last event year from graph, which is winsorized
	tw (line foreign_beta expat_beta domestic_beta t if t>=-Tbefore & t<Tafter, sort), scheme(538w) title(`Y') aspect(0.67)
	graph export output/figure/`Y'_event_study.png, replace width(800)
	
	restore

}



log close
