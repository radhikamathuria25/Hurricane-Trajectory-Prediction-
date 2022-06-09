%% This function computes the transition probabilities 

function computeTransitionProb(AA,step,current_loc,kernel,markovMat)
        
        flag           = 1; 
        lcc_loc(1)     = current_loc(1);
        lcc_loc(2)     = current_loc(2);

        %padding the Markov transition matrix
        zp_markovMat   =zeros(size(markovMat)+2*floor(kernel/2));
        zp_markovMat(ceil(kernel/2):end-floor(kernel/2),...
            ceil(kernel/2):end-floor(kernel/2))=markovMat;

        val_1          = lcc_loc(1)-floor(kernel*0.5);
        val_2          = lcc_loc(1)+floor(kernel*0.5);
        val_3          = lcc_loc(2)-floor(kernel*0.5);
        val_4          = lcc_loc(2)+floor(kernel*0.5);
        [~,c]          = size(zp_markovMat);

        if val_1<=0 || val_2>c || val_3<=0 || val_4>c
            flag       = 0;
        end

        if flag ~=0
            dataMat         = zp_markovMat(lcc_loc(1)-floor(kernel*0.5):lcc_loc(1)+floor(kernel*0.5),...
                         lcc_loc(2)-floor(kernel*0.5):lcc_loc(2)+floor(kernel*0.5));
            %denominator for prob
            total           = sum(dataMat,'all'); 
            prob_features   = dataMat/total; 
        else
            prob_features   = zeros(kernel);
        end

        prob_features_final = reshape(prob_features,1,[]);
        writematrix(prob_features_final,'prob.xls','WriteMode','append')

end 