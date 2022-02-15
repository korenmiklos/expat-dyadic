here
local here = r(here)

use "`here'/temp/analysis_sample_dyadic.dta"
keep frame_id_numeric year country export manager time_foreign owner_spell teaor08_2d  
reshape wide export manager, i(frame_id_numeric year) j(country) string

egen byte acquired_in_sample = max(time_foreign == 0), by(frame_id_numeric )
tabulate acquired_in_sample 
keep if acquired_in_sample 
drop acquired_in_sample 
egen byte acquired_in_sample = max(time_foreign <= -1), by(frame_id_numeric )
tabulate acquired_in_sample 
keep if acquired_in_sample 
drop acquired_in_sample 

tabulate time_foreign exportDE if abs(time_foreign) <= 2, row
tabulate time_foreign managerDE if abs(time_foreign) <= 2, row
tabulate time_foreign exportIT if abs(time_foreign) <= 2, row
tabulate time_foreign managerIT  if abs(time_foreign) <= 2, row

egen exportDE_before = max(exportDE & time_foreign < 0), by(frame_id_numeric )
egen exportIT_before = max(exportIT & time_foreign < 0), by(frame_id_numeric )

tabulate exportDE_before exportDE 
tabulate exportIT_before exportIT 

tabulate managerDE exportDE if !exportDE_before & time_foreign < 0 & !missing(time_foreign ), row
tabulate managerDE exportDE if !exportDE_before & time_foreign > 0 & !missing(time_foreign ), row
tabulate managerIT exportIT if !exportIT_before & time_foreign > 0 & !missing(time_foreign ), row
tabulate managerIT exportDE if !exportDE_before & time_foreign > 0 & !missing(time_foreign ), row
tabulate managerDE exportIT if !exportIT_before & time_foreign > 0 & !missing(time_foreign ), row

tabulate managerIT exportIT if time_foreign > 0 & !missing(time_foreign ), row
tabulate managerDE exportDE if time_foreign > 0 & !missing(time_foreign ), row
tabulate managerDE exportIT if time_foreign > 0 & !missing(time_foreign ), row
tabulate managerIT exportDE if time_foreign > 0 & !missing(time_foreign ), row

reghdfe managerDE exportDE if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe managerIT exportIT if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe exportDE managerDE  if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe exportIT managerIT if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe exportIT managerDE if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe exportDE managerIT if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )

reghdfe exportDE exportIT  managerDE managerIT  exportDE_before exportIT_before   if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
reghdfe exportIT exportDE  managerDE managerIT  exportDE_before exportIT_before   if time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )

reghdfe exportDE managerDE  if !exportDE_before & time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
tabulate exportDE managerDE if e(sample), col

reghdfe exportIT managerIT  if !exportIT_before & time_foreign > 0 & !missing(time_foreign ), a(teaor08_2d##year) cluster(frame_id_numeric )
tabulate exportIT managerIT if e(sample), col
