w1=0.5; %weight of the first objective
w2=0.5; %weight of the second objective
obj1=[6, 1 ,0]; %first objective 
obj2=[-1, 2 ,0 ]; %second objective
LHS_C=[3 2 -1; 5 0 0]; %LHS of the constraints
RHS_C=[0;9]; %RHS of the constraints
alpha=0.33;
fznum1=[1,6,7,9]; %intervals of the fuzzy number
syms x;

%The following is solving the member ship function using the alpha cut in
%order to get the ranges of the fuzzy number

    accepted=[];%array that carries only the accepted ranges
    
    %The first part of the membership  function
    s=solve((1-((x - fznum1(2))/(fznum1(1)-fznum1(2)))^2)>= alpha,x);
    interval=double(s(1)); %converts symbolic answer to double
    
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


%multiply the objective functions by the weights and -1, since they are
%maximization, and add them together to have a single objective
obj=-1*w1*obj1 +-1*w2*obj2; 

%add two new constraints containing the fuzzy numbers ranges
N_LHS_C=cat(1,LHS_C, [0 0 -1],[0 0 1 ]);
N_RHS_C=cat(1,RHS_C,[-1*accepted(1);accepted(2)]);

%solve the new problem using linear programming function

lb = zeros(3,1);
[x,fval]=linprog(obj,N_LHS_C,N_RHS_C,[],[],lb);
fprintf('The optimal objective function value :')
z=-fval
fprintf('The optimal values of the decision variables')
x
