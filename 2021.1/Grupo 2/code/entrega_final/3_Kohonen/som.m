%==========================================================================
function som(iteracao, entrada_quest, entrada_quest_fim, entrada_benigno_som, entrada_maligno_som)
 
    [ay,ax] = size(entrada_quest_fim)
    [by,bx] = size(entrada_quest)
    
    entrada_quest_fim
    entrada_quest
    
    [cy,cx] = size(entrada_benigno_som)
    [dy,dx] = size(entrada_maligno_som)
    
    [entrada_1] = reshape_matrix(entrada_quest_fim, entrada_quest,(bx-1)*3);    
    [entrada_2] = reshape_matrix(entrada_quest_fim, entrada_benigno_som,(cx-1)*36);
    [entrada_3] = reshape_matrix(entrada_quest_fim, entrada_maligno_som,(cx-1)*36);

    [ey,ex] = size(entrada_1);    
    
    [ey,ex] = size(entrada_1)
    [fy,fx] = size(entrada_2)
    [gy,gx] = size(entrada_3)
    dsfsaf
    %----------------------------------------------------------------------
    for ii=1:ey
        entrada(ii,:) = horzcat(entrada_1(ii,:),entrada_quest_fim(ii,2:ax),entrada_2(ii,:),entrada_3(ii,:));
    end
    %----------------------------------------------------------------------
    % 6 clusters
    dimx = 4;
    dimy = 2;
    [cluster] = som_auxiliar(iteracao, entrada', dimx, dimy);
    save(strcat('dados/with_cluster/som.csv'),'cluster', '-ASCII');

%==========================================================================
function [entrada] = reshape_matrix(entrada_quest_fim, entrada_quest,dimx)

    %----------------------------------------------------------------------
    [ay,ax] = size(entrada_quest_fim);
    [by,bx] = size(entrada_quest);
    %----------------------------------------------------------------------
    %elimina a primeira coluna porque é o id do jogador vs 3 jogos
    entrada = zeros(ay,dimx,'double');
    AA = zeros(1,dimx,'double');

    index_total = 0;

    for i=1:ay
        ii = entrada_quest_fim(i,1); %id do usuário 
        C = (entrada_quest(:,1)==ii);
        %------------------------------------------------------------------
        temp = [];
        temp_total = 0; 
        for j=1:numel(C)
            if(C(j)==0)
                continue;
            end
            temp_total = temp_total +1;
            temp(temp_total,:) = entrada_quest(j,:); 
        end
        %------------------------------------------------------------------
        temp(:,1) = [];      
        
        index_total = index_total+1;
        temp = reshape(temp',1,[]);
        [ty,tx] = size(temp);
        if(tx<dimx)            

            temp = [temp, zeros(1, length(AA) - length(temp))];
        end
        entrada(index_total, :) = temp;
    end
    
%==========================================================================
function [temp] = som_auxiliar(iteracao, mapa, dimx, dimy)

    mapa
    total_cluster = dimx*dimy;

    % Number of Attributes vs Number of Instances 
    norm_samples = mapa;
    samples = norm_samples;
    
    net = selforgmap([dimx dimy]);
    net.trainParam.epochs = 1000;
    RandStream.setGlobalStream (RandStream ('mrg32k3a','Seed', iteracao));
    net = train(net,norm_samples);

    hh = plotsompos(net, norm_samples);

    distances = dist(norm_samples',net.IW{1}');
    [d,temp] = min(distances,[],2); % cndx contains the cluster index

  
    
    