here
local here = r(here)

use "`here'/temp/analysis_sample_dyadic.dta"
keep frame_id_numeric year country export import manager manager_comlang owner owner_comlang time_foreign teaor08_2d  
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
foreach X in export import {
    reghdfe `X' manager owner `X'_before if `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    reghdfe `X' manager owner if !`X'_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    reghdfe `X' manager owner if !`X'_anywhere_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
}

tabulate manager export if `timing', row
tabulate manager export if !export_before & `timing', row

foreach X in export import {
    reghdfe `X' manager* owner* `X'_before if `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    reghdfe `X' manager* owner* if !`X'_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
    reghdfe `X' manager* owner* if !`X'_anywhere_before & `timing', a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
}
