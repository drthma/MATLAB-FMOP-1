w1=0.5; %weight of the first objective
w2=0.5; %weight of the second objective
obj1=[-2,3,1,0]; %first objective, max
obj2=[-2,1,0,1]; %second objective, max
LHS_C=[2 0 0 0; 0 4 0 0; -1 0 0 0; 0 -1 0 0]; %LHS of the constraints
RHS_C=[7;9;-1;-1];  %RHS of the constraints
alpha=0.36;
fznum1=[0,1,3,5]; %intervals of the first fuzzy number
fznum2=[1,6,7,9]; %intervals of the second fuzzy number
syms x;

%The following is solving the member ship function using the alpha cut in
%order to get the ranges of the fuzzy number

    accepted=[];%array that carries only the accepted ranges of the first fuzzy number
    
    %The first part of the membership  function
    s=solve((1-((x - fznum1(2))/(fznum1(1)-fznum1(2)))^2)>= alpha,x);
    interval=double(s(1));%converts symbolic answer to double
    
    %we have to make sure that the ranges falls in the interval of the
    %membership function
    
    if interval(1)>= fznum1(1)&& interval(1) <= fznum1(2)
        accepted(end+1)=interval(1); %add to the end of the accepted array
    end
    
    if interval(2)>= fznum1(1)&& interval(2) <= fznum1(1)
        accepted(end+1)=interval(2);
    end
    
    %the second part of the membership function
    s2=solve((1-((x - fznum1(3))/(fznum1(4)-fznum1(3)))^2)>= alpha,x);
    interval2=double(s2(1)); %converts symbolic answer to double
    
    %we have to make sure that the ranges falls in the interval of the
    %membership function
    
    if interval2(1)>= fznum1(3)&& interval2(1) <= fznum1(4)
        accepted(end+1)=interval2(1);
    end
    
    if interval2(2)>= fznum1(3)&& interval2(2) <= fznum1(4)
        accepted(end+1)=interval2(2);
    end
    
    fprintf('The final range of the fuzzy number #1')
    accepted
    
    accepted2=[]; %array that carries only the accepted ranges of the second fuzzy number
    
    %The first part of the membership  function
    s=solve((1-((x - fznum2(2))/(fznum2(1)-fznum2(2)))^2)>= alpha,x);
    
    interval=double(s(1)); %converts symbolic answer to double
    
    %we have to make sure that the ranges falls in the interval of the
    %membership function
    
    if interval(1)>= fznum2(1)&& interval(1) <= fznum2(2)
        accepted2(end+1)=interval(1); %add to the end of the accepted array
    end
    
    if interval(2)>= fznum2(1)&& interval(2) <= fznum2(1)
        accepted2(end+1)=interval(2);
    end
    
    %the second part of the membership function
    s2=solve((1-((x - fznum2(3))/(fznum2(4)-fznum2(3)))^2)>= alpha,x);
    interval2=double(s2(1)); %converts symbolic answer to double
    
    %we have to make sure that the ranges falls in the interval of the
    %membership function
    if interval2(1)>= fznum2(3)&& interval2(1) <= fznum2(4)
        accepted2(end+1)=interval2(1);
    end
    
    if interval2(2)>= fznum2(3)&& interval2(2) <= fznum2(4)
        accepted2(end+1)=interval2(2);
    end

    fprintf('The final range of the fuzzy number #2')
    accepted2
    
%multiply the objective functions by the weights and -1, since they are
%maximization, and add them together to have a single objective 

obj=-1*w1*obj1 +-1*w2*obj2;

%add four new constraints containing the two fuzzy numbers ranges
N_LHS_C=cat(1,LHS_C, [0 accepted(1) -1 0],[0 -1*accepted(2) 1 0],[ accepted2(1) 0 0 -1],[ -1*accepted2(2) 0 0 1]);
N_RHS_C=cat(1,RHS_C,[0;0;0;0]);

%solve the new problem using linear programming function
lb = zeros(4,1);
N_RHS_C
N_LHS_C
[x,fval]=linprog(obj,N_LHS_C,N_RHS_C,[],[],lb);
fprintf('The optimal objective function value :')
z=-fval
fprintf('The optimal values of the decision variables')
x

