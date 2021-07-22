function [train_accuracy, test_accuracy, TrainingTime, TestingTime]...
          = svm_kernel_v4(classes, kernel_int, iteracao, kernel_str, c_index, c, g_index, g, fold,...
                          pesos,...
                          saidasTreinamento, entradasTreinamento,...
                          saidasTeste, entradasTeste)
    
      %===================Sem pesos========================================
      opcao_type =  ['-s ' '0']; % multi-class classification
      %----------------------------------------- 
      str_kernel = int2str(kernel_int);   
      opcao_kernel = [' -t ' str_kernel]; % kernel_type
	  %--------------------------------------------------------------------
      str_cost = int2str(c);   
      opcao_cost = [' -c ' str_cost];
      %--------------------------------------------------------------------
      str_gama = int2str(g);
      opcao_gama = [' -g ' str_gama];
      %--------------------------------------------------------------------
      opcao = [opcao_type opcao_kernel opcao_cost opcao_gama];
      %opcao
      %-------treinamento da SVM-------------------------------------------
      start_time_train=cputime; 
      model = svmtrain(saidasTreinamento, entradasTreinamento, opcao);    
      end_time_train=cputime;
      TrainingTime = end_time_train-start_time_train;
    
      %Cálculo da acurância da rede em relação ao conjunto de treinamento--
      [predict_label_L_treino, accuracy_treino, dec_values_L_treino] = svmpredict(saidasTreinamento, entradasTreinamento, model); 
      if (isempty(accuracy_treino))
            accuracy_treino_value = 0;
      else
            accuracy_treino_value = accuracy_treino(1);
      end
      train_accuracy = accuracy_treino_value/100;

      
      %Cálculo da acurância da rede em relação ao conjunto de testes------- 
      start_time_test=cputime;
      [predict_label_L_teste, accuracy_teste, dec_values_L_teste] = svmpredict(saidasTeste, entradasTeste, model);
	  end_time_test=cputime;
      TestingTime = end_time_test-start_time_test;
      
      if (isempty(accuracy_teste))
            accuracy_teste_value = 0;
      else
            accuracy_teste_value = accuracy_teste(1);
      end
      test_accuracy = accuracy_teste_value/100;

      %---------------------------------------------------------------------
	  %		economia de tempo
	  %---------------------------------------------------------------------
	  if (isempty(accuracy_teste)~=1)
            confusao_funcao_svm(saidasTreinamento, predict_label_L_treino,...
                                saidasTeste, predict_label_L_teste,...
                                iteracao, kernel_str, c_index, g_index, fold);
      end               
                      
      