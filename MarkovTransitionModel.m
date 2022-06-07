%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script models the hurricane data as a Markov Transition Process 
% by computing the storm displacement probabilities and storing them as a
% matrix. 

% Authors:      Hari Prasad Sankar
%               Radhika Anish Mathuria 
%               Sangeetha Vishwanathan Sakthivel 

% Date created: May 12th, 2022
% Modiied:      May 30th, 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clearvars 

set(0,'DefaultFigureWindowStyle','docked')
plot=0;                            % flag for plots, set to 1 if you want the plots

hurdat_file=readtable('lstm.csv'); % read the HURDAT2 data 
T=hurdat_file(:,26:27);            % selecting the LCC x and y coordinates for processing
T=table2array(T);

% step size
step_size    = 10^5;               % This can be larger, or smaller depending on whether 
                                   % a coarse/fine estimation of probabilities is required

%% starting window    
lcc          = reshape(T(T>=0),[],2);

%% defining the matrix bounds 

x_min        = min(lcc(:,1));
y_min        = min(lcc(:,2));
x_max        = max(lcc(:,1));
y_max        = max(lcc(:,2));

start_pt     =[x_min y_min];

%defining the sliding window for the grid transition probability
%computation
cell_a       =start_pt;
cell_b       =[start_pt(1),start_pt(2)+step_size];
cell_c       =[start_pt(1)+step_size,start_pt(2)+step_size];
cell_d       =[start_pt(1)+step_size,start_pt(2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Getting probability

x_itr            =floor((x_max-x_min)/step_size);
y_itr            =floor((y_max-y_min)/step_size);
temp_cell_a      =cell_a;
temp_cell_b      =cell_b;
temp_cell_c      =cell_c;
temp_cell_d      =cell_d;
markovMat        =zeros(y_itr,x_itr); % Transition Probability Matrix

for j=1:y_itr 
    for i=1:x_itr
        xInd     =find(lcc(:,1)>=cell_a(1) & lcc(:,1)<=cell_d(1)); %find x coordinates within those bounds
        
        if(~isempty(xInd))
            yInd =find(lcc(:,2)>=cell_a(2) & lcc(:,2)<=cell_b(2));
        end 

        boundInd =intersect(xInd,yInd);
        markovMat(j,i)=length(boundInd);

        if plot==1
            scatter(lcc(:,1),lcc(:,2))
            hold on;
            AA   =[cell_a;cell_b;cell_c;cell_d];
            scatter(AA(:,1),AA(:,2));
            hold off;
        end

        cell_a   =cell_d;
        cell_b   =cell_c;
        cell_c   =[cell_c(1) + step_size, cell_c(2)];
        cell_d   =[cell_d(1)+step_size , cell_d(2)];
    end
    cell_a       =[temp_cell_a(1),temp_cell_a(2)+(j)*step_size];
    cell_b       =[temp_cell_b(1),temp_cell_a(2)+(j+1)*step_size];
    cell_c       =[temp_cell_c(1),temp_cell_a(2)+(j+1)*step_size];
    cell_d       =[temp_cell_d(1),temp_cell_a(2)+(j)*step_size];
end

%% storm transition probability matrix 

kernel_size             = 5; 

for i=1:length(lcc)
    curr_loc            = LCC_find(step_size,lcc(i,1),lcc(i,2),x_itr,y_itr,temp_cell_a,temp_cell_d,temp_cell_c,temp_cell_b);
    if (curr_loc ~=0)
        computeTransitionProb(temp_cell_a,step_size,curr_loc,kernel_size,markovMat);
    end

end 


%% find cell range corresponding to a certain LCC coordinate

function returnMatInd = LCC_find(step_size,lccX,lccY,x_itr,y_itr,cell_a,cell_d,cell_c,cell_b)

flag=0;
temp_cell_a      =cell_a;
temp_cell_b      =cell_b;
temp_cell_c      =cell_c;
temp_cell_d      =cell_d;
returnMatInd     =0;
    for j=1:y_itr
        for i=1:x_itr
            if(lccX>=cell_a(1) && lccY<=cell_d(1))
                if(lccY>=cell_a(2) && lccY<=cell_b(2))
                    returnMatInd=[j i];
                    flag=1;
                    break;
                else
                    returnMatInd=0;
                end
            end 
            cell_a   =cell_d;
            cell_b   =cell_c;
            cell_c   =[cell_c(1) + step_size, cell_c(2)];
            cell_d   =[cell_d(1)+step_size , cell_d(2)];
        end

        if(flag==1)
            break;
        end 

        cell_a       =[temp_cell_a(1),temp_cell_a(2)+(j)*step_size];
        cell_b       =[temp_cell_b(1),temp_cell_a(2)+(j+1)*step_size];
        cell_c       =[temp_cell_c(1),temp_cell_a(2)+(j+1)*step_size];
        cell_d       =[temp_cell_d(1),temp_cell_a(2)+(j)*step_size];

    end 
end 
