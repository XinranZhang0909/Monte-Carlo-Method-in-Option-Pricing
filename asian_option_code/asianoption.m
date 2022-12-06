S0=100;
V=0.3;
K=100;
r=0.03;
T=5;
Nt=T*252; %number of trading days until maturity
Nc=1000;
Nruns=100000; %monte carlo runs for standard method
NrunsCV=10000; %monte carlo runs for control variate method

[ariAsianPriceMCCV error] = MCCVAsianOpt(S0,V,K,r,T,Nt,Nc,NrunsCV)

function price = geoAsianOpt(S0,sigma,K,r,T,Nt)

adj_sigma=sigma*sqrt((2*Nt+1)/(6*(Nt+1)));
rho=0.5*(r-(sigma^2)*0.5+adj_sigma^2);
d1 = (log(S0/K)+(rho+0.5*adj_sigma^2)*T)/(adj_sigma*sqrt(T));
d2 = (log(S0/K)+(rho-0.5*adj_sigma^2)*T)/(adj_sigma*sqrt(T));
price = exp(-r*T)*(S0*exp(rho*T)*normcdf(d1)-K*normcdf(d2));
end

function [price error] = MCCVAsianOpt(S0,sigma,K,r,T,Nt,Nc,Nruns)

dB = randn(Nt,Nruns);
dt=T/Nt;
k = r - (sigma^2)*0.5;
deterministic = repmat(k * dt * (1:Nt)',1,Nruns);
stochastic = sigma*sqrt(dt).*cumsum(dB);
paths = [repmat(S0,1,Nruns); S0 * exp(deterministic + stochastic)];

divisor=1/(Nt+1);
DF = exp(-r*T);

geoExact = geoAsianOpt(S0,sigma,K,r,T,Nt);

geoCallPrices = zeros(Nc,1);
ariCallPrices = zeros(Nc,1);

for i=1:Nc
pathVector = paths(:,i); 
avgPathPrice = sum(pathVector)*divisor;
geoCallPrices(i) = DF*max(geomean(pathVector) - K,0);
ariCallPrices(i) = DF*max(avgPathPrice - K,0);
end

MatCov = cov(geoCallPrices, ariCallPrices);
c = -MatCov(1,2)/var(geoCallPrices);

controlVars=zeros(Nruns,1);

for i=1:Nruns
pathVector = paths(:,i);
avgPathPrice = sum(pathVector)*divisor;
geoCallPrice = DF*max(geomean(pathVector) - K,0);
ariCallPrice = DF*max(avgPathPrice - K,0);
controlVars(i) = ariCallPrice + c * (geoCallPrice - geoExact);
end

price = mean(controlVars);
error = std(controlVars)/sqrt(Nruns);
end