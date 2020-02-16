library(MASS)
library(stats)
# MCMC MH

true = read.table('../data/wenzhou/plot_0106_0210.txt',header = T)
true$case.type = factor(true$case.type,levels = c('local','input'))
cumI_seq = true$case[1:36]+ true$case[37:72]
cumI_seq = cumsum(cumI_seq)


##### De 
#### log-normal distribution
##

De = 5


## estimate parameters for Di
## Di: Days from Illness Onset to Hospitalization
## weibull distribution

Di_seq = read.table('../data/wenzhou/Di.txt')$V1
estim_Di = fitdistr(Di_seq[which(Di_seq>0)], densfun = "weibull", lower = 0)$estimate
Di_shape = estim_Di['shape'][[1]]
Di_scale = estim_Di['scale'][[1]]
Di_start = mean(Di_seq)



## estimate parameters for Dc
## Dc: Days from Hospitalization to discharged
## weibull distribution
Dc_seq = read.table('../data/wenzhou/Dc.txt')$V1
estim_Dc = fitdistr(Dc_seq, densfun = "weibull", lower = 0)$estimate
Dc_shape = estim_Dc['shape'][[1]]
Dc_scale = estim_Dc['scale'][[1]]
Dc_start = mean(Dc_seq)


Ae_func = function(x){
  1.95017737  * exp(-0.05975334*(x-10)*(x-10)+2.13281986)
}

Ai_func = function(x){
  2.04698026  * exp(-0.42743399*(x-11)*(x-11)+1.99714848)
}
Ae_func = 0
Ai_func = 0


N = 9600000
E0 = 2  #arive at wenzhou befor 1.10 (6) + 1.15 infections (4)
I0 = 1   #local infections befor 1.10
C0 = 0
R0 = 0
cumI = 1
cumC = 0

estimate_t = 0:29
predict_t = 0:80

#AeAi = read.table('../data/wenzhou/Ae_Ai.txt',header=T)
#Ae_seq = AeAi$Ae
#Ai_seq = c(0,diff(AeAi$Ai))


tao = 19



estimate_t = 0:30
fit_cumI = cumI_seq[1:(length(cumI_seq)-5)]
wenzhou = MCMC(De, Di_start, Dc_start,
          Di_shape, Dc_shape,
          Di_scale, Dc_scale,
          N0, E0, I0, C0, R0, cumI, cumC,
          Ae_func, Ai_func,
          fit_cumI,
          estimate_t, predict_t,
          n_samples = 5000,tao)

mean(wenzhou$R0[,1:36])
max(colMeans(wenzhou$cumI))
cumI_add = apply(wenzhou$cumI[,],1,diff)
median_addI = apply(t(cumI_add),2,median)  
predict_line = data.frame('time' = 4:76, 
                          'case' = median_addI[1:73],'type'=rep('input',73))

pdf('../res/wenzhou0216.pdf',width = 10,height = 5)
p = ggplot(true)
p = p + geom_bar(aes(x = time,y = case,fill = case.type),stat = 'identity',alpha=1)+ 
  scale_fill_manual(values = bar_color)
p= p+ geom_line(data = predict_line, aes(x=time,y=case),
                color = '#7E0019',linetype = "dashed",
                size=2,alpha=0.5)
p + theme_Publication()+
  #scale_fill_brewer(palette="Blues")+
  scale_y_continuous(expand = c(0, 0),breaks = c(1,10,20,30,40))+
  scale_x_continuous(expand = c(0, 0),
                     limits = c(-6,65),
                     breaks = seq(-4,65,2),
                     labels = as.character(c(seq(1,31,2),seq(2,29,2),seq(1,10,2))))+
  labs(y = 'No. of Cases')
dev.off()




##########shenzhen
true = read.table('../data/shenzhen/plot_0101_0207.txt',header = T)
true$case.type = factor(true$case.type,levels = c('local','input'))
cumI_seq = true[which(true$case.type == 'local'),'case'] + true[which(true$case.type=='input'),'case']
cumI_seq = cumsum(cumI_seq)

## estimate parameters for Di
## Di: Days from Illness Onset to Hospitalization
## weibull distribution

Di_seq = read.table('../data/shenzhen/Di.txt')$V1
estim_Di = fitdistr(Di_seq[which(Di_seq>0)], densfun = "weibull", lower = 0)$estimate
Di_shape = estim_Di['shape'][[1]]
Di_scale = estim_Di['scale'][[1]]
Di_start = mean(Di_seq)



## estimate parameters for Dc
## Dc: Days from Hospitalization to discharged
## weibull distribution
Dc_seq = read.table('../data/shenzhen/Dc.txt')$V1
estim_Dc = fitdistr(Dc_seq, densfun = "weibull", lower = 0)$estimate
Dc_shape = estim_Dc['shape'][[1]]
Dc_scale = estim_Dc['scale'][[1]]
Dc_start = mean(Dc_seq)


