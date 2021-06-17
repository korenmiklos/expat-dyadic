---
title: "Foreign Markets and Foreign Managers"
author: 
 - Miklós Koren
 - Krisztina Orbán
 - Álmos Telegdy
aspectratio: 16
---

# Motivation
## The end of a Qatari project in Budapest
\exhibit{kopaszi.jpg}

## The end of a Qatari project in Budapest
* Qatari real estate investors made several high-value investments in Budapest in 2015 (Brückner 2021).
* For them, however, the projects were small, not worth delegating an expatriate manager.
* Business deals, even simple decisions often took months.
* Finally, they sold their stake in December 2020.

## Research question
* What role do expatriate managers play in foreign direct investment?
* Do they facilitate trade with their "home country"?

# Data
## Data
* Administrative data on *all* Hungarian corporations, 1992--2018.
* Financial data, trade transactions (1992--2003)

## Largest investment partners of Hungary 1992--2003
\exhibit{map.png}

## Foreign owners often replace managers
\exhibit{sample-size.png}

## Inferring ethnicity from name
\begin{tabular}{lll|ccc}
Address & Name & Partner & \texttt{count} & \texttt{lang} & \texttt{ethn} \\
\hline
DE & Klaudia Wolf & DE & 1 & 1 & 1\\
DE & Klaudia Wolf & AT & 0 & 1 & 1\\
DE & Klaudia Wolf & IT & 0 & 0 & 0\\
\hline
DE & Enrico Mazzanti & DE & 1 & 1 & 0\\
DE & Enrico Mazzanti & AT & 0 & 1 & 0\\
DE & Enrico Mazzanti & IT & 0 & 0 & 1\\
\hline
IT & Fioretta Luchesi & DE & 0 & 0 & 0 \\
IT & Fioretta Luchesi & AT & 0 & 0 & 0 \\
IT & Fioretta Luchesi & IT & 1 & 1 & 1 
\end{tabular}

## Estimating equation
For each firm-year, take 24 major partner countries. What is the hazard of starting to export/import to/from that country?

$$
\Pr(X_{ict}=1|X_{ict-1}=0) = 
\alpha_{ic} + \mu_{ct} + \nu_{it} 
$$
$$
{}+ \beta_o \text{OWNER}_{ict} 
{}+ \beta_m \text{MANAGER}_{ict} 
{}+ u_{ict}
$$

## Large and permanent effects on exports
\exhibit{event_study_export.png}

## And on imports
\exhibit{event_study_import.png}

# Discussion 

## Effects are large
### Fixed-cost estimates in Halpern, Koren and Szeidl (2015)
Equivalent to \$12-14,000 drop in fixed costs ''per year''.

\begin{tabular}{l|cc}
Scenario & Import hazard & Fixed cost \\
\hline
Average firm & 0.010 & \$15,000\\
Only owner & 0.081 & \$2,300\\
Only manager & 0.106 & \$1,700\\
Both & 0.226 & \$600
\end{tabular}

### Trade experience premia
Mion, Opromolla and Sforza (2016) estimate a 0.01--0.04 increase in hazard after manager with relevant export experience joins. Bisztray, Koren and Szeidl (2018) estimiate 0.002--0.005 peer effects in importing.


## Three stories
### Vertical integration 
Foreign owner takes over firm to export/import within own supply chain.

### Professional network
Managers help connect different firms within their professional network.

### Business culture
Managers know the business culture of their home country.

## Why managers matter
Three broader implications:

1. Trade within "supply chains" larger than previously thought.
2. Entry into new trade markets is inelastic.
3. Experience with existing partners leads to preferential attachment.

## Business network trade
* Contrary to evidence from US, investment in Hungary leads to large increases in trade with home region.

## Inelastic market entry 
* If professional networks are hard to build, extensive margin of trade is less responsive.
* Competitiveness leads to higher manager wages, not more entry.
* Complementarity of trade and migration policies.

## Preferential attachment 
* It may be easier to trade with friends of friends.
* We (will) highlight a mechanism for why that is.

# Conclusions 
## Conclusions 
* We find firm-level evidence that the nationality and ethnicity of owners and managers matters for the direction of trade.
* Whatever the specific mechanism, we need to model markets and individuals jointly.

