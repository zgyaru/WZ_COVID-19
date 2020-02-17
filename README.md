# Highland of COVID-19 outside Hubei: epidemic characteristics, control and projections of Wenzhou, China

In late December 2019, Chinese authorities reported a cluster of pneumonia cases of unknown aetiology in Wuhan, China 1. A novel strain of coronavirus named Severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) was isolated and identified on 2 January 2020 2. Human-to-human transmission have been confirmed by a study of a family cluster and have occurred in health-care workers 3,4. Until 10 February 2020, 42638 cases of 2019 novel coronavirus disease (COVID-19) have been confirmed in China, of which 31728 came from Hubei Province (Figure). Wenzhou, as a southeast coastal city with the most cases (434) outside Hubei Province, its epidemiologic characteristics, policy control and epidemic projections have certain references for national and worldwide epidemic prevention and control. In this study, we described the epidemiologic characteristics of COVID-19 in Wenzhou and made a transmission model to predict the expected number of cases in the coming days.

In this study, we customised four SEIR model across Wenzhou, Shenzhen, Zhengzhou and Harbin. We first gathered information on the dates of illness onset, hospitalization, and clinical status. This Epidemiologic were collected from the the National Health Commission of the People’s Republic of China and the Health Commission of different country by February 10, 2020. 

We estimate SEIR parameters through the cumulative number of infected patients using non-linear least squares method. Initial number of exposed, infected, confirmed and recovered cases were estimated by obtained data. Resident population of countries were obtained from public data. 


__Assumption__:

* Infected individuals were not infectious during the incubation period
* Virus spread without variation (incubation time is a constant)
* Ignoring dead cases
* onset-to-admission and admission-to-discharged obey weibull distribution

__Model__: 

* A customized SEIR model for COVID-19 transmission:
 
 <div align=center><img width="200" height="280" src="https://github.com/ZhangBuDiu/WZ_COVID-19/blob/master/images/SEIR.png"/> </div>

* `S(t)` is the number of susceptible cases
* `E(t)` is the number of exposed cases
* `I(t)` is the number of infectious cases (individuals with illness onset)
* `C(t)` is the number of confirmed cases (individuals with hospital admission)
* `R(t)` is number of recovered cases
* `N(t)` is the number of resident population
* `cumI(t)` is cumulative number of infected cases
* `De` is incubation time
* `Di` is the time from the onset of symptoms to hospitalization (a measure of the period of infectiousness in the community)
* `Dc` is the time frome hospitalization to discharged

In addition, we assumed that transmission rate would continuously increases before policy intervention and falls after it.

<div align=center><img width="130" height="30" src="https://github.com/ZhangBuDiu/WZ_COVID-19/blob/master/images/beta.png"/> </div>

* `𝛽` is the basic person-to-person transmission rate per day in the absence of control interventions,
* `𝜏` is the time when the policy intervention began
* `m` is the decay of transmission rate due to interventions

__Parameter estimate__:
* The number of cumulative infected cases were obtained to estimating unknown parameters by using nonlinear least squares method. 
Di and Dc were obey Weibull distribution in which parameters of distribution were fitted by the subset of cases with detailed information available. 

* Initial number of cases:

|  |  <strong>N</strong> | <strong>E</strong> | <strong>I</strong> | <strong>C</strong> | <strong>R</strong> |
| :-----:| :----: | :----: | :----: | :----: | :----: |
| Wenzhou | 9,600,000 | 2 | 1 | 0 | 0 |
| Zhengzhou1 | 10，140，000 | 2 | 1 | 0 | 0 |
| Zhengzhou2 |  10，140，000 | 20 | 15 | 38 | 0 |
| Shenzhen |  13,026,600 | 8 | 9 | 0 | 0 |
| Harbin | 9,550,000 | 10 | 0 | 0 | 0 |


__Simulation__:
* We use Di and Dc as prior distribution for Markov chain Monte Carlo (MCMC) simulations. The mean time for incubation time is chosen as 5 days. The algorithm was ran for 5,000 iterations with a burn-in of 3000 iterations.

__Results__:

* estimated parameters of model:

|  |  <strong>Di</strong> | <strong>Dc</strong> | <strong>R0</strong> |
| :-----:| :----: | :----: | :----: |
| Wenzhou | 5.96 [3.18, 6.39] | 13.02 [11.07, 13.87] | 2.91[2.35,3.57] |
| Zhengzhou | 6.58 [5.69, 7.65] | 12.18 [11.59，12.78] | 5.95 [5.36, 6.67] |
| Shenzhen | 5.66 [4.14, 7.18] | 14.37 [13.32, 15.34] | 2.53 [1.86,3.34] |
| Harbin | 6.26 [5.71, 6.80] | 12.27 [11.42, 13.84 ] | 3.35 [3.07,3.68] |

* forcasting spread of COVID-19:

|  |  <strong>Peak size</strong> | <strong>Peak Date (2020)</strong> |
| :-----:| :----: | :----: |
| Wenzhou | 538.37 [534.91,542.75] | 0305-0309 |
| Zhengzhou | 191.25 [190.53，192.06] | 0307-0310 |
| Shenzhen | 438.92 [437.58, 438.92] | 0303-0306 |
| Harbin | 191.96 [197.86, 192.15 ] | 0308-0312 |

* daily infected cases (not admission):

![countries](https://github.com/ZhangBuDiu/WZ_COVID-19/blob/master/images/countries.png)
