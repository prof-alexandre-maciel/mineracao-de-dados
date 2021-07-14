function [temp] = processamento_cluster_som(cc,entrada_quest_fim,entrada,classe)	

    %1� coluna: id �nico do jogador
    %2� coluna: id do jogo (1: memoriza��o, 2: jogo do offline, 3: tetris)
    
    cluster = load(strcat('dados/with_cluster/som.csv'));
    %----------------------------------------------------------------------
    temp = [];
    temp_total = 0; 
        
    [ay,ax] = size(entrada);    
    for k=1:numel(cluster)
        if(cluster(k)~=cc)
            continue;
        end
        %------------------------------------------------------------------
        id = entrada_quest_fim(k,1);
        for j=1:ay
            if (entrada(j,1)==id)
                temp_total = temp_total +1;
                temp(temp_total,:) = entrada(j, 2:ax); 
            end
        end
        %------------------------------------------------------------------
    end

    [ay,ax] = size(temp);
    temp(:,ax+1) = classe;