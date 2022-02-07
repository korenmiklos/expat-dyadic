here
local here = r(here)
local countries DE IT
local languages de it
char _dta[countries] `countries'
char _dta[languages] `languages'

generate str2 cnt = ""
foreach country in `countries' {
	generate byte owner`country' = (strpos(country_all_owner, "`country'") > 0) & !missing(country_all_owner)
	generate byte manager`country' = (strpos(country_all_manager, "`country'") > 0) & !missing(country_all_manager)
	generate byte language`country' = 0
	replace cnt = "`country'"
	do "`here'/code/util/language.do" cnt
	foreach lng in `languages' {
		* there is a language match if one of the CEOs speaks any language common with the country
		replace language`country' = 1 if (cnt_`lng' == 1) & (strpos(lang_all_manager, "`lng'") > 0)
	}
	drop cnt_??
}
tempvar knownowner knownmanager
egen `knownowner' = rowmax(owner??)
egen `knownmanager' = rowmax(manager??)

generate byte ownerXX = foreign & !`knownowner'
generate byte managerXX = has_expat & !`knownmanager'
generate byte languageXX = 0

drop `knownowner' `knownmanager' cnt

