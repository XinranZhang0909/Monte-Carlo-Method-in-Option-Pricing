r=0.03;sig=0.3;S0=100;K=100;T=5;
N=100000;dt=1/252;M=T*252;
mu=0;
p = zeros(1,N);
for i=1:N
    S=zeros(1,M+1);% within each path: S1,S2,...
    xi=randn(1,M);
    S(1)=S0;
        for k=1:M
            S(k+1)=S(k)+S(k)*r*dt+S(k)*sig*sqrt(dt)*xi(k);
        end % one whole path is generated
    mu=mu+max(mean(S)-K,0);
    p(i) = max(mean(S)-K,0);
end

mu=exp(-r*T)*mu/N
MCstd = std(p)/sqrt(N)