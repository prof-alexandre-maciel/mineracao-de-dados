%==========================================================================
function som_v1(iteracao, entrada_quest, entrada_quest_fim, entrada_benigno_som, entrada_maligno_som)
 
    [ay,ax] = size(entrada_quest);
    [by,bx] = size(entrada_quest_fim);
        
    [cy,cx] = size(entrada_benigno_som);
    [dy,dx] = size(entrada_maligno_som);
    
    C = unique(entrada_quest(:,1));% quantidade de jogadores que responderam algum questionário

    entradaa = zeros(numel(C),(ax-1)*3,'double');% 3 questionários intermediários, 1 questionário final, 12*3 tédio + 12*3 estresse
    entradab = zeros(numel(C),(bx-1),'double');
    entradac = zeros(numel(C),(cx-1)*438,'double');
    entradad = zeros(numel(C),(dx-1)*438,'double'); 
    
    for ii=1:numel(C)
        %--------3 questionários intermediários----------------------------
        vetor = find(entrada_quest(:,1)==C(ii));
        temp = reshape(entrada_quest(vetor,2:end)',1,[]);
        entradaa(ii,1:numel(temp)) = temp(:);
        %--------questionário final---------------------------------------- 
        vetor = find(entrada_quest_fim(:,1)==C(ii));
        temp = reshape(entrada_quest_fim(vetor,2:end)',1,[]);
        if(isempty(temp)==0) 
            entradab(ii,1:numel(temp)) = temp(:);
        end  
        %--------tédio----------------------------------------------------- 
        vetor = find(entrada_benigno_som(:,1)==C(ii));
        temp = reshape(entrada_benigno_som(vetor,2:end)',1,[]);
        entradac(ii,1:numel(temp)) = temp(:);
        %--------estresse-------------------------------------------------- 
        vetor = find(entrada_maligno_som(:,1)==C(ii));
        temp = reshape(entrada_maligno_som(vetor,2:end)',1,[]);
        entradad(ii,1:numel(temp)) = temp(:);
        %------------------------------------------------------------------
    end
    
    disp('======================');
    [ay,ax] = size(entradaa)
    [by,bx] = size(entradab)
    [cy,cx] = size(entradac)
    [dy,dx] = size(entradad)
    %----------------------------------------------------------------------
    for ii=1:numel(C)
        entrada(ii,:) = horzcat(entradaa(ii,:),entradab(ii,:),entradac(ii,:),entradad(ii,:));
    end
    %----------------------------------------------------------------------
    % 6 clusters
    dimx = 3;
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

  
    
    