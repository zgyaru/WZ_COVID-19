#### SEIR model

### @param: N0: total number of city
### @param: E0: initial number of Exposed cases
### @param: I0: initial number of Infected cases
### @param: C0: initial number of Confirmed (admission) cases
### @param: R0: initial number of Recovered cases
### @param: cumI: initial cumulative number of infected cases
### @param: cumC: initial cumulative number of confirmed cases
### @param: De:  incubation period
### @param: Di:  initial of onset-to-admission
### @param: Dc:  initial of admission-to-discharged
### @param: Ae: function of daily imported exposed cases
### @param: Ai: function of daily imported infected cases
### @param: tao: time of policy control
### @param: t: time sequence used for model



ODEModel_estimate_Iv1 = function(N, E0, I0, C0, R0, cumI, cumC,
                                 De, Di, Dc, 
                                 Ae, Ai, 
                                 tao = 13, 
                                 t) {
  
  
  func = function(t, y, parms) {
    
    S = y[1]
    E = y[2]
    I = y[3]
    C = y[4]
    R = y[5]
    cumI = y[6]
    cumC = y[7]
    
    beta = parms[1]
    m = parms[2]
    
    
    beta_t = beta*exp(-m*t+m*tao)
    dS = -beta_t * S * I / N
    dE = beta_t * S * I / N - E/De + Ae
    dI = E/De - I/Di + Ai
    dC = I/Di - C/Dc
    dR = C/Dc
    dcumI = E/De + Ai
    dcumC = I/Di
    
    list(c(dS, dE, dI, dC, dR, dcumI, dcumC))
  }
  
  simulate = function(beta, m) {
    # param[1]: beta
    # param[2]: m
    y = c(N-E0-I0-C0-R0, E0, I0, C0, R0, cumI, cumC)
    param = c(beta, m)
    sim = deSolve::ode(y=y, times =t, func=func, parms=param)
    cumI=sim[,7]
    cumI
  }
  simulate
}







ODEModel_predict = function(N, E0, I0, C0, R0, cumI, cumC,
                            De, Di, Dc, 
                            Ae_func, Ai_func, 
                            beta, m,
                            tao = 13, 
                            t){
                 
  func = function(t, y, parms) {
    
    S = y[1]
    E = y[2]
    I = y[3]
    C = y[4]
    R = y[5]
    cumI = y[6]
    cumC = y[7]
    
    beta = parms[1]
    m = parms[2]
    
    beta_t = beta*exp(-m*t+m*tao)
    dS = -beta_t * S * I / N
    dE = beta_t * S * I / N - E/De + Ae_func
    dI = E/De - I/Di + Ai_func
    dC = I/Di - C/Dc
    dR = C/Dc
    dcumI = E/De + Ai_func
    dcumC = I/Di
    
    list(c(dS, dE, dI, dC, dR, dcumI, dcumC))
  }
  
  #print(t)
  #print(m)
  y = c(N-E0-I0-C0-R0, E0, I0, C0, R0, cumI, cumC)
  
  sim = deSolve::ode(y=y, times=t, func=func, parms = c(beta,m))
  t=sim[,1]
  S=sim[,2]
  E=sim[,3]
  I=sim[,4]
  C=sim[,5]
  R=sim[,6]
  cumI=sim[,7]
  cumC=sim[,8]
  list(E = E, I=I, C=C, cumI=cumI, cumC=cumC, R=R)
}



