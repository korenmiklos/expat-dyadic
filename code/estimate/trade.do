clear all
here
local here = r(here)

do "`here'/code/estimate/header.do"
drop if country == "XX"
generate byte trade = export | import

* only use firms that will be taken over
foreach X of varlist trade either {
	egen ever_`X' = max(`X'), by(frame_id_numeric)
	egen min_`X' = min(cond(`X', year, .)), by(frame_id_numeric)
}
keep if ever_either

egen firm_market = group(frame_id_numeric country)
xtset firm_market year

local fmode replace
attgt export import, treatment(owner) aggregate(e) pre(3) post(5) notyet limitcontrol(year < min_either)
summarize export if e(sample), meanonly
outreg2 using "`here'/output/table/trade.tex", `fmode' $options ctitle(`title`sample'')

local fmode append
attgt export import, treatment(manager) aggregate(e) pre(3) post(5) notyet limitcontrol(year < min_trade)
outreg2 using "`here'/output/table/trade.tex", `fmode' $options ctitle(`title`sample'')
