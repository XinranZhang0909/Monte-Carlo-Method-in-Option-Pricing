S0=100;
vol=0.3;
K=100;
r=0.03;
T=5;
Simu=100000; %monte carlo runs for standard method
[Price_AM,CI_AM,Price,CI] = asiancall_mc_cv(S0,K,r,T,vol,Simu)


function [Price_AM,CI_AM,Price,CI] = asiancall_mc_cv(S0,K,r,T,vol,Simu);
%   usage AsianCall_mc_cv(S0,K,r,T,vol,Simu)
%   Input S0,K,r,T,vol,Simulation 
%   Output- Arithmetic Average Asian Call option price
%   Price_AM - Price of Arithmetic asian option ,
%   CI_AM- Confidence interval of the Arithmetic asian option 
%   Price - Price of Geometric asian option  
%   CI - Confidence interval of the Geometric asian option
%   Author sudhanshu chadha
%   For details refer to Monte Carlo Simulation and Finance by Don L. McLeish 
Total_time =round(T*252);
dt= T/Total_time;
yield =0;
R = exp(-r*T);
for j = 1:Simu%Simulations
    m = (r - yield - vol^2/2)*dt;
    s = vol*sqrt(dt);
    Z= m+s*randn(1,Total_time);
    S = cumsum([log(S0), Z],2);
    arithmetic_mean = mean(exp(S));
    geometric_mean=exp(mean(S));
    
    Vcall= max([arithmetic_mean-K;zeros(1)]);
    VGcall= max([geometric_mean-K;zeros(1)]);

    MCmean_simulation(1,j)=  Vcall;
    MCVGmean_simulation(1,j)=  VGcall;

end
    MCmean = mean(MCmean_simulation); 
    MCstd = std(MCmean_simulation)/sqrt(Simu);

    muG = 1/2*(r-vol^2/2)*(1+1/Total_time);
    sigmaG = sqrt((vol^2)/3*(1+1/Total_time)*(1+1/(2*Total_time)));
    S0GM = S0*exp(T*((sigmaG^2)/2+muG-r));
    GA_calloption = BS_European_Call(S0GM,K,sigmaG,r,T);
    C = cov(MCmean_simulation,MCVGmean_simulation);
    b = C(1,2)/C(1,1);
    
    CV = (R*MCmean_simulation) -b*((R*MCVGmean_simulation) - GA_calloption);
    CVmean = mean(CV);
    CVstd = std(CV)/sqrt(Simu);


quant = 0.95;
xi = norminv(quant);
lb = MCmean -xi* MCstd/2;
ub = MCmean +xi* MCstd/2;
lbCV = CVmean -xi* CVstd/2;
ubCV = CVmean +xi* CVstd/2;
Price_AM = MCmean;
CI_AM = [lb ub];
Price = CVmean;
CI = [lbCV ubCV];
end