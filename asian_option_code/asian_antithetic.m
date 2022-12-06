% antithetic
r=0.03;sig=0.3;S0=100;K=100;T=5;
N=100000;dt=1/252;M=T*252;
mu1=0;
mu2=0;
p = zeros(1,N);
for i=1:N
    S1=zeros(1,M+1);% within each path: S1,S2,...
    S2=zeros(1,M+1);
    xi=randn(1,M);
    S1(1)=S0;
    S2(1)=S0;
    for k=1:M
        S1(k+1)=S1(k)+S1(k)*r*dt+S1(k)*sig*sqrt(dt)*xi(k);
    end % one whole path is generated
    for k=1:M
        S2(k+1)=S2(k)+S2(k)*r*dt-S2(k)*sig*sqrt(dt)*xi(k);
    end % one whole path is generated
    mu1=mu1+max(mean(S1)-K,0);
    mu2=mu2+max(mean(S2)-K,0);
    p(i) = (max(mean(S2)-K,0)+max(mean(S1)-K,0))/2;
end
mu=exp(-r*T)*(mu1+mu2)/2/N
MCstd = std(p)/sqrt(N)
%Z(k)=S*exp((r-0.5*sig^2)*T+sig*sqrt(T)*Y(k))