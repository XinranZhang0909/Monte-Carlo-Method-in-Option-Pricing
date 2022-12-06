function output = BS_European_Call(S, K, sigma, r, T);
%usage BS_European_Call(S,K,sigma,r,T)
%computes European call option value in the Black-Scholes model
d1 = (log(S/K)+(r+sigma^2/2)*T)/(sigma*sqrt(T));
d2 = (log(S/K)+(r-sigma^2/2)*T)/(sigma*sqrt(T));
output = S*normcdf(d1)-K*exp(-r*T)*normcdf(d2);
%normcdf_d1 = 1/2 - erf(-(d1-log(S/K))/(sigma*sqrt(2)))/2;
%normcdf_d2 = 1/2 - erf(-(d2-log(S/K))/(sigma*sqrt(2)))/2;
%output = S*normcdf_d1-K*exp(-r*T)*normcdf_d2;