N = 13026600
E0 = 8  #arive at shenzhen befor 1.10 (6) + 1.15 infections (4)
I0 = 9   #local infections befor 1.10
C0 = 0
R0 = 0
cumI = 0
cumC = 0

estimate_t = 0:18
predict_t = 0:80

Ae_func=0
Ai_func=0

fit_cumI = cumI_seq[12:(length(cumI_seq)-5)]


tao = 11
estimate_t = 0:21

shenzhen = MCMC(De, Di_start, Dc_start,
          Di_shape, Dc_shape,
          Di_scale, Dc_scale,
          N0, E0, I0, C0, R0, cumI, cumC,
          Ae_func, Ai_func,
          fit_cumI,
          estimate_t, predict_t,
          n_samples = 500,tao)

#### from
cumI_add = apply(shenzhen$cumI[,],1,diff)
median_addI = apply(t(cumI_add),2,mean)  
predict_line = data.frame('time' = 13:76, 
                          'case' = median_addI[1:64],'type'=rep('input',64))
pdf('../res/shenzhen0216.pdf',width = 10,height = 5)
p = ggplot(true)
p = p + geom_bar(aes(x = time,y = case,fill = case.type),stat = 'identity',alpha=1)+ 
  scale_fill_manual(values = bar_color)
p= p+ geom_line(data = predict_line, aes(x=time,y=case),
                color = '#7E0019',linetype = "dashed",
                size=2,alpha=0.5)
p + theme_Publication()+
  #scale_fill_brewer(palette="Blues")+
  scale_y_continuous(expand = c(0, 0),breaks = c(1,10,20,30,40))+
  scale_x_continuous(expand = c(0, 0),
                     limits = c(0,70),
                     breaks = seq(1,70,2),
                     labels = as.character(c(seq(1,31,2),seq(2,29,2),seq(1,10,2))))+
  labs(y = 'No. of Cases')
dev.off()

### #################################zhengzhou
true = read.table('../data/zhengzhou/plot_0108_0210.txt',header = T)
true$case.type = factor(true$case.type,levels = c('local','input'))
cumI_seq = true[which(true$case.type == 'local'),'case'] + true[which(true$case.type=='input'),'case']
cumI_seq = cumsum(cumI_seq)

## estimate parameters for Di
## Di: Days from Illness Onset to Hospitalization
## weibull distribution

Di_seq = read.table('../data/zhengzhou/Di.txt')$V1
estim_Di = fitdistr(Di_seq[which(Di_seq>0)], densfun = "weibull", lower = 0)$estimate
Di_shape = estim_Di['shape'][[1]]
Di_scale = estim_Di['scale'][[1]]
Di_start = mean(Di_seq)



## estimate parameters for Dc
## Dc: Days from Hospitalization to discharged
## weibull distribution
Dc_seq = read.table('../data/zhengzhou/Dc.txt')$V1
estim_Dc = fitdistr(Dc_seq, densfun = "weibull", lower = 0)$estimate
Dc_shape = estim_Dc['shape'][[1]]
Dc_scale = estim_Dc['scale'][[1]]
Dc_start = mean(Dc_seq)

#####first
E0 = 2  #arive at shenzhen befor 1.10 (6) + 1.15 infections (4)
I0 = 1   #local infections befor 1.10
C0 = 0
R0 = 0
cumI = 1
cumC = 0

fit_cumI = cumI_seq[7:20]


tao = 9
estimate_t = 0:13


zhengzhou1 = MCMCv3(De, Di_start, Dc_start,
             Di_shape, Dc_shape,
             Di_scale, Dc_scale,
             N0, E0, I0, C0, R0, cumI, cumC,
             Ae_func, Ai_func,
             fit_cumI,
             estimate_t, predict_t,
             n_samples = 500,tao)
mean(zhengzhou1$R0[,1:14])
cumI_add1 = apply(zhengzhou1$cumI,1,diff)
median_addI1 = apply(t(cumI_add1),2,mean)  
predict_line1 = data.frame('time' = 7:21,
                           'case' = median_addI1[1:15],'type'=rep('input',15))


############second
E0 = 9  #arive at shenzhen befor 1.10 (6) + 1.15 infections (4)
I0 = 15   #local infections befor 1.10
C0 = 38
R0 = 0
cumI = 53
cumC = 38
#estimate_t = 0:24

fit_cumI = cumI_seq[20:(length(cumI_seq)-4)]


tao = 3
estimate_t = 0:10


