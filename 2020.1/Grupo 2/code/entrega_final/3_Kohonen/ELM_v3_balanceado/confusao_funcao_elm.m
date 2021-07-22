function confusao_funcao_elm(saidasTreinamento, saidasRedeTreinamento,...
                             saidasTeste, saidasRedeTeste,...
                             iteracao, kernel, e_index, c_index, g_index, fold) 
    
    pasta = 'ELM_v3_balanceado';
    %----------------------------------------------------------------------
    [maiorTreinoSaidaRede, nodoTreinoVencedorRede] = max (saidasRedeTreinamento);
    [maiorTreinoSaidaDesejada, nodoTreinoVencedorDesejado] = max (saidasTreinamento);
    
    [maiorTesteSaidaRede, nodoTesteVencedorRede] = max (saidasRedeTeste);
    [maiorTesteSaidaDesejada, nodoTesteVencedorDesejado] = max (saidasTeste);
    
    %----------------------------------------------------------------------
    [vetor_C_train,order_C_train] = confusionmat(nodoTreinoVencedorDesejado, nodoTreinoVencedorRede); %saidasTreinamento, saidasRedeTreinamento);
    [vetor_C_test,order_C_test] = confusionmat(nodoTesteVencedorDesejado, nodoTesteVencedorRede);%saidasTeste, saidasRedeTeste);
    
    str = strcat(pasta,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_train_fold_',num2str(fold),'_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index),'.txt');
    save(str , 'vetor_C_train', '-ASCII');
  
       
    str = strcat(pasta,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_test_fold_',num2str(fold),'_escondida_',num2str(e_index),'_custo_',num2str(c_index),'_gamma_',num2str(g_index),'.txt');
    save(str , 'vetor_C_test', '-ASCII');
        
    
    