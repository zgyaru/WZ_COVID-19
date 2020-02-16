### sampling

### onset-to-admission and admission-to-discharged 
### distribution were estimated by fitting a Weibull
### distribution on the date of of illness onset, 
### first medical visit, and hospital admission in 
### a subset of cases with detailed information available


### @param: De:  incubation period
### @param: Di_start:  initial of onset-to-admission
### @param: Dc_start:  initial of admission-to-discharged
### @param: Di_shape:  shape parameter of weibull distribution, 
###                   defined by onset-to-admission 
### @param: Di_scale:  scale parameter of weibull distribution, 
###                   defined by onset-to-admission 
### @param: Dc_shape:  shape parameter of weibull distribution, 
###                   defined by admission-to-discharged 
### @param: Dc_scale:  scale parameter of weibull distribution, 
###                   defined by admission-to-discharged
### @param: N0: total number of city
### @param: E0: initial number of Exposed cases
### @param: I0: initial number of Infected cases
### @param: C0: initial number of Confirmed (admission) cases
### @param: R0: initial number of Recovered cases
### @param: cumI: initial cumulative number of infected cases
### @param: cumC: initial cumulative number of confirmed cases
### @param: Ae_func: function of daily imported exposed cases
### @param: Ai_func: function of daily imported infected cases
### @param: fit_cumI: cumulative number of infected cases 
###                    used for fitting parameters 
### @param: estimate_t: time sequence used for fitting parameters
### @param: predict_t: time sequence used for prediction
### @parma: n_samples: number of sampling
### @param: tao: time of policy control



MCMC = function(De, Di_start, Dc_start,
                Di_shape, Dc_shape,
                Di_scale, Dc_scale,
                N0, E0, I0, C0, R0, cumI, cumC,
                Ae_func, Ai_func,
                fit_cumI,
                estimate_t, predict_t,
                n_samples = 10,
                tao){
  
  bs = function(De, Di, Dc) {
    simulator = ODEModel_estimate_Iv1(N, E0, I0, C0, R0, cumI, cumC,
                                      De, Di, Dc, 
                                      Ae_func, Ai_func, 
                                      tao, 
                                      estimate_t)
    
    model = nls(fit_cumI ~ simulator(beta,m),start = list(beta = 0.5, m=0.02))
    model
  }
  
  samples = NULL
  predict_C = NULL
  predict_E = NULL
  predict_I = NULL
  predict_R = NULL
  predict_cumI = NULL
  predict_cumC = NULL
  predict_R0 = NULL
  
  
  chain_Di = c(Di_start)
  chain_Dc = c(Dc_start)
  
  ### add first Di Dc
  ## estimate beta and m
  #print(chain_Di[1])
  #print(chain_Dc[1])
  model = bs(De, chain_Di[1], chain_Dc[1])
  #print(model)
  beta_hat = coef(model)[1][[1]]
  m_hat = coef(model)[2][[1]]
  ## predict
  #estim_r0 = coef(model)[1][[1]]
  #print(Ae_func)
  expected = ODEModel_predict(N, E0, I0, C0, R0, cumI, cumC,
                              De, chain_Di[1], chain_Dc[1], 
                              Ae_func, Ai_func, 
                              beta_hat,m_hat,
                              tao, 
                              predict_t)
  ##R0
  p_R0 = beta_hat*exp(-m_hat*predict_t+m_hat*tao)*chain_Di[1]
  predict_R0 = rbind(predict_R0, p_R0)
  ## combine data
  curr_rand = c(De, chain_Di[1], chain_Dc[1], beta_hat, m_hat)
  samples = rbind(samples, curr_rand)
  predict_C = rbind(predict_C, expected$C)
  predict_E = rbind(predict_E, expected$E)
  predict_I = rbind(predict_I, expected$I)
  predict_R = rbind(predict_R, expected$R)
  predict_cumI = rbind(predict_cumI, expected$cumI)
  predict_cumC = rbind(predict_cumC, expected$cumC)
  
  
  n=2
  
  while(n < n_samples){
    
    err=0
    #print(n)
    if(n%%100 == 0){
      print(n)
    }
    ## next Di
    Di_proposal = chain_Di[n-1] + runif(1,-1,1)
    Di_Accept = runif(1,0.8,1)<dweibull(Di_proposal, Di_shape, Di_scale)/dweibull(chain_Di[n-1], Di_shape, Di_scale)
    
    ## next Dc
    Dc_proposal = chain_Dc[n-1] + runif(1,-1,1)
    Dc_Accept = runif(1,0.8,1)<dweibull(Dc_proposal, Dc_shape, Dc_scale)/dweibull(chain_Dc[n-1], Dc_shape, Dc_scale)
    #print(Di_Accept)
    #print(Dc_Accept)
    if( is.na(Di_Accept) || is.na(Dc_Accept)){
      Di_Accept = FALSE
    }
    if(Di_Accept && Dc_Accept){
      
      tryCatch(
        {model = bs(De, Di_proposal, Dc_proposal)},
        error = function(e){
          err = 1
        }
      )
      if(err == 1) {next}
      
      
      if(model$convInfo$isConv) {
        beta_hat = coef(model)[1][[1]]
        m_hat = coef(model)[2][[1]]
        #estim_r0 = coef(model)[1][[1]]
        if(beta_hat>0 && m_hat>0){
          
          ## predict
          expected = ODEModel_predict(N, E0, I0, C0, R0, cumI, cumC,
                                      De, Di_proposal, Dc_proposal, 
                                      Ae_func, Ai_func, 
                                      beta_hat,m_hat,
                                      tao, 
                                      predict_t)
          p_R0 = beta_hat*exp(-m_hat*predict_t+m_hat*tao)*Di_proposal
          predict_R0 = rbind(predict_R0, p_R0)
          
          ## combine data
          curr_rand = c(De, Di_proposal, Dc_proposal, beta_hat, m_hat)
          samples = rbind(samples, curr_rand)
          predict_C = rbind(predict_C, expected$C)
          predict_E = rbind(predict_E, expected$E)
          predict_I = rbind(predict_I, expected$I)
          predict_R = rbind(predict_R, expected$R)
          predict_cumI = rbind(predict_cumI, expected$cumI)
          predict_cumC = rbind(predict_cumC, expected$cumC)
          
          chain_Di[n] = Di_proposal
          chain_Dc[n] = Dc_proposal
          
          n = n+1
        }
      }
    }
  }
  
  samples = as.data.frame(samples)
  names(samples) = c('De','Di','Dc','beta','m')
  list(params = samples,
       R0 = predict_R0,
       E = predict_E,
       I = predict_I,
       C = predict_C,
       R = predict_R,
       cumC = predict_cumC,
       cumI = predict_cumI)
}