zhengzhou2 = MCMCv3(De, Di_start, Dc_start,
             Di_shape, Dc_shape,
             Di_scale, Dc_scale,
             N0, E0, I0, C0, R0, cumI, cumC,
             Ae_func, Ai_func,
             fit_cumI,
             estimate_t, predict_t,
             n_samples = 500,tao)
cumI_add2 = apply(zhengzhou2$cumI,1,diff)
median_addI2 = apply(t(cumI_add2),2,mean)  
predict_line2 = data.frame('time' = 21:70, 
                           'case' = median_addI2[1:50],'type'=rep('input',50))


pdf('../res/zhengzhou0216.pdf',width = 10,height = 5)
p = ggplot(true)
p = p + geom_bar(aes(x = time,y = case,fill = case.type),stat = 'identity',alpha=1)+ 
  scale_fill_manual(values = bar_color)
p= p+ geom_line(data = predict_line1, aes(x=time,y=case),
                color = '#7E0019',linetype = "dashed",
                size=2,alpha=0.5)
p= p+ geom_line(data = predict_line2, aes(x=time,y=case),
                color = '#7E0019',linetype = "dashed",
                size=2,alpha=0.5)
p + theme_Publication()+
  #scale_fill_brewer(palette="Blues")+
  scale_y_continuous(expand = c(0, 0),breaks = c(1,10,20,30,40))+
  scale_x_continuous(expand = c(0, 0),
                     limits = c(-7,63),
                     breaks = seq(-6,62,2),
                     labels = as.character(c(seq(1,31,2),seq(2,29,2),seq(1,10,2))))+
  labs(y = 'No. of Cases')
dev.off()


########################harbin
true = read.table('../data/harbin/plot_0121_0209.txt',header = T)
true$case.type = factor(true$case.type,levels = c('local','input'))
cumI_seq = true[which(true$case.type == 'local'),'case'] + true[which(true$case.type=='input'),'case']
cumI_seq = cumsum(cumI_seq)

## estimate parameters for Di
## Di: Days from Illness Onset to Hospitalization
## weibull distribution

Di_seq = read.table('../data/harbin/Di.txt')$V1
estim_Di = fitdistr(Di_seq[which(Di_seq>0)], densfun = "weibull", lower = 0)$estimate
Di_shape = estim_Di['shape'][[1]]
Di_scale = estim_Di['scale'][[1]]
Di_start = mean(Di_seq)



## estimate parameters for Dc
## Dc: Days from Hospitalization to discharged
## weibull distribution
Dc_seq = read.table('../data/harbin/Dc.txt')$V1
estim_Dc = fitdistr(Dc_seq, densfun = "weibull", lower = 0)$estimate
Dc_shape = estim_Dc['shape'][[1]]
Dc_scale = estim_Dc['scale'][[1]]
Dc_start = mean(Dc_seq)


N = 9550000
E0 = 10  #arive at wenzhou befor 1.10 (6) + 1.15 infections (4)
I0 = 0   #local infections befor 1.10
C0 = 0
R0 = 0
cumI = 0
cumC = 0

estimate_t = 0:20
predict_t = 0:80

Ae_func=0
Ai_func=0

fit_cumI = c(0,cumI_seq[1:(length(cumI_seq)-3)])


tao = 10
estimate_t = 0:17


harbin = MCMCv3(De, Di_start, Dc_start,
            Di_shape, Dc_shape,
            Di_scale, Dc_scale,
            N0, E0, I0, C0, R0, cumI, cumC,
            Ae_func, Ai_func,
            fit_cumI,
            estimate_t, predict_t,
            n_samples = 500,tao)

cumI_add = apply(harbin$cumI,1,diff)
median_addI = apply(t(cumI_add),2,mean)  
predict_line = data.frame('time' = 1:51, 
                          'case' = median_addI[1:51],'type'=rep('input',51))
pdf('../res/harbin0216.pdf',width = 10,height = 5)
p = ggplot(true)
p = p + geom_bar(aes(x = time,y = case,fill = case.type),stat = 'identity',alpha=1)+ 
  scale_fill_manual(values = bar_color)
p= p+ geom_line(data = predict_line, aes(x=time,y=case),
                color = '#7E0019',linetype = "dashed",
                size=2,alpha=0.5)
p + theme_Publication()+
  #scale_fill_brewer(palette="Blues")+
  scale_y_continuous(expand = c(0, 0),breaks = c(1,10,20,30,40))+
  scale_x_continuous(expand = c(0, 0),
                     limits = c(-20,50),
                     breaks = seq(-19,50,2),
                     labels = as.character(c(seq(1,31,2),seq(2,29,2),seq(1,10,2))))+
  labs(y = 'No. of Cases')
dev.off()
