# Highland of COVID-19 outside Hubei: epidemic characteristics, control and projections of Wenzhou, China

In late December 2019, Chinese authorities reported a cluster of pneumonia cases of unknown aetiology in Wuhan, China 1. A novel strain of coronavirus named Severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) was isolated and identified on 2 January 2020 2. Human-to-human transmission have been confirmed by a study of a family cluster and have occurred in health-care workers 3,4. Until 10 February 2020, 42638 cases of 2019 novel coronavirus disease (COVID-19) have been confirmed in China, of which 31728 came from Hubei Province (Figure). Wenzhou, as a southeast coastal city with the most cases (434) outside Hubei Province, its epidemiologic characteristics, policy control and epidemic projections have certain references for national and worldwide epidemic prevention and control. In this study, we described the epidemiologic characteristics of COVID-19 in Wenzhou and made a transmission model to predict the expected number of cases in the coming days.

__Assumption__:

* Infected individuals were not infectious during the incubation period
* Virus spread without variation (incubation time is a constant)
* Ignoring dead cases
* onset-to-admission and admission-to-discharged obbey weibull distribution

__Model__: 
* A SEIR model for COVID-19 transmission
 
![SEIR](https://github.com/ZhangBuDiu/WZ_COVID-19/images/SEIR.jpg)


* `S(t)` is the number of susceptible cases

* `E(t)` is the number of exposed cases

* `I(t)` is the number of infectious cases (individuals with illness onset)

* `C(t)` is the number of confirmed cases (individuals with hospital admission)

* `R(t)` is number of recovered cases

* `N(t)` is the number of resident population

* `cumI(t)` is cumulative number of infected cases

*  Based other research, mean incubation time for COVID-19 was five days.
