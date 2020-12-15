clear all
here
local here = r(here)

use "`here'/temp/analysis_sample.dta", clear

local LHS lnQ lnL lnQL lnKL TFP_cd exporter RperK
local dummies teaor08_2d##year
local treatments foreign foreign_hire has_expat

local fmode replace
foreach Y of var `LHS' {
	reghdfe `Y' `treatments', a(`dummies') cluster(originalid)
	outreg2 using "`here'/output/table/cross_section.tex", `fmode' `options'
	local fmode append
}