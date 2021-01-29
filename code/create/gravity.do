clear all
here
local here = r(here)

use "`here'/input/cepii-geodist/geodist.dta"
keep if iso2_o == "HU"
keep iso2_d contig comlang_ethno smctry dist langoff_?_d

local languages German English Dutch Spanish Arabic French Italian Bulgarian Russian Czech Swedish Slovak
char _dta[languages] `languages'
foreach X in `languages' {
	generate byte `X' = 0
	forvalues i = 1/3 {
		replace `X' = 1 if langoff_`i'_d == "`X'"
	}
}
drop langoff_?_d
rename iso2_d country

save "`here'/temp/gravity.dta", replace
