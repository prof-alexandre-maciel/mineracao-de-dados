function mlp_main(entradaFim, classes, normalizar_entrada, entrada, aleatorio, casas, nucleos, classificador)
    
    %---------------------------------------------------------------------
    [conjunto] = getValidacaoTreinamentoMLP(entrada, aleatorio);
	[conjunto] = preencheDadosMLP(entradaFim, classes,conjunto);
    %----------------------------------------------------------------------
    total = 1;
    kMLP = 30;
	%vetortrain_accuracy = zeros(44,kMLP,'double');
	%vetortest_accuracy = zeros(44,kMLP,'double');
	%vetorTrainingTime = zeros(44,kMLP,'double');
	%vetorTestingTime = zeros(44,kMLP,'double');  
    
    vetortrain_accuracy = zeros(33,kMLP,'double');
	vetortest_accuracy = zeros(33,kMLP,'double');
	vetorTrainingTime = zeros(33,kMLP,'double');
	vetorTestingTime = zeros(33,kMLP,'double');  
    %----------------------------------------------------------------------
	for peso=1:kMLP 
		%------------------------------------------------------------------
        peso
        count = 0;
		%------------------------------------------------------------------	
		numEscondidos = 100; 
		totalnohiddenlayers = 2;
		for nohiddenlayers=1:totalnohiddenlayers 
			[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] = ...
			mlp_main_auxiliar(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
			 entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso);
        end
		%------------------------------------------------------------------	
		nohiddenlayers = 1;	
		numEscondidos = 500; 
	    [vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] = ...
		mlp_main_auxiliar(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
		entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso);
		%------------------------------------------------------------------
		%nohiddenlayers = 4;	
		%numEscondidos = (entradaFim*2)+1; 
		%numEscondidos
	    %[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] = ...
		%mlp_main_auxiliar(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
		%entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso);
		%------------------------------------------------------------------
    end 
    %-----------------------------------------------------------------------
	%qtd_vetor = zeros(1,4,'double');
    %number_vetor = zeros(1,4,'double');
    qtd_vetor = zeros(1,3,'double');
    number_vetor = zeros(1,3,'double');
    
    qtd_vetor(1) = 1;
    qtd_vetor(2) = 2;
    qtd_vetor(3) = 1;
	%qtd_vetor(4) = 4;
	
    number_vetor(1) = 100;
    number_vetor(2) = 100;
    number_vetor(3) = 500;
	%number_vetor(4) = numEscondidos;
	%----------------------------------------------------------------------
	bloxplot_funcao_MLP(qtd_vetor, number_vetor, 'MLP_v2', vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime);
	mlp_confusao_dados(qtd_vetor, number_vetor, classes, classificador);
	
    [global_kernel_max, nohiddenlayers_max, numEscondidos_max] = ...
    mlp_boxplot_dados(qtd_vetor, number_vetor, classificador, total);  
    
    mlp_hipotese_dados(global_kernel_max, nohiddenlayers_max, numEscondidos_max,...
                       qtd_vetor, number_vetor, classificador, total);
%==========================================================================
function [vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] = ...
	mlp_main_auxiliar(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
				  entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso)
  	
	%------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'trainb'); % Batch training with weight & bias learning rules
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traincgb'); % Powell -Beale conjugate gradient backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traincgf'); % Fletcher-Powell conjugate gradient backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traincgp'); % Polak-Ribiere conjugate gradient backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traingd');  % Gradient descent backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traingdm'); % Gradient descent with momentum backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traingda'); % Gradient descent with adaptive lr backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'traingdx'); % Gradient descent w/momentum & adaptive lr backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'trainoss'); % One step secant backpropagation
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'trainrp'); % Resilient backpropagation (Rprop)
    %------------------------------------------------------------------
	[vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,count] =...
	rodaMLP(vetortrain_accuracy, vetortest_accuracy, vetorTrainingTime, vetorTestingTime,...
    entradaFim, classes, normalizar_entrada, nohiddenlayers, conjunto, numEscondidos, count,peso, 'trainscg'); % Scaled conjugate gradient backpropagation		
    %------------------------------------------------------------------
	
%==========================================================================
function kernel = kernel2str(u)	

			if u==1
                kernel = 'trainb';
            elseif u==2
                kernel = 'traincgb';
			elseif u==3
                kernel = 'traincgf';
            elseif u==4
                kernel = 'traincgp';
            elseif u==5
                kernel = 'traingd';
            elseif u==6
                kernel = 'traingdm';
            elseif u==7
                kernel = 'traingda';
            elseif u==8
                kernel = 'traingdx';
            elseif u==9
                kernel = 'trainoss';
            elseif u==10
                kernel = 'trainrp';
            else
                kernel = 'trainscg';		
            end	
			
	     