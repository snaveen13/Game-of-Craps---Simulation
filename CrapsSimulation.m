%% Simulation of the Game of Craps 
% The game of craps involves the shooter throwing two dice.  The payoff
% depends on the sum of the numbers on the dice.  This script simulates the
% proportion of times that the shooter wins.
% 
% <<../how-to-play-craps.jpg>>
%
% On the first roll of the two dice, the shooter
%
% * Automatically _wins_ if the numbers on the dice sum to 7 or 11, and
% * Automtically _loses_ if the numbers on the dice sum to 2, 3, or 12.
%
% If the first roll of the two dice results in a sum of 4, 5, 6, 8, 9, or
% 10, then the shooter rolls again and again until either
%
% * the sum is the same number as the first roll, in which case the shooter
% _wins_ , or
% * the sum is a 7, in which case the shooter _loses_.

%% 
function CrapsSimulation

%% Random variable generator giving wins and losses
% To perform the simulation we must create a function that produces
% |nRounds| of independent and identically distributed (IID) instances of
% the game of craps.  The function |craps| is defined at the end of this
% file.
%
% By providing an input to the function |craps|, we get an IID vector of
% wins (ones) or losses (zeros)

wins = craps(1000,10,100,800,1)

%% 
% And if we do it again, we get a different (random) output:

wins = craps(1000,10,100,800,1)

%% Computing the probability of a win by the shooter
% The probability of a win is _approximately_ the sample proportion (sample
% mean) of wins over a large number rounds.  For example

tic, probWin_8 = mean(craps(1000,10,100,800,10000)), toc
tic, probWin_12 = mean(craps(1000,10,100,1200,10000)), toc

%% Monte Carlo answers do _not_ converge montonically
% Suppose that we successively increase the number of observations by one
% and look how the sample mean approaches the true mean

tic
nSample = 100;
crapsResults = craps(1000,10,100,800,nSample);
probWinVec = cumsum(crapsResults)./(1:nSample)';
semilogx((1:nSample)',probWinVec,[1 nSample],[probWin_8 probWin_8],'--')
toc

%%
% As the plot shows, the approximations oscillate around the true answer,
% but the oscillations decrease in size as the sample size increases.
   
%% Craps function that provides |nRounds| of IID wins/losses
function wins = craps(start_amount, nRounds, betting_amount, win_amount, ngames)
   n = ngames; % Number of games
   wins(n,1) = false; %initialize a logica vector of size nRounds
   for j = 1:n % Player will play n games of round
       Amount = start_amount;
       for i = 1:nRounds %generate a vector
           firstRoll = sum(ceil(6*rand(1,2))); %sum of two dice, each uniformly having 1 through 6
           if any(firstRoll == [7 11]) %automatic win
               Amount = Amount + betting_amount; %Add betting amount to the actual amount
           elseif any(firstRoll == [2 3 12]) %automatic loss
               Amount = Amount - betting_amount; %Subtract betting amount to the actual amount
           else %firstRoll is a 4, 5, 6, 8, 9, or 10
               while true %keep rolling until win or lose
                   nextRoll = sum(ceil(6*rand(1,2))); %try to repeat firstRoll
                   if nextRoll == firstRoll %shooter wins
                       Amount = Amount + betting_amount;
                       break %round is over
                   elseif nextRoll == 7 %shooter loses
                       Amount = Amount - betting_amount;
                       break %round is over
                   end %otherwise roll again
               end
           end %the ith round is over
           if Amount >= win_amount
               wins(j) = true;
           else
               wins(j) = false;
           end
       end %nRounds rounds are over
   end %end of instance
end %end of craps function definition
end %end of crapsimulation
%%
% _Author: Naveen_