function confusao_funcao_svm(saidasTreinamento, saidasRedeTreinamento,...
                             saidasTeste, saidasRedeTeste,...
                             iteracao, kernel, c_index, g_index, fold) 
    
    pasta = 'SVM_v4_balanceado';

    %----------------------------------------------------------------------
    [vetor_C_train,order_C_train] = confusionmat(saidasTreinamento, saidasRedeTreinamento); %saidasTreinamento, saidasRedeTreinamento);
    [vetor_C_test,order_C_test] = confusionmat(saidasTeste, saidasRedeTeste);%saidasTeste, saidasRedeTeste);
    
    str = strcat(pasta,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_train_fold_',num2str(fold),'_custo_',num2str(c_index),'_gamma_',num2str(g_index),'.txt');
    save(str , 'vetor_C_train', '-ASCII');
          
    str = strcat(pasta,'/confusao/',num2str(iteracao),'/',kernel,'/vetor_C_test_fold_',num2str(fold),'_custo_',num2str(c_index),'_gamma_',num2str(g_index),'.txt');
    save(str , 'vetor_C_test', '-ASCII');
        