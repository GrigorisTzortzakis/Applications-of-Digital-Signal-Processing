function x = GenOMP(D, y, T0, err)

K = size(D,2);          
x = zeros(K,1);         

r = y;                  
S = [];                 


while norm(r) > err && numel(S) < T0
   
    [~, k] = max(abs(D.' * r));
    if ismember(k, S)
      
        break
    end
    S = [S k];

 
    x(S) = pinv(D(:,S)) * y;

  
    r = y - D(:,S) * x(S);
end
end
