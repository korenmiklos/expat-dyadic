clear all
here
local here = r(here)

use "`here'/temp/analysis_sample_dyadic.dta", clear
drop if country == "XX"

generate Ltrade = Lexport | Limport
generate Dtrade = Dexport | Dimport

local dummies frame_id_numeric##year cc##year frame_id_numeric##cc
local outcomes owner manager export import

local owner Lmanager Lexport Limport
local manager Lowner Lexport Limport
local export Lowner Lmanager Limport
local import Lowner Lmanager Lexport

local options keep(`treatments') tex(frag) dec(3)  nocons nonotes addstat(Mean, r(mean)) addtext(Firm-year FE, YES, Country-year FE, YES, Firm-country FE, YES)

local fmode replace
foreach Y in `outcomes' {
	* hazard of entering this market
	reghdfe D`Y' ``Y'' if L`Y'==0, a(`dummies') cluster(frame_id_numeric)
	summarize D`Y' if e(sample), meanonly
	outreg2 using "`here'/output/table/granger.tex", `fmode' `options' ctitle(`title`sample'')
	local fmode append
}

