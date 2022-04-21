here
local here = r(here)

use "`here'/temp/analysis_sample_dyadic.dta"
keep frame_id_numeric year country export import manager manager_comlang owner owner_comlang language time_foreign teaor08_2d  
drop if country=="XX"
egen cc = group(country)

egen byte acquired_in_sample = max(time_foreign == 0), by(frame_id_numeric )
tabulate acquired_in_sample 
keep if acquired_in_sample 
drop acquired_in_sample 
egen byte acquired_in_sample = max(time_foreign <= -1), by(frame_id_numeric )
tabulate acquired_in_sample 
keep if acquired_in_sample 
drop acquired_in_sample 

local timing time_foreign >= 0 & !missing(time_foreign)
foreach X in export import {
    egen `X'_before = max(`X' & time_foreign < 0), by(frame_id_numeric country)
    tabulate `X'_before `X'
    egen `X'_anywhere_before = max(`X'_before), by(frame_id_numeric)
}

rename manager ADDRESS
rename language NATIONALITY
generate byte LANGUAGE = NATIONALITY | manager_comlang 
rename owner ADDRESS_o
rename owner_comlang LANGUAGE_o 

local options tex(frag) dec(3)  nocons nonotes addstat(Mean, r(mean)) addtext(Firm-year FE, YES, Country-year FE, YES)

local fmode replace
foreach X in export import {
    reghdfe `X' ADDRESS NATIONALITY LANGUAGE if !`X'_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    summarize `X' if e(sample)
	outreg2 using "`here'/output/table/correlations.tex", `fmode' `options' ctitle(`X')
	local fmode append
    reghdfe `X' ADDRESS NATIONALITY LANGUAGE ADDRESS_o LANGUAGE_o if !`X'_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    summarize `X' if e(sample)
	outreg2 using "`here'/output/table/correlations.tex", `fmode' `options' ctitle(`X')
}
