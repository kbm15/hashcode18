function [ k ] = optimize( entrada,  task, seed)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

R=entrada(1,1);
C=entrada(1,2);
F=entrada(1,3);
N=entrada(1,4);
B=entrada(1,5);
T=entrada(1,6);


crop=entrada([2:N+1],:);
distanceOf=abs(crop(:,1)-crop(:,3))+abs(crop(:,2)-crop(:,4));
% offset=([[crop([1:end],1); 0],[crop([1:end],2); 0],[0;crop([1:end],3)],[0;crop([1:end],4)]]);
% offset=offset([2:N+1],:);
% distance=abs(offset(:,1)-offset(:,3))+abs(offset(:,2)-offset(:,4));

% Generate dataset
discard=eye(N);
for i = 1:length(seed)
    discard(:,seed(i))=ones(N,1);
end
blocked=zeros(1,N);
numRides=zeros(1,F);
catBuf='';
cost=0;
localMax=0;

for k = 1:N %loop discard
    blocked=zeros(1,N);
    numRides=zeros(1,F);
    cost=0;
    localDis=0;
    bonusRide=0;
    for j = 1:F %loop pick ride
        currTim=0;
        currPos=zeros(1,2);
        for i = 1:N %let first one pick
            if (blocked(i)==0) && (discard(k,i)==0) && currTim<=crop(i,6)   %check if we picked that one
                %or if it is blocked
                arrive = calcDis(currPos(1,1),currPos(1,2), crop(i,1), crop(i,2)) + currTim;
                if arrive <= crop(i,5)
                    arrive = crop(i,5);
                    bonusRide=bonusRide+1;
                end
                cost = arrive + distanceOf(i);
                if cost <= crop(i,6)
                    blocked(i) = j;
                    currPos = [crop(i,3), crop(2,4)];
                    currTim=cost;
                    numRides(j)=numRides(j)+1;
                    localDis=localDis+distanceOf(i);
                end
            end
        end        
    end
    score=bonusRide*2+localDis;
    if localMax < score
        localMax=score;
        kmax=k;
    end
end

k=kmax;
blocked=zeros(1,N);
numRides=zeros(1,F);
cost=0;
localDis=0;
bonusRide=0;
for j = 1:F %loop pick ride
    currTim=0;
    currPos=zeros(1,2);
    localRides='';
    for i = 1:N %let first one pick
        if (blocked(i)==0) && (discard(k,i)==0)   %check if we picked that one
            %or if it is blocked
            arrive = calcDis(currPos(1,1),currPos(1,2), crop(i,1), crop(i,2)) + currTim;
            if arrive <= crop(i,5)
                arrive = crop(i,5);
                bonusRide=bonusRide+1;
            end
            cost = arrive + distanceOf(i);
            if cost < crop(i,6)
                blocked(i) = j;
                localRides=[localRides ' ' num2str(i-1) ];
                currPos = [crop(i,3), crop(2,4)];
                currTim=cost;
                numRides(j)=numRides(j)+1;
                localDis=localDis+distanceOf(i);
            end
        end
    end
    catBuf = [catBuf num2str(numRides(j)) localRides '\n'];    
end
fileName=['out/' task  '.out'];
fileID = fopen(fileName ,'w');
fprintf(fileID, catBuf);
fclose(fileID);



end

