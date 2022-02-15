here
local here = r(here)

use "`here'/temp/analysis_sample_dyadic.dta"
keep frame_id_numeric year country export manager time_foreign owner_spell teaor08_2d  
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

egen export_before = max(export & time_foreign < 0), by(frame_id_numeric country)

tabulate export_before export

tabulate manager export if time_foreign > 0 & !missing(time_foreign ), row
tabulate manager export if !export_before & time_foreign > 0 & !missing(time_foreign ), row

reghdfe export manager export_before if time_foreign > 0 & !missing(time_foreign ), a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
reghdfe export manager if !export_before & time_foreign > 0 & !missing(time_foreign ), a(frame_id_numeric##year cc##year) cluster(frame_id_numeric )
